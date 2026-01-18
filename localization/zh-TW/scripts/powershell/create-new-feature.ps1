#!/usr/bin/env pwsh
# 建立一個新的特徵
[CmdletBinding()]
param(
    [switch]$Json,
    [string]$ShortName,
    [int]$Number = 0,
    [switch]$Help,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$FeatureDescription
)
$ErrorActionPreference = 'Stop'

# 如果有要求，顯示幫助訊息
if ($Help) {
    Write-Host "用法：./create-new-feature.ps1 [-Json] [-ShortName <名稱>] [-Number N] <特徵描述>"
    Write-Host ""
    Write-Host "選項："
    Write-Host "  -Json               以 JSON 格式輸出"
    Write-Host "  -ShortName <名稱>   為分支提供自定義短名稱（2-4 個單字）"
    Write-Host "  -Number N           手動指定分支編號（覆蓋自動偵測）"
    Write-Host "  -Help               顯示此幫助訊息"
    Write-Host ""
    Write-Host "範例："
    Write-Host "  ./create-new-feature.ps1 'Add user authentication system' -ShortName 'user-auth'"
    Write-Host "  ./create-new-feature.ps1 'Implement OAuth2 integration for API'"
    exit 0
}

# 檢查是否提供了特徵描述
if (-not $FeatureDescription -or $FeatureDescription.Count -eq 0) {
    Write-Error "用法：./create-new-feature.ps1 [-Json] [-ShortName <名稱>] <特徵描述>"
    exit 1
}

$featureDesc = ($FeatureDescription -join ' ').Trim()

# 解析儲存庫根目錄。偏好使用 git 資訊（如果可用），
# 否則回退到搜尋儲存庫標記，
# 以便工作流在初始時使用 --no-git 的儲存庫中仍能運作。
function Find-RepositoryRoot {
    param(
        [string]$StartDir,
        [string[]]$Markers = @('.git', '.specify')
    )
    $current = Resolve-Path $StartDir
    while ($true) {
        foreach ($marker in $Markers) {
            if (Test-Path (Join-Path $current $marker)) {
                return $current
            }
        }
        $parent = Split-Path $current -Parent
        if ($parent -eq $current) {
            # 到達檔案系統根目錄但找不到標記
            return $null
        }
        $current = $parent
    }
}

function Get-HighestNumberFromSpecs {
    param([string]$SpecsDir)

    $highest = 0
    if (Test-Path $SpecsDir) {
        Get-ChildItem -Path $SpecsDir -Directory | ForEach-Object {
            if ($_.Name -match '^(\d+)') {
                $num = [int]$matches[1]
                if ($num -gt $highest) { $highest = $num }
            }
        }
    }
    return $highest
}

function Get-HighestNumberFromBranches {
    param()

    $highest = 0
    try {
        $branches = git branch -a 2>$null
        if ($LASTEXITCODE -eq 0) {
            foreach ($branch in $branches) {
                # 清理分支名稱：移除前導標記和遠端前綴
                $cleanBranch = $branch.Trim() -replace '^\*?\s+', '' -replace '^remotes/[^/]+/', ''

                # 如果分支匹配模式 ###-*，則提取特徵編號
                if ($cleanBranch -match '^(\d+)-') {
                    $num = [int]$matches[1]
                    if ($num -gt $highest) { $highest = $num }
                }
            }
        }
    } catch {
        # 如果 git 指令失敗，傳回 0
        Write-Verbose "無法檢查 Git 分支：$_"
    }
    return $highest
}

function Get-NextBranchNumber {
    param(
        [string]$SpecsDir
    )

    # 獲取所有遠端以取得最新的分支資訊（如果沒有遠端則隱藏錯誤）
    try {
        git fetch --all --prune 2>$null | Out-Null
    } catch {
        # 忽略 fetch 錯誤
    }

    # 從所有分支（而不僅僅是匹配短名稱的分支）獲取最大編號
    $highestBranch = Get-HighestNumberFromBranches

    # 從所有規格（而不僅僅是匹配短名稱的規格）獲取最大編號
    $highestSpec = Get-HighestNumberFromSpecs -SpecsDir $SpecsDir

    # 取兩者的最大值
    $maxNum = [Math]::Max($highestBranch, $highestSpec)

    # 傳回下一個編號
    return $maxNum + 1
}

function ConvertTo-CleanBranchName {
    param([string]$Name)

    return $Name.ToLower() -replace '[^a-z0-9]', '-' -replace '-{2,}', '-' -replace '^-', '' -replace '-$', ''
}
$fallbackRoot = (Find-RepositoryRoot -StartDir $PSScriptRoot)
if (-not $fallbackRoot) {
    Write-Error "錯誤：無法確定儲存庫根目錄。請從儲存庫內執行此腳本。"
    exit 1
}

try {
    $repoRoot = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0) {
        $hasGit = $true
    } else {
        throw "Git 不可用"
    }
} catch {
    $repoRoot = $fallbackRoot
    $hasGit = $false
}

Set-Location $repoRoot

$specsDir = Join-Path $repoRoot 'specs'
New-Item -ItemType Directory -Path $specsDir -Force | Out-Null

