#!/usr/bin/env bash
# 所有腳本的通用函式與變數

# 獲取儲存庫根目錄，針對非 git 儲存庫提供備案
get_repo_root() {
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
        git rev-parse --show-toplevel
    else
        # 針對非 git 儲存庫回退到腳本位置
        local script_dir="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        (cd "$script_dir/../../.." && pwd)
    fi
}

# 獲取目前分支，針對非 git 儲存庫提供備案
get_current_branch() {
    # 首先檢查是否設定了 SPECIFY_FEATURE 環境變數
    if [[ -n "${SPECIFY_FEATURE:-}" ]]; then
        echo "$SPECIFY_FEATURE"
        return
    fi

    # 然後檢查 git 是否可用
    if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
        git rev-parse --abbrev-ref HEAD
        return
    fi

    # 針對非 git 儲存庫，嘗試尋找最新的特徵目錄
    local repo_root=$(get_repo_root)
    local specs_dir="$repo_root/specs"

    if [[ -d "$specs_dir" ]]; then
        local latest_feature=""
        local highest=0

        for dir in "$specs_dir"/*; do
            if [[ -d "$dir" ]]; then
                local dirname=$(basename "$dir")
                if [[ "$dirname" =~ ^([0-9]{3})- ]]; then
                    local number=${BASH_REMATCH[1]}
                    number=$((10#$number))
                    if [[ "$number" -gt "$highest" ]]; then
                        highest=$number
                        latest_feature=$dirname
                    fi
                fi
            fi
        done

        if [[ -n "$latest_feature" ]]; then
            echo "$latest_feature"
            return
        fi
    fi

    echo "main"  # 最終備案
}

# 檢查 git 是否可用
has_git() {
    git rev-parse --show-toplevel >/dev/null 2>&1
}

check_feature_branch() {
    local branch="$1"
    local has_git_repo="$2"

    # 針對非 git 儲存庫，我們無法強制執行分支命名規範，但仍提供輸出
    if [[ "$has_git_repo" != "true" ]]; then
        echo "[specify] 警告：未偵測到 Git 儲存庫；跳過分支驗證" >&2
        return 0
    fi

    if [[ ! "$branch" =~ ^[0-9]{3}- ]]; then
        echo "錯誤：不在特徵分支上。目前分支：$branch" >&2
        echo "特徵分支的命名應如：001-feature-name" >&2
        return 1
    fi

    return 0
}

get_feature_dir() { echo "$1/specs/$2"; }

# 透過數字前綴而非精確的分支匹配來尋找特徵目錄
# 這允許複數分支在同一個規格上工作（例如：004-fix-bug, 004-add-feature）
find_feature_dir_by_prefix() {
    local repo_root="$1"
    local branch_name="$2"
    local specs_dir="$repo_root/specs"

    # 從分支中提取數字前綴（例如：從 "004-whatever" 中提取 "004"）
    if [[ ! "$branch_name" =~ ^([0-9]{3})- ]]; then
        # 如果分支沒有數字前綴，則回退到精確匹配
        echo "$specs_dir/$branch_name"
        return
    fi

    local prefix="${BASH_REMATCH[1]}"

    # 在 specs/ 中搜尋以該前綴開頭的目錄
    local matches=()
    if [[ -d "$specs_dir" ]]; then
        for dir in "$specs_dir"/"$prefix"-*; do
            if [[ -d "$dir" ]]; then
                matches+=("$(basename "$dir")")
            fi
        done
    fi

    # 處理結果
    if [[ ${#matches[@]} -eq 0 ]]; then
        # 找不到匹配項 - 傳回分支名稱路徑（稍後將失敗並顯示明確錯誤）
        echo "$specs_dir/$branch_name"
    elif [[ ${#matches[@]} -eq 1 ]]; then
        # 正好一個匹配項 - 完美！
        echo "$specs_dir/${matches[0]}"
    else
        # 多個匹配項 - 在正確的命名規範下不應發生這種情況
        echo "錯誤：發現多個具有前綴 '$prefix' 的規格目錄：${matches[*]}" >&2
        echo "請確保每個數字前綴只存在一個規格目錄。" >&2
        echo "$specs_dir/$branch_name"  # 傳回某些內容以避免中斷腳本
    fi
}

get_feature_paths() {
    local repo_root=$(get_repo_root)
    local current_branch=$(get_current_branch)
    local has_git_repo="false"

    if has_git; then
        has_git_repo="true"
    fi

    # 使用基於前綴的查找以支援每個規格對應多個分支
    local feature_dir=$(find_feature_dir_by_prefix "$repo_root" "$current_branch")

    cat <<EOF
REPO_ROOT='$repo_root'
CURRENT_BRANCH='$current_branch'
HAS_GIT='$has_git_repo'
FEATURE_DIR='$feature_dir'
FEATURE_SPEC='$feature_dir/spec.md'
IMPL_PLAN='$feature_dir/plan.md'
TASKS='$feature_dir/tasks.md'
RESEARCH='$feature_dir/research.md'
DATA_MODEL='$feature_dir/data-model.md'
QUICKSTART='$feature_dir/quickstart.md'
CONTRACTS_DIR='$feature_dir/contracts'
EOF
}

check_file() { [[ -f "$1" ]] && echo "  ✓ $2" || echo "  ✗ $2"; }
check_dir() { [[ -d "$1" && -n $(ls -A "$1" 2>/dev/null) ]] && echo "  ✓ $2" || echo "  ✗ $2"; }
