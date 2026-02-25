# ai-agents

Claude Code 全局配置集合：CLAUDE.md、Rules、Skills、MCP。

## 目录结构

```
ai-agents/
├── CLAUDE.md                      → ~/.claude/CLAUDE.md              全局指令
├── rules/
│   └── sdlc-workflow.md           → ~/.claude/rules/                 SDLC 工作流规范
├── skills/
│   ├── done/SKILL.md              → ~/.claude/skills/done/           会话知识整理
│   └── sdlc-workflow/SKILL.md     → ~/.claude/skills/sdlc-workflow/  开发工作流
├── setup-mcp.sh                                                      MCP 一键配置脚本
└── .env.example                                                      环境变量模板
```

## 安装

### 1. 复制配置文件

```bash
git clone https://github.com/StringKe/ai-agents.git
cd ai-agents

# CLAUDE.md
cp CLAUDE.md ~/.claude/CLAUDE.md

# Rules
mkdir -p ~/.claude/rules
cp rules/sdlc-workflow.md ~/.claude/rules/

# Skills
mkdir -p ~/.claude/skills/done ~/.claude/skills/sdlc-workflow
cp skills/done/SKILL.md ~/.claude/skills/done/
cp skills/sdlc-workflow/SKILL.md ~/.claude/skills/sdlc-workflow/
```

### 2. 配置 MCP

Claude Code 的 MCP 通过 `claude mcp add` 命令管理，配置存储在 `~/.claude.json` 中。

不要手动编辑 `~/.claude/settings.json` 的 `mcpServers` 字段，那里的配置不会被 `claude mcp` 命令识别，行为不可靠。

#### 方式一：脚本安装

```bash
cp .env.example .env
# 编辑 .env，填入 API Key
chmod +x setup-mcp.sh
./setup-mcp.sh
```

#### 方式二：手动执行

```bash
# context7（需要 API Key，申请：https://context7.com）
claude mcp add -t http -H "CONTEXT7_API_KEY: 你的Key" -s user context7 https://mcp.context7.com/mcp

# gh_grep（无需 API Key）
claude mcp add -t http -s user gh_grep https://mcp.grep.app

# perplexity（需要 API Key，申请：https://www.perplexity.ai/settings/api）
claude mcp add -e PERPLEXITY_API_KEY=你的Key -s user perplexity -- npx -y @perplexity-ai/mcp-server

# qmd（需要先安装：npm i -g @tobilu/qmd）
claude mcp add -s user qmd -- qmd mcp
```

#### 验证

```bash
claude mcp list
```

所有 MCP 应显示 `Connected` 状态。

#### 管理命令

```bash
claude mcp list                    # 查看所有 MCP
claude mcp get <name>              # 查看单个 MCP 详情
claude mcp remove <name> -s user   # 删除 MCP
```

## 配置说明

### CLAUDE.md

全局指令文件，每次会话启动时加载。包含沟通风格、MCP 工具路由、代码输出规范、代码修改规范、调试规范、Git 提交规范（Conventional Commits 1.0.0）、Plan Mode 约束、基础设施操作安全规则。

### rules/sdlc-workflow.md

始终生效的工作流规范，六阶段：Research, Plan, Annotate, Todo List, Implement, Feedback。核心原则：`plan.md` 是唯一真相来源，审阅批准前绝不写代码。

### skills/done

手动触发 `/done`，整理会话知识到 `~/docs/YYYY-MM-DD/[标题].md`。

### skills/sdlc-workflow

手动触发 `/sdlc-workflow [任务描述]`，按需启动 SDLC 工作流。与 rules 版本内容相同，适合不需要每次会话都强制执行的场景。

### MCP 服务

| 服务 | 用途 | 类型 | API Key |
|------|------|------|---------|
| [context7](https://context7.com) | 框架/库官方文档查询 | HTTP | 需要 |
| [gh_grep](https://grep.app) | GitHub 代码搜索 | HTTP | 不需要 |
| [perplexity](https://www.perplexity.ai) | 实时联网搜索 | stdio | 需要 |
| [qmd](https://github.com/tmc/misc/tree/master/cmd/qmd) | 本地 Markdown 知识库 | stdio | 不需要 |

## 适配其他工具

在任意 AI 编码工具中输入以下提示词，可根据本仓库生成等效配置：

```
阅读 https://github.com/StringKe/ai-agents 仓库的所有文件。
将 CLAUDE.md 的内容适配为本工具的全局提示词格式。
将 rules/ 目录的内容适配为本工具支持的规则格式。
将 skills/ 目录的内容适配为本工具支持的自定义命令格式。
根据 README 中的 MCP 服务列表，适配为本工具的 MCP 配置格式。
输出完整的配置文件和安装步骤。
```

各工具配置目录参考：

| 工具 | 全局提示词 | 规则目录 | 技能目录 |
|------|-----------|---------|---------|
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/rules/` | `~/.claude/skills/` |
| Crush | `~/.config/crush/CRUSH.md` | `~/.config/crush/rules/` | `~/.config/crush/skills/` |
| Codex | `~/.codex/AGENTS.md` | `~/.codex/rules/` | `~/.agents/skills/` |
| OpenCode | `~/.config/opencode/AGENTS.md` | `~/.config/opencode/rules/` | `~/.agents/skills/` |

## License

MIT
