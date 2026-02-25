# ai-agents

个人 AI 编程工具的全局配置、Prompt、Rules 与 Skill 集合。支持 Claude Code、Crush、Codex、OpenCode 四款工具，配置统一、开箱即用。

## 工具支持矩阵

| 工具 | 配置文件路径 | 全局 Prompt 路径 | Rules 路径 | Skill 路径 |
|------|------------|----------------|-----------|-----------|
| [Claude Code](https://claude.ai/code) | `~/.claude/settings.json` | `~/.claude/CLAUDE.md` | `~/.claude/rules/` | `~/.claude/skills/` |
| [Crush](https://github.com/charmbracelet/crush) | `~/.local/share/crush/crush.json` | `~/.config/crush/CRUSH.md` | `~/.config/crush/rules/` | `~/.config/crush/skills/` |
| [Codex](https://developers.openai.com/codex) | `~/.codex/config.toml` | `~/.codex/AGENTS.md` | `~/.codex/rules/` | `~/.agents/skills/` |
| [OpenCode](https://opencode.ai) | `~/.config/opencode/opencode.json` | `~/.config/opencode/AGENTS.md` | `~/.config/opencode/rules/` | `~/.agents/skills/` |

---

## MCP 工具配置

所有工具统一接入以下 MCP 服务：

| MCP | 用途 | 类型 |
|-----|------|------|
| [context7](https://context7.com) | 官方文档搜索 | 远程 HTTP |
| [gh_grep](https://grep.app) | GitHub 代码搜索 | 远程 HTTP |
| [perplexity](https://www.perplexity.ai) | 实时联网查询 | 本地 stdio |
| [qmd](https://github.com/tmc/misc/tree/master/cmd/qmd) | 本地 Markdown 知识库 | 本地 stdio |

### 配置模板

各工具 MCP 配置模板位于 [`mcp/`](./mcp/) 目录，使用环境变量占位符，**不包含真实密钥**：

```
mcp/
├── claude-code.json   → 复制到 ~/.claude/settings.json（合并 mcpServers 字段）
├── crush.json         → 合并到 ~/.local/share/crush/crush.json（mcp 字段）
├── codex.toml         → 合并到 ~/.codex/config.toml（mcp_servers 字段）
└── opencode.json      → 复制到 ~/.config/opencode/opencode.json（合并 mcp 字段）
```

配置前请先复制 `.env.example` 为 `.env` 并填写密钥：

```bash
cp .env.example .env
# 编辑 .env 填入真实 API Key
```

---

## Rules

Rules 是**始终生效**的行为规范，加载后 AI 在整个会话中自动遵循，无需手动触发。适合放置工作流规范、编码规范等需要持续约束 AI 行为的指令。

```
rules/
└── sdlc-workflow.md    # SDLC 开发工作流规范
```

### `sdlc-workflow` — SDLC 开发工作流

**加载方式**：复制到工具对应的 Rules 目录，AI 启动时自动加载

**功能：**

强制 AI 辅助开发遵循 **Research → Plan → Annotate → Todo List → Implement → Feedback** 六阶段工作流。核心原则：在用户审阅并批准书面计划之前，绝不写代码。

**关键约束：**
1. 接到任务先调研，产出 `research.md`，禁止口头摘要
2. 调研审阅后生成 `plan.md`，计划必须基于实际代码
3. 用户通过内联注释迭代计划（通常 1-6 轮），AI 只改计划不写代码
4. 用户明确指令后才开始实现，按 Todo List 顺序执行
5. `plan.md` 是唯一真相来源，上下文压缩后仍完整保存

#### 安装方式

```bash
# Claude Code
mkdir -p ~/.claude/rules
cp rules/sdlc-workflow.md ~/.claude/rules/sdlc-workflow.md

# Crush
mkdir -p ~/.config/crush/rules
cp rules/sdlc-workflow.md ~/.config/crush/rules/sdlc-workflow.md

# Codex
mkdir -p ~/.codex/rules
cp rules/sdlc-workflow.md ~/.codex/rules/sdlc-workflow.md

# OpenCode
mkdir -p ~/.config/opencode/rules
cp rules/sdlc-workflow.md ~/.config/opencode/rules/sdlc-workflow.md
```

> **Rules vs Skills：** Rules 始终生效，适合工作流规范；Skills 按需调用（`/sdlc-workflow`），适合不希望每次会话都强制执行的场景。两者内容相同，选择适合你的方式安装。

---

## Skills

Skills 遵循 [Agent Skills 开放标准](https://agentskills.io)，与 Claude Code、Crush、Codex、OpenCode 均兼容。

```
skills/
├── done/
│   └── SKILL.md              # 会话知识整理 Skill
└── sdlc-workflow/
    └── SKILL.md              # SDLC 开发工作流 Skill
```

### `/done` — 会话知识整理

**触发方式**：在任意工具中手动执行 `/done`（设有 `disable-model-invocation: true`，不自动触发）

**功能：**
1. 自动采集环境元数据（日期、工作目录、Git 仓库/分支/提交）
2. AI 根据会话内容生成文件标题（5–15 汉字）和语义标签
3. 提取关键讨论、决策记录、问题解决过程、后续行动项
4. 输出中文 Markdown 文档至 `~/docs/YYYY-MM-DD/[标题].md`

**输出文件格式：**

```markdown
---
会话ID: [工具]-[日期]-[时间]
日期: 2026-02-18
工具: Claude Code
工作目录: /Users/xxx/project
Git仓库: git@github.com:xxx/repo.git
Git分支: main
标签: [MCP, 配置, 工具集成]
---

# MCP配置整合

## 会话概要
...

## 决策记录
| 决策问题 | 选择方案 | 决策原因 |
...
```

#### 安装方式

```bash
# Claude Code
mkdir -p ~/.claude/skills/done
cp skills/done/SKILL.md ~/.claude/skills/done/SKILL.md

# Crush
mkdir -p ~/.config/crush/skills/done
cp skills/done/SKILL.md ~/.config/crush/skills/done/SKILL.md

# Codex + OpenCode（共享路径）
mkdir -p ~/.agents/skills/done
cp skills/done/SKILL.md ~/.agents/skills/done/SKILL.md
```

### `/sdlc-workflow` — SDLC 开发工作流

**触发方式**：手动执行 `/sdlc-workflow [任务描述]`（设有 `disable-model-invocation: true`，不自动触发）

**功能：**

与 Rules 版本内容相同，但以 Skill 形式按需调用。适合不想让工作流规范始终生效，而是在特定任务中手动启动的场景。

执行后 AI 将严格遵循六阶段流程：
1. 创建 `docs/sdlc/YYYY-MM-DD/{slug}/` 工作目录
2. 深度调研 → 产出 `research.md`
3. 生成实现计划 → 产出 `plan.md`
4. 注释循环迭代计划（只改计划，不写代码）
5. 用户确认后按 Todo List 顺序实现
6. 反馈与迭代

#### 安装方式

```bash
# Claude Code
mkdir -p ~/.claude/skills/sdlc-workflow
cp skills/sdlc-workflow/SKILL.md ~/.claude/skills/sdlc-workflow/SKILL.md

# Crush
mkdir -p ~/.config/crush/skills/sdlc-workflow
cp skills/sdlc-workflow/SKILL.md ~/.config/crush/skills/sdlc-workflow/SKILL.md

# Codex + OpenCode（共享路径）
mkdir -p ~/.agents/skills/sdlc-workflow
cp skills/sdlc-workflow/SKILL.md ~/.agents/skills/sdlc-workflow/SKILL.md
```

---

## 全局 Prompt

[`prompts/global.md`](./prompts/global.md) 为四款工具共享的全局系统提示词，定义了：

- MCP 工具使用原则
- 代码生成规范（生产级实践）
- 输出格式要求
- Git 提交规范
- `/done` 技能说明

**安装方式：**

```bash
cp prompts/global.md ~/.claude/CLAUDE.md
cp prompts/global.md ~/.config/crush/CRUSH.md
cp prompts/global.md ~/.codex/AGENTS.md
cp prompts/global.md ~/.config/opencode/AGENTS.md
```

---

## 快速开始

```bash
# 1. 克隆仓库
git clone https://github.com/StringKe/ai-agents.git
cd ai-agents

# 2. 配置环境变量
cp .env.example .env
# 编辑 .env，填入 CONTEXT7_API_KEY 和 PERPLEXITY_API_KEY

# 3. 安装全局 Prompt（选择你使用的工具）
cp prompts/global.md ~/.claude/CLAUDE.md          # Claude Code
cp prompts/global.md ~/.config/crush/CRUSH.md     # Crush
cp prompts/global.md ~/.codex/AGENTS.md           # Codex
cp prompts/global.md ~/.config/opencode/AGENTS.md # OpenCode

# 4. 安装 Rules（始终生效，可选）
mkdir -p ~/.claude/rules
cp rules/sdlc-workflow.md ~/.claude/rules/sdlc-workflow.md

# 5. 安装 Skills
mkdir -p ~/.claude/skills/done ~/.claude/skills/sdlc-workflow
cp skills/done/SKILL.md ~/.claude/skills/done/SKILL.md
cp skills/sdlc-workflow/SKILL.md ~/.claude/skills/sdlc-workflow/SKILL.md

# 6. 配置 MCP（参考 mcp/ 目录，合并对应配置文件）
```

---

## 目录结构

```
ai-agents/
├── README.md
├── .env.example              # 环境变量模板
├── prompts/
│   └── global.md             # 全局系统提示词（四工具共享）
├── rules/
│   └── sdlc-workflow.md      # SDLC 工作流规范（始终生效）
├── skills/
│   ├── done/
│   │   └── SKILL.md          # /done 会话整理 Skill
│   └── sdlc-workflow/
│       └── SKILL.md          # /sdlc-workflow 开发工作流 Skill
└── mcp/
    ├── claude-code.json      # Claude Code MCP 配置模板
    ├── crush.json            # Crush MCP 配置模板
    ├── codex.toml            # Codex MCP 配置模板（TOML 格式）
    └── opencode.json         # OpenCode MCP 配置模板
```

---

## License

MIT
