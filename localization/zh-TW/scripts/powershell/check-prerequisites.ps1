#!/usr/bin/env pwsh

# 統合的先決條件檢查腳本 (PowerShell 版)
#
# 此腳本為規格驅動開發 (Spec-Driven Development) 工作流提供統一的先決條件檢查。
# 它取代了之前分散在多個腳本中的功能。
#
# 用法：./check-prerequisites.ps1 [選項]
#
# 選項：
#   -Json               以 JSON 格式輸出
#   -RequireTasks       要求 tasks.md 必須存在（用於實作階段）
#   -IncludeTasks       在 AVAILABLE_DOCS 列表中包含 tasks.md
#   -PathsOnly          僅輸出路徑變數（無驗證）
#   -Help, -h           顯示幫助訊息

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$RequireTasks,
    [switch]$IncludeTasks,
    [switch]$PathsOnly,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# 如果有要求，顯示幫助訊息
if ($Help) {
    Write-Output @"
用法：check-prerequisites.ps1 [選項]

統合的先決條件檢查，用於規格驅動開發 (Spec-Driven Development) 工作流。

選項：
  -Json               以 JSON 格式輸出
  -RequireTasks       要求 tasks.md 必須存在（用於實作階段）
  -IncludeTasks       在 AVAILABLE_DOCS 列表中包含 tasks.md
  -PathsOnly          僅輸出路徑變數（不進行先決條件驗證）
  -Help, -h           顯示此幫助訊息

範例：
  # 檢查工作先決條件（需要 plan.md）
  .\check-prerequisites.ps1 -Json
  
  # 檢查實作先決條件（需要 plan.md + tasks.md）
  .\check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
  
  # 僅獲取特徵路徑（無驗證）
  .\check-prerequisites.ps1 -PathsOnly

"@
    exit 0
}

# 載入通用函式
. "$PSScriptRoot/common.ps1"

# 獲取特徵路徑並驗證分支
$paths = Get-FeaturePathsEnv

if (-not (Test-FeatureBranch -Branch $paths.CURRENT_BRANCH -HasGit:$paths.HAS_GIT)) { 
    exit 1 
}

# 如果是僅路徑模式，輸出路徑並退出（支援結合 -Json -PathsOnly）
if ($PathsOnly) {
    if ($Json) {
        [PSCustomObject]@{
            REPO_ROOT    = $paths.REPO_ROOT
            BRANCH       = $paths.CURRENT_BRANCH
            FEATURE_DIR  = $paths.FEATURE_DIR
            FEATURE_SPEC = $paths.FEATURE_SPEC
            IMPL_PLAN    = $paths.IMPL_PLAN
            TASKS        = $paths.TASKS
        } | ConvertTo-Json -Compress
    } else {
        Write-Output "REPO_ROOT: $($paths.REPO_ROOT)"
        Write-Output "BRANCH: $($paths.CURRENT_BRANCH)"
        Write-Output "FEATURE_DIR: $($paths.FEATURE_DIR)"
        Write-Output "FEATURE_SPEC: $($paths.FEATURE_SPEC)"
        Write-Output "IMPL_PLAN: $($paths.IMPL_PLAN)"
        Write-Output "TASKS: $($paths.TASKS)"
    }
    exit 0
}

# 驗證必要的目錄和檔案
if (-not (Test-Path $paths.FEATURE_DIR -PathType Container)) {
    Write-Output "錯誤：找不到特徵目錄：$($paths.FEATURE_DIR)"
    Write-Output "先執行 /speckit.specify 以建立特徵結構。"
    exit 1
}

if (-not (Test-Path $paths.IMPL_PLAN -PathType Leaf)) {
    Write-Output "錯誤：在 $($paths.FEATURE_DIR) 中找不到 plan.md"
    Write-Output "先執行 /speckit.plan 以建立實作計畫。"
    exit 1
}

# 如果需要，檢查 tasks.md
if ($RequireTasks -and -not (Test-Path $paths.TASKS -PathType Leaf)) {
    Write-Output "錯誤：在 $($paths.FEATURE_DIR) 中找不到 tasks.md"
    Write-Output "先執行 /speckit.tasks 以建立工作列表。"
    exit 1
}

# 建立可用文件列表
$docs = @()

# 始終檢查這些選擇性文件
if (Test-Path $paths.RESEARCH) { $docs += 'research.md' }
if (Test-Path $paths.DATA_MODEL) { $docs += 'data-model.md' }

# 檢查合約目錄（僅當其存在且包含檔案時）
if ((Test-Path $paths.CONTRACTS_DIR) -and (Get-ChildItem -Path $paths.CONTRACTS_DIR -ErrorAction SilentlyContinue | Select-Object -First 1)) { 
    $docs += 'contracts/' 
}

if (Test-Path $paths.QUICKSTART) { $docs += 'quickstart.md' }

# 如果有要求且存在，則包含 tasks.md
if ($IncludeTasks -and (Test-Path $paths.TASKS)) { 
    $docs += 'tasks.md' 
}

# 輸出結果
if ($Json) {
    # JSON 輸出
    [PSCustomObject]@{ 
        FEATURE_DIR = $paths.FEATURE_DIR
        AVAILABLE_DOCS = $docs 
    } | ConvertTo-Json -Compress
} else {
    # 文字輸出
    Write-Output "FEATURE_DIR:$($paths.FEATURE_DIR)"
    Write-Output "AVAILABLE_DOCS:"
    
    # 顯示每個潛在文件的狀態
    Test-FileExists -Path $paths.RESEARCH -Description 'research.md' | Out-Null
    Test-FileExists -Path $paths.DATA_MODEL -Description 'data-model.md' | Out-Null
    Test-DirHasFiles -Path $paths.CONTRACTS_DIR -Description 'contracts/' | Out-Null
    Test-FileExists -Path $paths.QUICKSTART -Description 'quickstart.md' | Out-Null
    
    if ($IncludeTasks) {
        Test-FileExists -Path $paths.TASKS -Description 'tasks.md' | Out-Null
    }
}
