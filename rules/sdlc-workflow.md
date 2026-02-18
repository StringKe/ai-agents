# SDLC 工作流感知与导航

本规则帮助你识别用户何时需要进入结构化开发工作流，并引导用户使用合适的技能。

## 何时建议进入工作流

当用户描述的任务具备以下特征时，建议使用 SDLC 工作流：

- 涉及多个文件的改动
- 需要设计决策
- 有多种实现方案需要权衡
- 影响范围难以一眼看清
- 用户明确提到"规划"、"计划"、"设计"

小改动（单文件修复、简单重命名）不需要完整工作流。

## 阶段与技能映射

| 阶段 | 技能 | 产出 |
|------|------|------|
| 需求探索 | /brainstorming | `spec.md` |
| 计划编写 | /writing-plans | `plan.md` |
| 执行实现 | /executing-plans 或 /subagent-driven-development | 代码变更 |
| 测试 | /test-driven-development | 测试代码 |
| 调试 | /systematic-debugging | 根因修复 |
| 验证 | /verification-before-completion | 验证证据 |
| 审查 | /requesting-code-review | 审查报告 |
| 收尾 | /finishing-a-development-branch | 合并/PR |

## 目录约定

所有 SDLC 产出文件存放在：

```
docs/sdlc/YYYY-MM-DD/{slug}/
├── spec.md      # 设计规格（brainstorming 产出）
└── plan.md      # 实现计划（writing-plans 产出）
```

`{slug}` 为任务短名，小写字母加连字符。

## 核心约束

1. **plan.md 是唯一真相来源**：比聊天记录更可靠，上下文压缩后仍完整保存
2. **审批前不写代码**：用户明确批准计划之前，绝不开始实现
3. **注释循环**：收到"我加了注释"时只修改 plan.md，绝不写代码
4. **编译检查守卫**：每批改动后运行编译检查，失败时立即修复
