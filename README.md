# ai-agents

Claude Code 全局配置集合：Memory、Rules、Skills、MCP。

仓库目录结构与 `~/.claude/` 一一对应，安装即复制。

## 目录结构

```
ai-agents/
├── CLAUDE.md              → ~/.claude/CLAUDE.md              全局内存文件
├── settings.json          → ~/.claude/settings.json          MCP 服务配置模板
├── rules/
│   └── sdlc-workflow.md   → ~/.claude/rules/                 SDLC 工作流规范
├── skills/
│   ├── done/SKILL.md      → ~/.claude/skills/done/           会话知识整理
│   └── sdlc-workflow/SKILL.md → ~/.claude/skills/sdlc-workflow/  开发工作流
├── .env.example                                              环境变量模板
└── .gitignore
```

## 安装

```bash
git clone https://github.com/StringKe/ai-agents.git
cd ai-agents

# 环境变量
cp .env.example .env
# 编辑 .env，填入 CONTEXT7_API_KEY 和 PERPLEXITY_API_KEY

# 内存文件
cp CLAUDE.md ~/.claude/CLAUDE.md

# 规则
mkdir -p ~/.claude/rules
cp rules/sdlc-workflow.md ~/.claude/rules/

# 技能
mkdir -p ~/.claude/skills/done ~/.claude/skills/sdlc-workflow
cp skills/done/SKILL.md ~/.claude/skills/done/
cp skills/sdlc-workflow/SKILL.md ~/.claude/skills/sdlc-workflow/

# MCP（将 settings.json 中的 mcpServers 合并到 ~/.claude/settings.json）
```

## 配置说明

### CLAUDE.md

全局内存文件，每次会话启动时加载。包含沟通风格、MCP 工具路由、代码输出规范、代码修改规范、调试规范、Git 提交规范（Conventional Commits 1.0.0）、Plan Mode 约束、基础设施操作安全规则。

### rules/sdlc-workflow.md

始终生效的工作流规范，六阶段：Research → Plan → Annotate → Todo List → Implement → Feedback。核心原则：`plan.md` 是唯一真相来源，审阅批准前绝不写代码。

### skills/done

手动触发 `/done`，整理会话知识到 `~/docs/YYYY-MM-DD/[标题].md`。

### skills/sdlc-workflow

手动触发 `/sdlc-workflow [任务描述]`，按需启动 SDLC 工作流。与 rules 版本内容相同，适合不需要每次会话都强制执行的场景。

### settings.json

MCP 服务配置模板：

| 服务 | 用途 | 类型 | API Key |
|------|------|------|---------|
| [context7](https://context7.com) | 框架/库官方文档查询 | HTTP | 需要 |
| [gh_grep](https://grep.app) | GitHub 代码搜索 | HTTP | 不需要 |
| [perplexity](https://www.perplexity.ai) | 实时联网搜索 | 本地 stdio | 需要 |
| [qmd](https://github.com/tmc/misc/tree/master/cmd/qmd) | 本地 Markdown 知识库 | 本地 stdio | 不需要 |

## 其他 AI 工具适配

本仓库以 Claude Code 为核心。其他工具可通过读取本仓库生成等效配置。

大部分 AI 工具支持读取 GitHub 仓库，直接输入以下提示词：

```
阅读 https://github.com/StringKe/ai-agents 仓库的所有文件。
将 CLAUDE.md 的内容适配为本工具的全局提示词格式。
将 rules/ 目录的内容适配为本工具支持的规则格式。
将 skills/ 目录的内容适配为本工具支持的自定义命令格式。
将 settings.json 中的 MCP 配置适配为本工具的 MCP 配置格式。
输出完整的配置文件和安装步骤。
```

各工具配置目录参考：

| 工具 | 全局提示词 | 规则目录 | 技能目录 |
|------|-----------|---------|---------|
| Crush | `~/.config/crush/CRUSH.md` | `~/.config/crush/rules/` | `~/.config/crush/skills/` |
| Codex | `~/.codex/AGENTS.md` | `~/.codex/rules/` | `~/.agents/skills/` |
| OpenCode | `~/.config/opencode/AGENTS.md` | `~/.config/opencode/rules/` | `~/.agents/skills/` |

## License

MIT