# 透過停用詞過濾和長度過濾生成分支名稱的函式
function Get-BranchName {
    param([string]$Description)

    # 要過濾掉的常見停用詞
    $stopWords = @(
        'i', 'a', 'an', 'the', 'to', 'for', 'of', 'in', 'on', 'at', 'by', 'with', 'from',
        'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had',
        'do', 'does', 'did', 'will', 'would', 'should', 'could', 'can', 'may', 'might', 'must', 'shall',
        'this', 'that', 'these', 'those', 'my', 'your', 'our', 'their',
        'want', 'need', 'add', 'get', 'set'
    )

    # 轉換為小寫並提取單字（僅限英數字）
    $cleanName = $Description.ToLower() -replace '[^a-z0-9\s]', ' '
    $words = $cleanName -split '\s+' | Where-Object { $_ }

    # 過濾單字：移除停用詞和短於 3 個字元的單字（除非它們在原始描述中是大寫縮寫）
    $meaningfulWords = @()
    foreach ($word in $words) {
        # 跳過停用詞
        if ($stopWords -contains $word) { continue }

        # 保留長度 >= 3 或在原始描述中以大寫形式出現（可能是縮寫）的單字
        if ($word.Length -ge 3) {
            $meaningfulWords += $word
        } elseif ($Description -match "\b$($word.ToUpper())\b") {
            # 如果短單字在原始描述中以大寫形式出現（可能是縮寫），則保留它們
            $meaningfulWords += $word
        }
    }

    # 如果我們有具意義的單字，使用其中的前 3-4 個
    if ($meaningfulWords.Count -gt 0) {
        $maxWords = if ($meaningfulWords.Count -eq 4) { 4 } else { 3 }
        $result = ($meaningfulWords | Select-Object -First $maxWords) -join '-'
        return $result
    } else {
        # 如果找不到具意義的單字，則回退到原始邏輯
        $result = ConvertTo-CleanBranchName -Name $Description
        $fallbackWords = ($result -split '-') | Where-Object { $_ } | Select-Object -First 3
        return [string]::Join('-', $fallbackWords)
    }
}

# 生成分支名稱
if ($ShortName) {
    # 使用提供的短名稱，僅進行清理
    $branchSuffix = ConvertTo-CleanBranchName -Name $ShortName
} else {
    # 從描述中進行智慧過濾生成
    $branchSuffix = Get-BranchName -Description $featureDesc
}

# 決定分支編號
if ($Number -eq 0) {
    if ($hasGit) {
        # 檢查遠端上的現有分支
        $Number = Get-NextBranchNumber -SpecsDir $specsDir
    } else {
        # 回退到本地目錄檢查
        $Number = (Get-HighestNumberFromSpecs -SpecsDir $specsDir) + 1
    }
}

$featureNum = ('{0:000}' -f $Number)
$branchName = "$featureNum-$branchSuffix"

# GitHub 對分支名稱強制執行 244 位元組的限制
# 驗證並在必要時截斷
$maxBranchLength = 244
if ($branchName.Length -gt $maxBranchLength) {
    # 計算我們需要從後綴修剪多少
    # 考慮到：特徵編號 (3) + 連字號 (1) = 4 個字元
    $maxSuffixLength = $maxBranchLength - 4

    # 截斷後綴
    $truncatedSuffix = $branchSuffix.Substring(0, [Math]::Min($branchSuffix.Length, $maxSuffixLength))
    # 如果截斷產生了尾隨連字號，則將其移除
    $truncatedSuffix = $truncatedSuffix -replace '-$', ''

    $originalBranchName = $branchName
    $branchName = "$featureNum-$truncatedSuffix"

    Write-Warning "[specify] 分支名稱超過 GitHub 的 244 位元組限制"
    Write-Warning "[specify] 原始：$originalBranchName ($($originalBranchName.Length) 位元組)"
    Write-Warning "[specify] 截斷為：$branchName ($($branchName.Length) 位元組)"
}

if ($hasGit) {
    try {
        git checkout -b $branchName | Out-Null
    } catch {
        Write-Warning "建立 git 分支失敗：$branchName"
    }
} else {
    Write-Warning "[specify] 警告：未偵測到 Git 儲存庫；跳過 $branchName 的分支建立"
}

$featureDir = Join-Path $specsDir $branchName
New-Item -ItemType Directory -Path $featureDir -Force | Out-Null

$template = Join-Path $repoRoot '.specify/templates/spec-template.md'
$specFile = Join-Path $featureDir 'spec.md'
if (Test-Path $template) {
    Copy-Item $template $specFile -Force
} else {
    New-Item -ItemType File -Path $specFile | Out-Null
}

# 為目前工作階段設定 SPECIFY_FEATURE 環境變數
$env:SPECIFY_FEATURE = $branchName

if ($Json) {
    $obj = [PSCustomObject]@{
        BRANCH_NAME = $branchName
        SPEC_FILE = $specFile
        FEATURE_NUM = $featureNum
        HAS_GIT = $hasGit
    }
    $obj | ConvertTo-Json -Compress
} else {
    Write-Output "BRANCH_NAME: $branchName"
    Write-Output "SPEC_FILE: $specFile"
    Write-Output "FEATURE_NUM: $featureNum"
    Write-Output "HAS_GIT: $hasGit"
    Write-Output "SPECIFY_FEATURE 環境變數已設定為：$branchName"
}
