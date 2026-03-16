# ai-agents

Claude Code 插件，用 SDLC（Software Development Life Cycle，软件开发生命周期）工作流重新组织 AI 辅助开发。16 个技能覆盖从需求探索到分支收尾的完整流程。

## 为什么需要这个插件

AI 辅助开发的最大价值不在于"写代码更快"。在于把决策从编码阶段提前到计划阶段。

传统流程中，开发者在写代码的同时做架构选择、API 设计、错误处理策略等决策。这些决策分散在代码提交中，没有集中记录，导致后续维护和 Code Review 时信息丢失。

SDLC 工作流把这个过程拆开：先用 AI 做深度调研和方案设计（spec.md），再把方案转化为可执行的细粒度计划（plan.md），最后让 AI 按计划逐步实现。决策发生在计划阶段，实现阶段只是机械执行。

核心收益：犯错更少、决策更早、反馈更快。

## 为什么选 Claude Code

Claude Code 的四级上下文分层（全局 → 项目 → 规则 → 模块）是本插件的基础设施。其他 AI 编码工具把所有规则塞在一个文件里，随着规则增长变得难以维护且消耗大量无关 token。

本插件依赖的 Claude Code 能力：

| 能力 | 用途 |
|------|------|
| Rules | 感知层：SDLC 工作流导航，每次会话自动加载 |
| Skills | 执行层：16 个技能按需加载，包含详细指令 |
| Agent 子代理 | 任务隔离执行、两阶段代码审查、并行调度 |
| Memory | 跨会话持久记忆，积累个性化上下文 |
| MCP | 外部工具集成（文档查询、代码搜索、联网搜索） |

## 安装

### Claude Code Plugin（推荐）

```bash
# 1. 添加 marketplace
claude plugin marketplace add StringKe/ai-agents

# 2. 安装插件
claude plugin install ai-agents@ai-agents-marketplace
```

### 本地开发测试

```bash
git clone https://github.com/StringKe/ai-agents.git
claude --plugin-dir ./ai-agents
```

### Claudex Sets

```bash
# 全局安装（写入 ~/.claude/）
claudex sets add --global https://github.com/StringKe/ai-agents.git

# 项目级安装（写入当前项目 .claude/）
claudex sets add https://github.com/StringKe/ai-agents.git
```

### 手动安装

见 [docs/04-installation.md](docs/04-installation.md)。

## SDLC 工作流

```
需求探索 → 计划编写 → 执行实现 → 质量保障 → 收尾
spec.md    plan.md    代码变更    验证证据    合并/PR
```

所有产出文件存放在 `docs/sdlc/YYYY-MM-DD/{slug}/` 目录下。plan.md 是整个流程的唯一真相来源，比聊天记录更可靠（上下文压缩后仍完整保存）。

详见 [docs/02-workflow.md](docs/02-workflow.md)。

## 技能速查

### SDLC 核心

| 技能 | 触发短语 | 用途 |
|------|---------|------|
| /brainstorming | 探索需求、讨论设计 | 苏格拉底式对话，产出 spec.md |
| /writing-plans | 编写计划、写计划 | 细粒度实现计划，支持注释循环 |
| /executing-plans | 执行计划、开始实现 | 逐任务执行，Todo checkbox 追踪 |
| /subagent-driven-development | 子代理开发、并行实现 | 每任务独立子代理 + 两阶段审查 |

### 工程实践

| 技能 | 触发短语 | 铁律 |
|------|---------|------|
| /test-driven-development | TDD、测试驱动 | 没有失败测试就没有生产代码 |
| /systematic-debugging | 调试、debug、排查 | 没有根因就没有修复 |
| /verification-before-completion | 验证、确认完成 | 没有验证证据就不宣称完成 |

### 协作

| 技能 | 触发短语 | 用途 |
|------|---------|------|
| /requesting-code-review | 代码审查、review | 派遣 code-reviewer 子代理 |
| /receiving-code-review | 收到审查反馈 | 技术正确性优先处理反馈 |
| /using-git-worktrees | worktree、隔离分支 | 隔离工作空间 |
| /finishing-a-development-branch | 完成分支、合并 | 合并/PR/保留/丢弃 |
| /dispatching-parallel-agents | 并行、parallel | 多代理并行调度 |

### 工具（仅手动触发）

| 技能 | 用途 |
|------|------|
| /writing-skills | 编写 SKILL.md |
| /done | 会话知识整理 |
| /daily | 生成日报 |
| /weekly | 生成周报 |

## MCP 服务

| 服务 | 用途 | 类型 | API Key |
|------|------|------|---------|
| [context7](https://context7.com) | 框架/库官方文档查询 | HTTP | 需要 |
| [gh_grep](https://grep.app) | GitHub 代码搜索 | HTTP | 不需要 |
| [perplexity](https://www.perplexity.ai) | 实时联网搜索 | stdio | 需要 |
| [qmd](https://github.com/stevearc/qmd) | 本地 Markdown 知识库 | stdio | 不需要 |

## 文档

| 文档 | 内容 |
|------|------|
| [00-overview](docs/00-overview.md) | 为什么用 SDLC、为什么选 Claude Code、设计理念 |
| [01-architecture](docs/01-architecture.md) | Rule + Skill 架构、上下文工程 |
| [02-workflow](docs/02-workflow.md) | SDLC 工作流详解、AI 驱动的 TDD |
| [03-skill-reference](docs/03-skill-reference.md) | 16 个技能速查手册 |
| [04-installation](docs/04-installation.md) | 安装、配置、定制 |

## License

MIT
