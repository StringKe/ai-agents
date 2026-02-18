# 安装与配置

## 方式一：Claude Code Plugin（推荐）

```bash
claude plugin add https://github.com/StringKe/ai-agents.git
```

## 方式二：Claudex Sets

```bash
# 全局安装（写入 ~/.claude/）
claudex sets add --global https://github.com/StringKe/ai-agents.git

# 项目级安装（写入当前项目 .claude/）
claudex sets add https://github.com/StringKe/ai-agents.git
```

安装 claudex：`curl -fsSL https://raw.githubusercontent.com/StringKe/claudex/main/install.sh | bash`

## 方式三：手动安装

```bash
git clone https://github.com/StringKe/ai-agents.git
cd ai-agents

# CLAUDE.md
cp CLAUDE.md ~/.claude/CLAUDE.md

# Rules
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

## MCP 服务配置

Claude Code 的 MCP 通过 `claude mcp add` 命令管理。

```bash
# context7（需要 API Key，申请：https://context7.com）
claude mcp add -t http -H "CONTEXT7_API_KEY: 你的Key" -s user context7 https://mcp.context7.com/mcp

# gh_grep（无需 API Key）
claude mcp add -t http -s user gh_grep https://mcp.grep.app

# perplexity（需要 API Key，申请：https://www.perplexity.ai/settings/api）
claude mcp add -e PERPLEXITY_API_KEY=你的Key -s user perplexity -- npx -y @perplexity-ai/mcp-server

# qmd（需要先安装：cargo install qmd）
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
