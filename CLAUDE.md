# 沟通风格

- 不使用表情符号
- 不使用破折号
- 不使用"不是...而是..."等递进或转折关联词
- 不道歉、不做免责说明、不奉承
- 回答基于事实，先验证再回复，不编造内容
- 偏好批判性、深入、结构化的回答

# MCP 工具路由

- 查官方文档用 `context7`
- 搜 GitHub 代码示例用 `gh_grep`
- 查最新/实时信息用 `perplexity`
- 搜本地笔记/文档用 `qmd`
- 标注信息来源

# 代码输出

- 输出完整可运行代码：imports、依赖、配置、目录结构
- 给出自包含的构建配置
- 禁止模糊建议、部分代码、不可执行的抽象建议

# 代码修改

- 修复问题时，搜索整个代码库中相同模式的所有位置，不得只改单个文件
- 重构后必须运行项目编译命令，修复所有错误后再呈现结果

# 调试与修复

- 禁止通过降低日志级别来消除警告，必须修复根因
- 禁止用 `@SuppressWarnings`、`try-catch` 吞掉错误
- 不确定根因时，先分析汇报，等用户确认再修

# Git 提交

遵循 [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)。

格式：`<type>(scope): <description>`

type: feat, fix, docs, style, refactor, perf, test, build, ci, chore

- scope 可选，用圆括号包裹
- 破坏性变更加 `!`，如 `feat(api)!: 移除旧接口`
- 提交时暂存所有相关文件，不得私自排除（除非用户指定）
- 不应提交的文件（`.env`、密钥）必须告知用户
- 禁止 `Co-Authored-By` 或 AI 署名

# Plan Mode

详见 `rules/sdlc-workflow.md`。

- 实现前必须有书面计划（`docs/sdlc/YYYY-MM-DD/{slug}/plan.md`）
- 未收到用户明确确认前不得开始写代码
- 收到"我加了注释"时只更新 plan.md，绝不实现
- plan.md 是唯一真相来源

# 基础设施操作

删除/销毁操作前，必须先输出依赖分析表：

| 资源 | 标识 | 依赖项 | 被依赖项 | 安全删除？ | 删除顺序 |
|------|------|--------|---------|----------|---------|

未获用户确认前，绝对不执行删除操作。kubectl 必须带 `--context` 参数。

# /done

会话结束时执行 `/done` 整理知识到 `~/docs/YYYY-MM-DD/[标题].md`。
