#!/usr/bin/env pwsh
# 設定特徵的實作計畫

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# 如果有要求，顯示幫助訊息
if ($Help) {
    Write-Output "用法：./setup-plan.ps1 [-Json] [-Help]"
    Write-Output "  -Json     以 JSON 格式輸出結果"
    Write-Output "  -Help     顯示此幫助訊息"
    exit 0
}

# 載入通用函式
. "$PSScriptRoot/common.ps1"

# 從通用函式中獲取所有路徑與變數
$paths = Get-FeaturePathsEnv

# 檢查我們是否在正確的特徵分支上（僅適用於 git 儲存庫）
if (-not (Test-FeatureBranch -Branch $paths.CURRENT_BRANCH -HasGit $paths.HAS_GIT)) { 
    exit 1 
}

# 確保特徵目錄存在
New-Item -ItemType Directory -Path $paths.FEATURE_DIR -Force | Out-Null

# 如果計畫範本存在，則進行複製，否則記錄下來或建立空白檔案
$template = Join-Path $paths.REPO_ROOT '.specify/templates/plan-template.md'
if (Test-Path $template) { 
    Copy-Item $template $paths.IMPL_PLAN -Force
    Write-Output "已將計畫範本複製到 $($paths.IMPL_PLAN)"
} else {
    Write-Warning "在 $template 找不到計畫範本"
    # 如果範本不存在，則建立基本的計畫檔案
    New-Item -ItemType File -Path $paths.IMPL_PLAN -Force | Out-Null
}

# 輸出結果
if ($Json) {
    $result = [PSCustomObject]@{ 
        FEATURE_SPEC = $paths.FEATURE_SPEC
        IMPL_PLAN = $paths.IMPL_PLAN
        SPECS_DIR = $paths.FEATURE_DIR
        BRANCH = $paths.CURRENT_BRANCH
        HAS_GIT = $paths.HAS_GIT
    }
    $result | ConvertTo-Json -Compress
} else {
    Write-Output "FEATURE_SPEC: $($paths.FEATURE_SPEC)"
    Write-Output "IMPL_PLAN: $($paths.IMPL_PLAN)"
    Write-Output "SPECS_DIR: $($paths.FEATURE_DIR)"
    Write-Output "BRANCH: $($paths.CURRENT_BRANCH)"
    Write-Output "HAS_GIT: $($paths.HAS_GIT)"
}
