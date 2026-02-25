# SDLC 工作流

核心工作流：**Research → Plan → Annotate → Todo List → Implement → Feedback**。

**在用户审阅并批准书面计划之前，绝不写代码。**

## 文件路径

```
docs/sdlc/YYYY-MM-DD/{slug}/
├── research.md
└── plan.md
```

`{slug}` 为任务短名，小写字母加连字符。

## Phase 1：Research

- 接到任务时，先调研，后计划，后实现，绝不跳步
- 调研结果写入 `research.md`，禁止只给口头摘要
- 内容：相关文件列表、现有实现分析、影响范围、约束和依赖

## Phase 2：Plan

- 用户确认调研后，生成计划写入 `plan.md`
- 计划必须基于实际代码，先读源文件再建议改动
- 包含：方案说明、改动文件、代码片段、考量与权衡、影响的测试
- 禁止使用内置 Plan Mode（聊天内计划不持久、不可编辑）

## Phase 3：Annotate

用户在编辑器中审阅 plan.md，添加注释后发送"我加了注释"。

收到此类指令时：
1. 只修改 plan.md
2. 回复末尾注明"（尚未实现，等待确认）"
3. **绝不提前写代码**

循环直到用户满意。

## Phase 4：Todo List

用户对计划满意后，在 plan.md 末尾追加细粒度任务清单：

```markdown
## Todo List

### Phase 1: [阶段名]
- [ ] 任务 1
- [ ] 任务 2
```

## Phase 5：Implement

仅当用户发出"开始实现"/"按计划执行"/"implement it all"时才开始。

1. 按 Todo List 顺序执行，完成即标记 `[x]`
2. 不得中途停下求确认，直到所有任务完成
3. 每批改动后运行编译检查
4. 全部完成后运行完整验证

## Phase 6：Feedback

用户指令变得极短（如"移过去"、"wider"），直接执行。

遇到错误方向：回滚，不修补。
