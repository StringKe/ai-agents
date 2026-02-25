# SDLC 工作流规范

AI 辅助开发的核心工作流：**Research → Plan → Annotate → Todo List → Implement → Feedback**。

适用于所有项目（Java、TypeScript、基础设施等），与各项目全局 Prompt 中的 Plan Mode 规范配合使用。

---

## 核心原则

**在用户审阅并批准书面计划之前，绝不写代码。**

规划与执行分离是最重要的一件事。它能防止浪费精力，确保架构决策正确，并以极少的 token 消耗产出比直接生成代码更好的结果。

---

## 文件路径规范

研究报告和计划文件统一存放在：

```
docs/sdlc/YYYY-MM-DD/{slug}/
├── research.md   # 调研报告
└── plan.md       # 实现计划
```

`{slug}` 为任务短名，使用小写字母 + 连字符，描述本次工作内容，例如：
- `auth-kickout-fix`
- `task-broadcast-backpressure`
- `event-dispatcher-metrics`

创建命令：

```bash
mkdir -p docs/sdlc/$(date +%Y-%m-%d)/{slug}
```

---

## Phase 1：Research（深度调研）

### 强制行为

接到任务时，**先调研，后计划，后实现**——绝不跳步。

使用"deeply"、"in great detail"、"intricacies"等词是信号，不是废话。没有这些词，调研容易浮于表面——读一个文件，看看函数签名就算了。**调研结果必须写入 `docs/sdlc/YYYY-MM-DD/{slug}/research.md`，禁止只给口头摘要。**

### 为什么写 research.md

`research.md` 是用户的审阅界面：读它可验证 AI 真正理解了系统，在计划开始前纠正错误假设。最昂贵的失败模式不是语法错误，而是实现了一个孤立运作但破坏周边系统的功能：忽略了现有缓存层的函数、不符合 ORM 约定的迁移、重复了已有逻辑的 API 端点。Research 阶段能阻止所有这些。

存放在 `docs/sdlc/YYYY-MM-DD/{slug}/` 下的好处：按日期 + 任务归档、Git 追踪历史、实现完成后无需手动删除。

---

## Phase 2：Planning（生成计划）

### 强制行为

- 调研审阅完毕后，生成详细的实现计划并写入 `docs/sdlc/YYYY-MM-DD/{slug}/plan.md`（与 research.md 同目录）
- 计划必须基于实际代码，先读源文件再建议改动
- 含代码片段、文件路径、考量与权衡
- **禁止使用内置 Plan Mode**（聊天内计划不持久、不可编辑）

### plan.md 包含内容

```markdown
## 方案说明
[详细描述要做什么]

## 改动文件
- path/to/FileA.java：修改 xxx 方法，添加 yyy
- path/to/FileB.ts：新增 zzz 接口

## 代码片段
[关键改动的代码示例]

## 考量与权衡
[为什么选这个方案，有哪些 trade-off]

## 影响的测试
[需要修改或新增的测试]
```

---

## Phase 3：Annotation Cycle（注释循环）

### 流程

```
AI 写 docs/sdlc/YYYY-MM-DD/{slug}/plan.md
    ↓
用户在编辑器中审阅，添加内联注释
    ↓
用户发送"我加了注释"/"I added notes to the document"
    ↓
AI 只更新 docs/sdlc/YYYY-MM-DD/{slug}/plan.md，绝不实现代码
    ↓
继续循环，直到用户满意（通常 1-6 轮）
```

### 核心守卫（铁律）

收到"我加了注释"/"address the notes"/"更新计划"等指令时：
1. 只修改 `docs/sdlc/YYYY-MM-DD/{slug}/plan.md`
2. 回复末尾注明"（尚未实现，等待确认）"
3. **绝不提前写代码，无论计划看起来多完善**

