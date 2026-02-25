---
name: sdlc-workflow
description: 启动 SDLC 工作流：Research → Plan → Annotate → Implement → Feedback。强制规划与执行分离，在用户审阅批准计划前绝不写代码。
disable-model-invocation: true
argument-hint: [任务描述]
allowed-tools: Bash, Write, Read, Edit, Glob, Grep
---

# /sdlc-workflow — AI 辅助开发 SDLC 工作流

收到用户任务描述后，严格按以下阶段依次执行，不得跳步。核心原则：**在用户审阅并批准书面计划之前，绝不写代码。**

---

## 第一步：创建工作目录

根据任务描述生成一个 `{slug}`（小写字母加连字符），然后执行：

```bash
mkdir -p docs/sdlc/$(date +%Y-%m-%d)/{slug}
```

后续所有产出文件均存放于此目录。

---

## 第二步：Research（深度调研）

对任务进行**深入、详尽**的调研：

1. 使用 Glob、Grep、Read 工具全面搜索相关代码
2. 理解现有架构、依赖关系、数据流、边界条件
3. 将调研结果写入 `docs/sdlc/YYYY-MM-DD/{slug}/research.md`

**禁止只给口头摘要，必须写入文件。**

research.md 应包含：
- 相关文件列表及其职责
- 现有实现的关键逻辑分析
- 潜在影响范围
- 需要注意的约束和依赖

完成后告知用户：**"调研报告已写入 `docs/sdlc/YYYY-MM-DD/{slug}/research.md`，请审阅。"**

---

## 第三步：Planning（生成计划）

用户确认调研无误后，生成详细实现计划，写入 `docs/sdlc/YYYY-MM-DD/{slug}/plan.md`：

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

计划必须基于实际代码，先读源文件再建议改动。**禁止使用内置 Plan Mode。**

完成后告知用户：**"实现计划已写入 `docs/sdlc/YYYY-MM-DD/{slug}/plan.md`，请审阅并添加注释。"**

---

## 第四步：Annotation Cycle（注释循环）

进入计划审阅循环：

```
用户在编辑器中审阅 plan.md，添加内联注释
    ↓
用户发送"我加了注释"/"address the notes"
    ↓
AI 只更新 plan.md，绝不实现代码
    ↓
回复末尾注明"（尚未实现，等待确认）"
    ↓
继续循环，直到用户满意
```

**核心守卫（铁律）：** 收到"我加了注释"等指令时，只修改 plan.md，**绝不提前写代码**。

---

## 第五步：Todo List（任务清单）

用户对计划满意后，在 plan.md 末尾追加细粒度任务清单：

```markdown
## Todo List

### Phase 1: [阶段名]
- [ ] 任务 1
- [ ] 任务 2

### Phase 2: [阶段名]
- [ ] 任务 3
```

等待用户确认后进入实现阶段。

---

## 第六步：Implementation（实现）

仅当用户发出明确实现指令（如"开始实现"、"按计划执行"、"implement it all"）时才开始：

1. 按 Todo List 顺序执行，完成一项即标记 `[x]`
2. 不得中途停下求确认，直到所有任务完成
3. 每批改动后运行编译检查（`tsc --noEmit` / `./gradlew compileJava` 等）
4. 全部完成后运行完整验证（格式化 → 编译 → 测试 → 构建）
5. 禁止不必要注释、any/unknown 类型、多余 javadoc/jsdoc

---

## 第七步：Feedback & Iterate（反馈与迭代）

实现完成后进入反馈阶段。用户指令会变得极短（如"移过去"、"wider"），直接执行即可。

**遇到错误方向时：回滚，不修补。** 不要在糟糕的基础上继续堆砌。

---

## 关键提醒

- **plan.md 是唯一真相来源**，比聊天记录更可靠（压缩后仍完整保存）
- 用户始终掌控**方向**，AI 掌控**执行**
- 将调研、规划、实现放在**同一次长会话**中，不拆分到多次
- 创造性工作发生在注释循环中，计划对了，执行就应该是无聊的
