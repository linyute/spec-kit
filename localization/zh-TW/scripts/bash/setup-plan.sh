#!/usr/bin/env bash

set -e

# 解析命令列參數
JSON_MODE=false
ARGS=()

for arg in "$@"; do
    case "$arg" in
        --json) 
            JSON_MODE=true 
            ;;
        --help|-h) 
            echo "用法：$0 [--json]"
            echo "  --json    以 JSON 格式輸出結果"
            echo "  --help    顯示此幫助訊息"
            exit 0 
            ;;
        *) 
            ARGS+=("$arg") 
            ;;
    esac
done

# 獲取腳本目錄並載入通用函式
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# 從通用函式中獲取所有路徑與變數
eval $(get_feature_paths)

# 檢查我們是否在正確的特徵分支上（僅適用於 git 儲存庫）
check_feature_branch "$CURRENT_BRANCH" "$HAS_GIT" || exit 1

# 確保特徵目錄存在
mkdir -p "$FEATURE_DIR"

# 如果計畫範本存在，則進行複製
TEMPLATE="$REPO_ROOT/.specify/templates/plan-template.md"
if [[ -f "$TEMPLATE" ]]; then
    cp "$TEMPLATE" "$IMPL_PLAN"
    echo "已將計畫範本複製到 $IMPL_PLAN"
else
    echo "警告：在 $TEMPLATE 找不到計畫範本"
    # 如果範本不存在，則建立基本的計畫檔案
    touch "$IMPL_PLAN"
fi

# 輸出結果
if $JSON_MODE; then
    printf '{"FEATURE_SPEC":"%s","IMPL_PLAN":"%s","SPECS_DIR":"%s","BRANCH":"%s","HAS_GIT":"%s"}\n' \
        "$FEATURE_SPEC" "$IMPL_PLAN" "$FEATURE_DIR" "$CURRENT_BRANCH" "$HAS_GIT"
else
    echo "FEATURE_SPEC: $FEATURE_SPEC"
    echo "IMPL_PLAN: $IMPL_PLAN" 
    echo "SPECS_DIR: $FEATURE_DIR"
    echo "BRANCH: $CURRENT_BRANCH"
    echo "HAS_GIT: $HAS_GIT"
fi
