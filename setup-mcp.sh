#!/usr/bin/env bash
set -euo pipefail

# AI Agents MCP 配置脚本
# 配置 stdio 类型的 MCP 服务（HTTP 类型由插件 .mcp.json 自动加载）
#
# 前置条件：
#   - brew install node@22（提供稳定的 /opt/homebrew/bin/npx）
#   - 环境变量 PERPLEXITY_API_KEY（在 ~/.zsh_secrets 中配置）
#
# 为什么用 brew node 而不是 mise/nvm？
#   Claude Code 的 MCP 子进程直接 spawn，不走 shell 初始化。
#   mise/nvm 的 shims 依赖 shell 激活，子进程中不可用。
#   /opt/homebrew/bin/npx 是固定绝对路径，不受版本切换影响。

BREW_NPX="/opt/homebrew/bin/npx"

# 检查 brew node
if [ ! -x "$BREW_NPX" ]; then
    echo "错误：未找到 $BREW_NPX"
    echo "请先安装：brew install node@22"
    exit 1
fi

echo "使用 node runtime: $($BREW_NPX --version) ($BREW_NPX)"
echo ""

# 从环境变量读取 API Key（优先）或从 .env 文件读取
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -z "${PERPLEXITY_API_KEY:-}" ] && [ -f "$SCRIPT_DIR/.env" ]; then
    source "$SCRIPT_DIR/.env"
fi

echo "配置 stdio 类型 MCP 服务..."
echo ""

# perplexity（stdio，需要 API Key）
if [ -n "${PERPLEXITY_API_KEY:-}" ] && [ "$PERPLEXITY_API_KEY" != "your_perplexity_api_key_here" ]; then
    claude mcp remove perplexity -s user 2>/dev/null || true
    claude mcp add -e "PERPLEXITY_API_KEY=$PERPLEXITY_API_KEY" -s user perplexity -- "$BREW_NPX" -y @perplexity-ai/mcp-server
    echo "  perplexity: done ($BREW_NPX)"
else
    echo "  perplexity: 跳过（未设置 PERPLEXITY_API_KEY）"
fi

# qmd（stdio，无需 API Key）
if command -v qmd &>/dev/null; then
    QMD_PATH="$(command -v qmd)"
    claude mcp remove qmd -s user 2>/dev/null || true
    claude mcp add -s user qmd -- "$QMD_PATH" mcp
    echo "  qmd: done ($QMD_PATH)"
else
    echo "  qmd: 跳过（未安装，可通过 cargo install qmd 安装）"
fi

echo ""
echo "HTTP 类型 MCP（context7、gh_grep）由插件 .mcp.json 自动加载，无需配置。"
echo ""
echo "验证：claude mcp list"
