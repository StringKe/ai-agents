#!/usr/bin/env bash
set -euo pipefail

# AI Agents MCP 配置脚本
# 读取 .env 文件中的 API Key，通过 claude mcp add 注册 MCP 服务

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "错误：找不到 .env 文件"
    echo "请先执行：cp .env.example .env 并填入 API Key"
    exit 1
fi

source "$ENV_FILE"

echo "开始配置 MCP 服务..."
echo ""

# context7
if [ -n "${CONTEXT7_API_KEY:-}" ] && [ "$CONTEXT7_API_KEY" != "your_context7_api_key_here" ]; then
    claude mcp remove context7 -s user 2>/dev/null || true
    claude mcp add -t http -H "CONTEXT7_API_KEY: $CONTEXT7_API_KEY" -s user context7 https://mcp.context7.com/mcp
    echo "  context7: 已配置"
else
    echo "  context7: 跳过（未设置 CONTEXT7_API_KEY）"
fi

# gh_grep
claude mcp remove gh_grep -s user 2>/dev/null || true
claude mcp add -t http -s user gh_grep https://mcp.grep.app
echo "  gh_grep: 已配置"

# perplexity
if [ -n "${PERPLEXITY_API_KEY:-}" ] && [ "$PERPLEXITY_API_KEY" != "your_perplexity_api_key_here" ]; then
    claude mcp remove perplexity -s user 2>/dev/null || true
    claude mcp add -e "PERPLEXITY_API_KEY=$PERPLEXITY_API_KEY" -s user perplexity -- npx -y @perplexity-ai/mcp-server
    echo "  perplexity: 已配置"
else
    echo "  perplexity: 跳过（未设置 PERPLEXITY_API_KEY）"
fi

# qmd
if command -v qmd &>/dev/null; then
    claude mcp remove qmd -s user 2>/dev/null || true
    claude mcp add -s user qmd -- qmd mcp
    echo "  qmd: 已配置"
else
    echo "  qmd: 跳过（未安装，可通过 npm i -g @tobilu/qmd 安装）"
fi

echo ""
echo "配置完成。运行 claude mcp list 验证。"
