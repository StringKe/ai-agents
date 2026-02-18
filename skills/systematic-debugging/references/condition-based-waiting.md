# 基于条件的等待

## 问题

在异步系统中，使用 `sleep()` 等待是最常见的调试陷阱：
- sleep 时间太短：条件未满足，测试失败
- sleep 时间太长：浪费时间，测试套件变慢
- 不同环境速度不同：本地通过，CI 失败

## 原则

**用条件等待替代固定等待。**

不要问"等多久"，要问"等什么"。

## 模式

### 轮询等待

```
function waitFor(condition, timeout, interval):
    deadline = now() + timeout
    while now() < deadline:
        if condition():
            return true
        sleep(interval)
    throw TimeoutError("条件未在 {timeout} 内满足")
```

### 事件驱动等待

如果系统支持事件或回调，优先使用：

```
await eventEmitter.once('ready', { timeout: 5000 })
```

### 健康检查等待

等待服务就绪时：

```bash
# 等待 HTTP 服务可用
timeout 30 bash -c 'until curl -sf http://localhost:8080/health; do sleep 1; done'

# 等待端口可用
timeout 30 bash -c 'until nc -z localhost 5432; do sleep 1; done'
```

## 反模式

```
# 不要这样做
sleep 5  # 为什么是 5 秒？依据是什么？

# 应该这样做
waitFor(() => server.isReady(), timeout=10s, interval=100ms)
```

## 在测试中的应用

- 单元测试：不应该需要任何等待
- 集成测试：使用轮询等待，超时时间不超过 10 秒
- 端到端测试：使用事件驱动或健康检查等待，超时时间不超过 30 秒