Markdown 文件作为用户和 AI 之间的**共享可变状态**：用户以自己的节奏思考，精确标注出问题所在；AI 重新参与时不丢失上下文。三轮"我加了注释，更新计划"，就能把一个通用实现计划转化为完美契合现有系统的方案。

---

## Phase 4：Todo List（任务清单）

实现开始前，要求细粒度的任务分解并追加到 `docs/sdlc/YYYY-MM-DD/{slug}/plan.md`：

```markdown
## Todo List

### Phase 1: [阶段名]
- [ ] 任务 1
- [ ] 任务 2

### Phase 2: [阶段名]
- [ ] 任务 3
```

**作用：** 实现过程中的进度追踪器；AI 完成任务后标记完成；长会话中随时一眼看清进展。

---

## Phase 5：Implementation（实现）

### 开始信号识别

仅当用户发出明确实现指令时才开始：
- "implement it all" / "开始实现" / "按计划执行"

### 实现过程守则

1. 按 Todo List 顺序执行，完成一项即标记 `[x]`
2. 不得中途停下求确认，直到所有任务完成
3. 每批改动后运行编译检查（`tsc --noEmit` / `./gradlew compileJava` 等）
4. 全部完成后运行完整验证（格式化 → 编译 → 测试 → 构建）
5. 禁止不必要注释、any/unknown 类型、多余 javadoc/jsdoc

### 认知状态

到实现阶段，所有决策已做出并经过验证，实现变成了机械性的而非创造性的。**创造性工作发生在注释循环中，计划对了，执行就应该是无聊的。**

---

## Phase 6：Feedback & Iterate（反馈与迭代）

### 角色转变

实现开始后，用户从**架构师转为监督者**，指令变得极短：

```
"你没有实现 deduplicateByTitle 函数。"
"Settings 页面应该在 admin 模块，移过去。"
"wider"  "still cropped"  "2px gap"
```

### 遇到错误方向：回滚，不修补

```
"我撤销了所有改动。现在只做 X，其他什么都不要动。"
```

**不要在糟糕的基础上继续修补。回滚后缩小范围，几乎总能产出更好的结果。**

---

## plan.md 是唯一真相来源

| 对比维度 | 聊天对话 | plan.md |
|---------|---------|---------|
| 持久性 | 压缩后丢失 | 文件系统持久保存，按日期+任务 Git 归档 |
| 可编辑性 | 无法修改 | 可以在编辑器中直接标注 |
| 全局视图 | 需要滚动才能重建决策 | 完整规范，可整体审阅 |
| 上下文压缩后 | 细节丢失 | 完整保存，随时可引用 |

---

## 保持主导权

AI 会提出技术上正确但对项目来说是错的方案，因为它不了解产品优先级、用户痛点、可接受的工程权衡。用户始终掌控**方向**，AI 掌控**执行**。

控制手段：

```
# 逐项筛选
"第一个直接用 Promise.all，不要过度复杂；第三个抽成独立函数；第四五个忽略"

# 裁剪范围
"把下载功能从计划里去掉，现在不实现"

# 保护已有接口
"这三个函数的签名不能变，调用方适应，不是库适应"

# 提供参考实现
"这是他们的做法，写一个 plan.md 说明如何采用类似方案"
```

---

## 单次长会话策略

- 将调研、规划、实现放在**同一次长会话**中，不拆分到多次
- 到说"开始实现"时，AI 已花整个会话建立理解
- 上下文窗口满了时，自动压缩维持足够上下文
- **`docs/sdlc/YYYY-MM-DD/{slug}/plan.md` 这个持久工件在压缩后完整保存，随时可以指向它**

---

## 工具适配说明

| 工具 | Rules 安装路径 |
|------|--------------|
| Claude Code | `~/.claude/rules/sdlc-workflow.md` |
| Crush | `~/.config/crush/rules/sdlc-workflow.md` |
| Codex | `~/.codex/rules/sdlc-workflow.md` |
| OpenCode | `~/.config/opencode/rules/sdlc-workflow.md` |
