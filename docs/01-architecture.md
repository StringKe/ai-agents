# Rule + Skill 架构

## 上下文分层基础

Claude Code 的四级上下文分层是本插件的基础设施：

```
L1 全局    ~/.claude/CLAUDE.md          → 所有项目生效
           沟通风格、MCP 工具路由、代码质量底线

L2 项目    项目根目录/CLAUDE.md         → 单个项目生效
           技术栈、提交规范、SDLC 流程引用

L3 规则    .claude/rules/*.md           → 按领域拆分加载
           SDLC 工作流感知与导航

L4 模块    src/.../模块/CLAUDE.md       → 单个模块生效
           模块职责、API 约定、特殊模式
```

L3 规则层是核心差异。它允许把架构规范、数据库规范、认证规范等拆分成独立文件，每个文件聚焦一个领域。本插件的 Rule 就运行在这一层。

### 什么该写进上下文

| 该写 | 不该写 |
|------|--------|
| 架构决策（AI 无法从代码推断意图） | 代码模式（AI 能从现有代码学会） |
| 约束条件（业务规则，不是代码能表达的） | 文件路径（AI 能通过搜索发现） |
| 边界定义（跨模块依赖规则） | Git 历史（git log 比手写更准确） |
| 特殊模式（数据隔离要求等） | API 文档（代码本身就是文档） |

判断标准：如果 AI 花 30 秒读代码就能知道的信息，不要写进上下文。如果 AI 读完所有代码仍然可能做错的决策，必须写进上下文。

## 两层架构

```
会话启动
  │
  ▼
Rule 层（自动加载，L3 规则层）
  rules/sdlc-workflow.md
  职责：感知用户意图，引导选择 Skill
  token 开销：最小（只有映射表和约束）
  │
  ▼
Skill 层（按需加载）
  skills/*/SKILL.md
  职责：提供详细的执行指令
  token 开销：仅在激活时加载
```

这种分离直接服务于上下文工程：Rule 始终加载但精简，Skill 包含详细指令但只在需要时占用 token。

## Rule 层：感知与导航

`rules/sdlc-workflow.md` 在每次会话启动时自动加载到上下文中。它只做三件事：

1. **识别**：判断用户的任务是否需要结构化工作流
2. **映射**：将任务阶段映射到对应的技能
3. **约束**：施加核心不变量（plan.md 唯一真相源、审批前不写代码）

Rule 不包含任何技能的执行细节。

## Skill 层：执行与交付

每个 Skill 是一个独立的目录：

```
skills/{skill-name}/
├── SKILL.md              # 主文件：YAML frontmatter + 执行流程
└── references/           # 可选：参考材料（prompt 模板、反模式列表等）
    ├── prompt-a.md
    └── guide-b.md
```

### YAML Frontmatter

```yaml
---
name: skill-name
description: 技能描述。包含触发短语供 AI 匹配。
disable-model-invocation: false    # true = 仅手动触发
argument-hint: [参数说明]           # 可选
allowed-tools: Tool1, Tool2        # 技能可用的工具
---
```

`description` 是 AI 决定是否激活技能的关键。好的 description 包含中英文触发短语、描述技能解决的问题、避免模糊的通用词汇。

### 自动触发 vs 手动触发

| disable-model-invocation | 行为 | 适用场景 |
|--------------------------|------|---------|
| false（默认） | AI 根据上下文自动匹配并激活 | 开发流程技能（brainstorming, debugging 等） |
| true | 只能通过 /name 手动触发 | 工具类技能（done, daily, weekly, writing-skills） |

## Agent 子代理

`agents/` 目录存放可复用的子代理定义。子代理通过 Agent 工具派遣，拥有独立的上下文。

当前定义了一个子代理：
- `code-reviewer.md`：六维度代码审查，三级严重度评级

Skill 中的 `references/` 目录也存放子代理 prompt 模板（如 implementer-prompt.md、spec-reviewer-prompt.md），这些 prompt 在运行时通过 Agent 工具注入给子代理。

## 扩展方式

添加新技能：
1. 创建 `skills/{name}/SKILL.md`
2. 编写 YAML frontmatter 和执行流程
3. 如有参考材料，放在 `skills/{name}/references/`
4. 在 `.claudex-sets.json` 的 skills 数组中添加条目

不需要修改 Rule 层。description 中的触发短语会让 AI 自动发现新技能。
