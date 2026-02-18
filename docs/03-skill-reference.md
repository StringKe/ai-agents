# 技能速查手册

## SDLC 核心技能

### /brainstorming

协作式需求探索与设计。苏格拉底式对话，产出 spec.md。

- 触发："探索需求"、"讨论设计"、"头脑风暴"、"brainstorm"
- 产出：`docs/sdlc/YYYY-MM-DD/{slug}/spec.md`
- 参考文件：`references/spec-reviewer-prompt.md`

### /writing-plans

将设计规格转化为细粒度实现计划。支持注释循环。

- 触发："编写计划"、"写计划"、"制定方案"
- 产出：`docs/sdlc/YYYY-MM-DD/{slug}/plan.md`
- 参考文件：`references/plan-reviewer-prompt.md`
- 铁律：收到"我加了注释"时只改 plan.md，绝不写代码

### /executing-plans

按 plan.md 逐任务执行。Todo checkbox 追踪进度。

- 触发："执行计划"、"按计划实现"、"开始实现"
- 适合：小型改动，任务间强依赖

### /subagent-driven-development

为每个任务派遣独立子代理，两阶段审查。

- 触发："子代理开发"、"并行实现"、"subagent"
- 适合：大型改动，任务间相对独立
- 参考文件：`references/implementer-prompt.md`, `references/spec-reviewer-prompt.md`, `references/code-quality-reviewer-prompt.md`

## 工程实践技能

### /test-driven-development

严格红绿重构循环。

- 触发："TDD"、"测试驱动"、"写测试"
- 铁律：没有失败测试就没有生产代码
- 参考文件：`references/testing-anti-patterns.md`

### /systematic-debugging

四阶段根因分析：调查、模式分析、假设测试、修复。

- 触发："调试"、"debug"、"排查"、"根因"
- 铁律：没有根因就没有修复
- 参考文件：`references/root-cause-tracing.md`, `references/defense-in-depth.md`, `references/condition-based-waiting.md`

### /verification-before-completion

完成前必须提供验证证据。

- 触发："验证"、"确认完成"、"verify"
- 铁律：没有验证证据就不宣称完成

## 协作技能

### /requesting-code-review

派遣 code-reviewer 子代理审查代码变更。

- 触发："代码审查"、"review"、"审查代码"
- 参考文件：`references/code-reviewer-prompt.md`

### /receiving-code-review

处理收到的审查反馈。技术正确性优先。

- 触发："收到审查反馈"、"处理 review"

### /using-git-worktrees

创建 Git Worktree 隔离工作空间。

- 触发："worktree"、"隔离工作空间"、"隔离分支"

### /finishing-a-development-branch

四选项决策树：合并 / PR / 保留 / 丢弃。

- 触发："完成分支"、"合并"、"提交 PR"

### /dispatching-parallel-agents

为独立问题域分配并行子代理。

- 触发："并行"、"parallel"、"同时处理"

## 工具技能（仅手动触发）

### /writing-skills

编写和优化 SKILL.md。TDD 方法论。

- 参考文件：`references/anthropic-best-practices.md`, `references/testing-skills-with-subagents.md`

### /done

会话结束时整理知识到 `~/docs/YYYY-MM-DD/[标题].md`。

### /daily

基于 /done 记录生成今日工作日报。

### /weekly

基于日报和 /done 记录生成本周工作周报。
