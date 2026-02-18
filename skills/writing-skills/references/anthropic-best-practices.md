# Anthropic 技能编写最佳实践

## Description 字段

description 是 AI 决定是否激活技能的唯一依据（当 disable-model-invocation 为 false 时）。

### 好的 description

```yaml
description: 协作式需求探索与设计。用苏格拉底式对话将模糊想法转化为结构化的设计规格文档。触发短语："探索需求"、"讨论设计"、"头脑风暴"、"brainstorm"。
```

特点：
- 说明了技能做什么
- 说明了适用场景
- 包含了中英文触发短语

### 差的 description

```yaml
description: 帮助用户进行头脑风暴
```

问题：
- 太模糊，任何对话都可能匹配
- 没有说明具体做什么
- 没有触发短语

## 指令编写

### 用祈使句

```
# 好
读取 plan.md，提取所有待完成任务。

# 差
你应该读取 plan.md 并提取待完成任务。
```

### 给出具体示例

```
# 好
任务描述格式：
- [ ] 在 `src/auth.ts` 的 `validateToken` 函数中添加过期检查

# 差
任务描述要具体。
```

### 用代码块展示命令

```
# 好
运行编译检查：
\`\`\`bash
tsc --noEmit
\`\`\`

# 差
运行编译检查确保代码通过。
```

## 工具限制

只声明技能真正需要的工具。不需要写入文件的技能不要声明 Write 和 Edit。

## References 目录

将详细的参考内容（审查 prompt、反模式列表、方法论）放在 `references/` 子目录中。SKILL.md 通过相对路径引用，保持主文件精简。
