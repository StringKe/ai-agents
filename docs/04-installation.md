# 安装与配置

## 插件系统限制

Claude Code 插件支持 skills、agents、hooks、MCP servers、LSP servers。**不支持 rules**。

本插件的 `rules/sdlc-workflow.md` 是 SDLC 工作流的感知层，需要每次会话自动加载。由于插件无法分发 rules，安装插件后必须手动复制 rule 文件到 `~/.claude/rules/`。

## 插件 Scope 说明

| scope | 配置文件 | 效果 |
|-------|---------|------|
| `user` | `~/.claude/settings.json` | 全局，所有项目生效 |
| `project` | `.claude/settings.json` | 项目级，通过 git 共享 |
| `local` | `.claude/settings.local.json` | 项目级，gitignore |

推荐使用 `user` scope 安装，所有项目统一生效。

## 前置条件：环境变量

插件通过 `.mcp.json` 自动配置 MCP 服务，API Key 从环境变量读取。安装插件前，在 shell 配置中 export 以下变量：

```bash
# 添加到 ~/.zsh_secrets 或 ~/.bashrc
export CONTEXT7_API_KEY=your_key_here      # 申请: https://context7.com
export PERPLEXITY_API_KEY=your_key_here    # 申请: https://www.perplexity.ai/settings/api
```

参考 `.env.example` 查看完整变量列表。gh_grep 和 qmd 无需 API Key。

## 方式一：Claude Code Plugin（推荐）

```bash
# 1. 添加 marketplace 并安装插件（默认 user scope，全局生效）
claude plugin marketplace add StringKe/ai-agents
claude plugin install ai-agents@ai-agents-marketplace

# 2. 手动复制 Rule（插件不支持 rules）
git clone https://github.com/StringKe/ai-agents.git /tmp/ai-agents
mkdir -p ~/.claude/rules
cp /tmp/ai-agents/rules/sdlc-workflow.md ~/.claude/rules/
rm -rf /tmp/ai-agents
```

安装后技能以 `ai-agents:` 为命名空间前缀，例如 `/ai-agents:brainstorming`。

MCP 服务由插件的 `.mcp.json` 自动加载，无需手动执行 `claude mcp add`。

## 方式二：本地开发测试

```bash
git clone https://github.com/StringKe/ai-agents.git
claude --plugin-dir ./ai-agents
```

`--plugin-dir` 模式下修改文件后执行 `/reload-plugins` 即可生效，无需重启。Rule 仍需手动复制。

## 方式三：Claudex Sets

```bash
# 全局安装（写入 ~/.claude/，自动处理 rules）
claudex sets add --global https://github.com/StringKe/ai-agents.git
```

安装 claudex：`curl -fsSL https://raw.githubusercontent.com/StringKe/claudex/main/install.sh | bash`

## 方式四：手动安装

```bash
git clone https://github.com/StringKe/ai-agents.git
cd ai-agents

# CLAUDE.md
cp CLAUDE.md ~/.claude/CLAUDE.md

# Rules（插件无法分发，必须手动）
mkdir -p ~/.claude/rules
cp rules/sdlc-workflow.md ~/.claude/rules/

# Skills（16 个）
for skill in skills/*/; do
  name=$(basename "$skill")
  mkdir -p ~/.claude/skills/"$name"
  cp -r "$skill"* ~/.claude/skills/"$name"/
done

# Agent
mkdir -p ~/.claude/agents
cp agents/code-reviewer.md ~/.claude/agents/
```

手动安装时 MCP 需要单独配置：

```bash
claude mcp add -t http -H "CONTEXT7_API_KEY: $CONTEXT7_API_KEY" -s user context7 https://mcp.context7.com/mcp
claude mcp add -t http -s user gh_grep https://mcp.grep.app
claude mcp add -e PERPLEXITY_API_KEY=$PERPLEXITY_API_KEY -s user perplexity -- npx -y @perplexity-ai/mcp-server
claude mcp add -s user qmd -- qmd mcp
```

## 定制

### 添加自定义技能

1. 在 `skills/` 下创建新目录
2. 编写 SKILL.md（参考 `/writing-skills` 技能的指导）
3. 在 `.claudex-sets.json` 的 skills 数组中添加条目

### 修改现有技能

直接编辑对应的 SKILL.md。修改后重新安装或复制文件即可生效。

### 技能选择性安装

不需要全部 16 个技能时，只复制需要的 `skills/{name}/` 目录即可。

## MCP 工具路由

在 CLAUDE.md 中配置工具路由，确保 AI 使用正确的 MCP 工具：

| 场景 | 工具 |
|------|------|
| 查官方框架/库文档 | context7 |
| 搜 GitHub 代码示例 | gh_grep |
| 查最新/实时信息 | perplexity |
| 搜本地笔记/文档 | qmd |
