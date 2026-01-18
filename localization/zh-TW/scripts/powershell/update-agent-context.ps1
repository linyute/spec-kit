#!/usr/bin/env pwsh
<#
.SYNOPSIS
使用來自 plan.md 的資訊更新代理程式 (agent) 上下文檔案 (PowerShell 版)

.DESCRIPTION
鏡像 scripts/bash/update-agent-context.sh 的行為：
 1. 環境驗證
 2. 計畫資料提取
 3. 代理程式檔案管理（從範本建立或更新現有檔案）
 4. 內容生成（技術堆疊、最近變更、時間戳記）
 5. 多代理程式支援 (claude, gemini, copilot, cursor-agent, qwen, opencode, codex, windsurf, kilocode, auggie, roo, codebuddy, amp, shai, q, bob, qoder)

.PARAMETER AgentType
選擇性的代理程式金鑰，用以更新單一代理程式。如果省略，則更新所有現有的代理程式檔案（如果不存在則建立預設的 Claude 檔案）。

.EXAMPLE
./update-agent-context.ps1 -AgentType claude

.EXAMPLE
./update-agent-context.ps1   # 更新所有現有的代理程式檔案

.NOTES
依賴於 common.ps1 中的通用輔助函式
#>
param(
    [Parameter(Position=0)]
    [ValidateSet('claude','gemini','copilot','cursor-agent','qwen','opencode','codex','windsurf','kilocode','auggie','roo','codebuddy','amp','shai','q','bob','qoder')]
    [string]$AgentType
)

$ErrorActionPreference = 'Stop'

# 匯入通用輔助函式
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir 'common.ps1')

# 獲取環境路徑
$envData = Get-FeaturePathsEnv
$REPO_ROOT     = $envData.REPO_ROOT
$CURRENT_BRANCH = $envData.CURRENT_BRANCH
$HAS_GIT       = $envData.HAS_GIT
$IMPL_PLAN     = $envData.IMPL_PLAN
$NEW_PLAN = $IMPL_PLAN

# 代理程式檔案路徑
$CLAUDE_FILE   = Join-Path $REPO_ROOT 'CLAUDE.md'
$GEMINI_FILE   = Join-Path $REPO_ROOT 'GEMINI.md'
$COPILOT_FILE  = Join-Path $REPO_ROOT '.github/agents/copilot-instructions.md'
$CURSOR_FILE   = Join-Path $REPO_ROOT '.cursor/rules/specify-rules.mdc'
$QWEN_FILE     = Join-Path $REPO_ROOT 'QWEN.md'
$AGENTS_FILE   = Join-Path $REPO_ROOT 'AGENTS.md'
$WINDSURF_FILE = Join-Path $REPO_ROOT '.windsurf/rules/specify-rules.md'
$KILOCODE_FILE = Join-Path $REPO_ROOT '.kilocode/rules/specify-rules.md'
$AUGGIE_FILE   = Join-Path $REPO_ROOT '.augment/rules/specify-rules.md'
$ROO_FILE      = Join-Path $REPO_ROOT '.roo/rules/specify-rules.md'
$CODEBUDDY_FILE = Join-Path $REPO_ROOT 'CODEBUDDY.md'
$QODER_FILE    = Join-Path $REPO_ROOT 'QODER.md'
$AMP_FILE      = Join-Path $REPO_ROOT 'AGENTS.md'
$SHAI_FILE     = Join-Path $REPO_ROOT 'SHAI.md'
$Q_FILE        = Join-Path $REPO_ROOT 'AGENTS.md'
$BOB_FILE      = Join-Path $REPO_ROOT 'AGENTS.md'

$TEMPLATE_FILE = Join-Path $REPO_ROOT '.specify/templates/agent-file-template.md'

# 已解析計畫資料的佔位符
$script:NEW_LANG = ''
$script:NEW_FRAMEWORK = ''
$script:NEW_DB = ''
$script:NEW_PROJECT_TYPE = ''

function Write-Info {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Host "資訊：$Message"
}

function Write-Success {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Host "$([char]0x2713) $Message"
}

function Write-WarningMsg {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Warning $Message
}

function Write-Err {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    Write-Host "錯誤：$Message" -ForegroundColor Red
}

function Validate-Environment {
    if (-not $CURRENT_BRANCH) {
        Write-Err '無法確定目前特徵'
        if ($HAS_GIT) { Write-Info "請確保您位於特徵分支上" } else { Write-Info '請設定 SPECIFY_FEATURE 環境變數或先建立特徵' }
        exit 1
    }
    if (-not (Test-Path $NEW_PLAN)) {
        Write-Err "在 $NEW_PLAN 找不到 plan.md"
        Write-Info '請確保您正在處理具有對應規格目錄的特徵'
        if (-not $HAS_GIT) { Write-Info '使用：$env:SPECIFY_FEATURE=您的特徵名稱，或先建立一個新特徵' }
        exit 1
    }
    if (-not (Test-Path $TEMPLATE_FILE)) {
        Write-Err "在 $TEMPLATE_FILE 找不到範本檔案"
        Write-Info '執行 specify init 以建構 .specify/templates，或在該處新增 agent-file-template.md。'
        exit 1
    }
}

function Extract-PlanField {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FieldPattern,
        [Parameter(Mandatory=$true)]
        [string]$PlanFile
    )
    if (-not (Test-Path $PlanFile)) { return '' }
    # 類似於 **Language/Version**: Python 3.12 的行
    $regex = "^\*\*($([Regex]::Escape($FieldPattern)))\*\*: (.+)$"
    Get-Content -LiteralPath $PlanFile -Encoding utf8 | ForEach-Object {
        if ($_ -match $regex) {
            $val = $Matches[1].Trim()
            if ($val -notin @('NEEDS CLARIFICATION','N/A')) { return $val }
        }
    } | Select-Object -First 1
}

function Parse-PlanData {
    param(
        [Parameter(Mandatory=$true)]
        [string]$PlanFile
    )
    if (-not (Test-Path $PlanFile)) { Write-Err "找不到計畫檔案：$PlanFile"; return $false }
    Write-Info "正在從 $PlanFile 解析計畫資料"
    $script:NEW_LANG        = Extract-PlanField -FieldPattern 'Language/Version' -PlanFile $PlanFile
    $script:NEW_FRAMEWORK   = Extract-PlanField -FieldPattern 'Primary Dependencies' -PlanFile $PlanFile
    $script:NEW_DB          = Extract-PlanField -FieldPattern 'Storage' -PlanFile $PlanFile
    $script:NEW_PROJECT_TYPE = Extract-PlanField -FieldPattern 'Project Type' -PlanFile $PlanFile

    if ($NEW_LANG) { Write-Info "發現語言：$NEW_LANG" } else { Write-WarningMsg '在計畫中找不到語言資訊' }
    if ($NEW_FRAMEWORK) { Write-Info "發現框架：$NEW_FRAMEWORK" }
    if ($NEW_DB -and $NEW_DB -ne 'N/A') { Write-Info "發現資料庫：$NEW_DB" }
    if ($NEW_PROJECT_TYPE) { Write-Info "發現專案類型：$NEW_PROJECT_TYPE" }
    return $true
}

function Format-TechnologyStack {
    param(
        [Parameter(Mandatory=$false)]
        [string]$Lang,
        [Parameter(Mandatory=$false)]
        [string]$Framework
    )
    $parts = @()
    if ($Lang -and $Lang -ne 'NEEDS CLARIFICATION') { $parts += $Lang }
    if ($Framework -and $Framework -notin @('NEEDS CLARIFICATION','N/A')) { $parts += $Framework }
    if (-not $parts) { return '' }
    return ($parts -join ' + ')
}

function Get-ProjectStructure {
    param(
        [Parameter(Mandatory=$false)]
        [string]$ProjectType
    )
    if ($ProjectType -match 'web') { return "backend/`nfrontend/`ntests/" } else { return "src/`ntests/" }
}

function Get-CommandsForLanguage {
    param(
        [Parameter(Mandatory=$false)]
        [string]$Lang
    )
    switch -Regex ($Lang) {
        'Python' { return "cd src; pytest; ruff check ."
        'Rust' { return "cargo test; cargo clippy"
        'JavaScript|TypeScript' { return "npm test; npm run lint"
        default { return "# 為 $Lang 新增指令" }
    }
}

function Get-LanguageConventions {
    param(
        [Parameter(Mandatory=$false)]
        [string]$Lang
    )
    if ($Lang) { "${Lang}：遵循標準規範" } else { '通用：遵循標準規範' }
}

function New-AgentFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TargetFile,
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        [Parameter(Mandatory=$true)]
        [datetime]$Date
    )
    if (-not (Test-Path $TEMPLATE_FILE)) { Write-Err "在 $TEMPLATE_FILE 找不到範本"; return $false }
    $temp = New-TemporaryFile
    Copy-Item -LiteralPath $TEMPLATE_FILE -Destination $temp -Force

    $projectStructure = Get-ProjectStructure -ProjectType $NEW_PROJECT_TYPE
    $commands = Get-CommandsForLanguage -Lang $NEW_LANG
    $languageConventions = Get-LanguageConventions -Lang $NEW_LANG

    $escaped_lang = $NEW_LANG
    $escaped_framework = $NEW_FRAMEWORK
    $escaped_branch = $CURRENT_BRANCH

    $content = Get-Content -LiteralPath $temp -Raw -Encoding utf8
    $content = $content -replace '\[PROJECT NAME\]',$ProjectName
    $content = $content -replace '\[DATE\]',$Date.ToString('yyyy-MM-dd')

    # 安全地建構技術堆疊字串
    $techStackForTemplate = ""
    if ($escaped_lang -and $escaped_framework) {
        $techStackForTemplate = "- $escaped_lang + $escaped_framework ($escaped_branch)"
    } elseif ($escaped_lang) {
        $techStackForTemplate = "- $escaped_lang ($escaped_branch)"
    } elseif ($escaped_framework) {
        $techStackForTemplate = "- $escaped_framework ($escaped_branch)"
    }

    $content = $content -replace '\[EXTRACTED FROM ALL PLAN.MD FILES\]',$techStackForTemplate
    # 對於專案結構，我們手動嵌入（保留換行符號）
    $escapedStructure = [Regex]::Escape($projectStructure)
    $content = $content -replace '\[ACTUAL STRUCTURE FROM PLANS\]',$escapedStructure
    # 在所有替換之後替換轉義的換行符號佔位符
    $content = $content -replace '\[ONLY COMMANDS FOR ACTIVE TECHNOLOGIES\]',$commands
    $content = $content -replace '\[LANGUAGE-SPECIFIC, ONLY FOR LANGUAGES IN USE\]',$languageConventions

    # 安全地建構最近變更字串
    $recentChangesForTemplate = ""
    if ($escaped_lang -and $escaped_framework) {
        $recentChangesForTemplate = "- ${escaped_branch}：新增了 ${escaped_lang} + ${escaped_framework}"
    } elseif ($escaped_lang) {
        $recentChangesForTemplate = "- ${escaped_branch}：新增了 ${escaped_lang}"
    } elseif ($escaped_framework) {
        $recentChangesForTemplate = "- ${escaped_branch}：新增了 ${escaped_framework}"
    }

    $content = $content -replace '\[LAST 3 FEATURES AND WHAT THEY ADDED\]',$recentChangesForTemplate
    # 將 Escape 引入的字面 \n 序列轉換為實際的換行符號
    $content = $content -replace '\\n',[Environment]::NewLine

    $parent = Split-Path -Parent $TargetFile
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent | Out-Null }
    Set-Content -LiteralPath $TargetFile -Value $content -NoNewline -Encoding utf8
    Remove-Item $temp -Force
    return $true
}

function Update-ExistingAgentFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TargetFile,
        [Parameter(Mandatory=$true)]
        [datetime]$Date
    )
    if (-not (Test-Path $TargetFile)) { return (New-AgentFile -TargetFile $TargetFile -ProjectName (Split-Path $REPO_ROOT -Leaf) -Date $Date) }

    $techStack = Format-TechnologyStack -Lang $NEW_LANG -Framework $NEW_FRAMEWORK
    $newTechEntries = @()
    if ($techStack) {
        $escapedTechStack = [Regex]::Escape($techStack)
        if (-not (Select-String -Pattern $escapedTechStack -Path $TargetFile -Quiet)) {
            $newTechEntries += "- $techStack ($CURRENT_BRANCH)"
        }
    }
    if ($NEW_DB -and $NEW_DB -notin @('N/A','NEEDS CLARIFICATION')) {
        $escapedDB = [Regex]::Escape($NEW_DB)
        if (-not (Select-String -Pattern $escapedDB -Path $TargetFile -Quiet)) {
            $newTechEntries += "- $NEW_DB ($CURRENT_BRANCH)"
        }
    }
    $newChangeEntry = ''
    if ($techStack) { $newChangeEntry = "- ${CURRENT_BRANCH}：新增了 ${techStack}" }
    elseif ($NEW_DB -and $NEW_DB -notin @('N/A','NEEDS CLARIFICATION')) { $newChangeEntry = "- ${CURRENT_BRANCH}：新增了 ${NEW_DB}" }

    $lines = Get-Content -LiteralPath $TargetFile -Encoding utf8
    $output = New-Object System.Collections.Generic.List[string]
    $inTech = $false; $inChanges = $false; $techAdded = $false; $changeAdded = $false; $existingChanges = 0

    for ($i=0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -eq '## Active Technologies') {
            $output.Add($line)
            $inTech = $true
            continue
        }
        if ($inTech -and $line -match '^##\s') {
            if (-not $techAdded -and $newTechEntries.Count -gt 0) { $newTechEntries | ForEach-Object { $output.Add($_) }; $techAdded = $true }
            $output.Add($line); $inTech = $false; continue
        }
        if ($inTech -and [string]::IsNullOrWhiteSpace($line)) {
            if (-not $techAdded -and $newTechEntries.Count -gt 0) { $newTechEntries | ForEach-Object { $output.Add($_) }; $techAdded = $true }
            $output.Add($line); continue
        }
        if ($line -eq '## Recent Changes') {
            $output.Add($line)
            if ($newChangeEntry) { $output.Add($newChangeEntry); $changeAdded = $true }
            $inChanges = $true
            continue
        }
        if ($inChanges -and $line -match '^##\s') { $output.Add($line); $inChanges = $false; continue }
        if ($inChanges -and $line -match '^- ') {
            if ($existingChanges -lt 2) { $output.Add($line); $existingChanges++ }
            continue
        }
        if ($line -match '\*\*Last updated\*\*:.\d{4}-\d{2}-\d{2}') {
            $output.Add(($line -replace '\d{4}-\d{2}-\d{2}',$Date.ToString('yyyy-MM-dd')))
            continue
        }
        $output.Add($line)
    }

    # 迴圈後檢查：如果我們仍在 Active Technologies 章節且尚未新增內容
    if ($inTech -and -not $techAdded -and $newTechEntries.Count -gt 0) {
        $newTechEntries | ForEach-Object { $output.Add($_) }
    }

    Set-Content -LiteralPath $TargetFile -Value ($output -join [Environment]::NewLine) -Encoding utf8
    return $true
}

function Update-AgentFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TargetFile,
        [Parameter(Mandatory=$true)]
        [string]$AgentName
    )
    if (-not $TargetFile -or -not $AgentName) { Write-Err 'Update-AgentFile 需要 TargetFile 和 AgentName'; return $false }
    Write-Info "正在更新 $AgentName 上下文檔案：$TargetFile"
    $projectName = Split-Path $REPO_ROOT -Leaf
    $date = Get-Date

    $dir = Split-Path -Parent $TargetFile
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }

    if (-not (Test-Path $TargetFile)) {
        if (New-AgentFile -TargetFile $TargetFile -ProjectName $projectName -Date $date) { Write-Success "已建立新的 $AgentName 上下文檔案" } else { Write-Err '建立新的代理程式檔案失敗'; return $false }
    } else {
        try {
            if (Update-ExistingAgentFile -TargetFile $TargetFile -Date $date) { Write-Success "已更新現有的 $AgentName 上下文檔案" } else { Write-Err '更新代理程式檔案失敗'; return $false }
        } catch {
            Write-Err "無法存取或更新現有檔案：$TargetFile。$_"
            return $false
        }
    }
    return $true
}

function Update-SpecificAgent {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Type
    )
    switch ($Type) {
        'claude'   { Update-AgentFile -TargetFile $CLAUDE_FILE   -AgentName 'Claude Code' }
        'gemini'   { Update-AgentFile -TargetFile $GEMINI_FILE   -AgentName 'Gemini CLI' }
        'copilot'  { Update-AgentFile -TargetFile $COPILOT_FILE  -AgentName 'GitHub Copilot' }
        'cursor-agent' { Update-AgentFile -TargetFile $CURSOR_FILE   -AgentName 'Cursor IDE' }
        'qwen'     { Update-AgentFile -TargetFile $QWEN_FILE     -AgentName 'Qwen Code' }
        'opencode' { Update-AgentFile -TargetFile $AGENTS_FILE   -AgentName 'opencode' }
        'codex'    { Update-AgentFile -TargetFile $AGENTS_FILE   -AgentName 'Codex CLI' }
        'windsurf' { Update-AgentFile -TargetFile $WINDSURF_FILE -AgentName 'Windsurf' }
        'kilocode' { Update-AgentFile -TargetFile $KILOCODE_FILE -AgentName 'Kilo Code' }
        'auggie'   { Update-AgentFile -TargetFile $AUGGIE_FILE   -AgentName 'Auggie CLI' }
        'roo'      { Update-AgentFile -TargetFile $ROO_FILE      -AgentName 'Roo Code' }
        'codebuddy' { Update-AgentFile -TargetFile $CODEBUDDY_FILE -AgentName 'CodeBuddy CLI' }
        'qoder'    { Update-AgentFile -TargetFile $QODER_FILE    -AgentName 'Qoder CLI' }
        'amp'      { Update-AgentFile -TargetFile $AMP_FILE      -AgentName 'Amp' }
        'shai'     { Update-AgentFile -TargetFile $SHAI_FILE     -AgentName 'SHAI' }
        'q'        { Update-AgentFile -TargetFile $Q_FILE        -AgentName 'Amazon Q Developer CLI' }
        'bob'      { Update-AgentFile -TargetFile $BOB_FILE      -AgentName 'IBM Bob' }
        default { Write-Err "未知的代理程式類型 '$Type'"; Write-Err '預期：claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|roo|codebuddy|amp|shai|q|bob|qoder'; return $false }
    }
}

function Update-AllExistingAgents {
    $found = $false
    $ok = $true
    if (Test-Path $CLAUDE_FILE)   { if (-not (Update-AgentFile -TargetFile $CLAUDE_FILE   -AgentName 'Claude Code')) { $ok = $false }; $found = $true }
    if (Test-Path $GEMINI_FILE)   { if (-not (Update-AgentFile -TargetFile $GEMINI_FILE   -AgentName 'Gemini CLI')) { $ok = $false }; $found = $true }
    if (Test-Path $COPILOT_FILE)  { if (-not (Update-AgentFile -TargetFile $COPILOT_FILE  -AgentName 'GitHub Copilot')) { $ok = $false }; $found = $true }
    if (Test-Path $CURSOR_FILE)   { if (-not (Update-AgentFile -TargetFile $CURSOR_FILE   -AgentName 'Cursor IDE')) { $ok = $false }; $found = $true }
    if (Test-Path $QWEN_FILE)     { if (-not (Update-AgentFile -TargetFile $QWEN_FILE     -AgentName 'Qwen Code')) { $ok = $false }; $found = $true }
    if (Test-Path $AGENTS_FILE)   { if (-not (Update-AgentFile -TargetFile $AGENTS_FILE   -AgentName 'Codex/opencode')) { $ok = $false }; $found = $true }
    if (Test-Path $WINDSURF_FILE) { if (-not (Update-AgentFile -TargetFile $WINDSURF_FILE -AgentName 'Windsurf')) { $ok = $false }; $found = $true }
    if (Test-Path $KILOCODE_FILE) { if (-not (Update-AgentFile -TargetFile $KILOCODE_FILE -AgentName 'Kilo Code')) { $ok = $false }; $found = $true }
    if (Test-Path $AUGGIE_FILE)   { if (-not (Update-AgentFile -TargetFile $AUGGIE_FILE   -AgentName 'Auggie CLI')) { $ok = $false }; $found = $true }
    if (Test-Path $ROO_FILE)      { if (-not (Update-AgentFile -TargetFile $ROO_FILE      -AgentName 'Roo Code')) { $ok = $false }; $found = $true }
    if (Test-Path $CODEBUDDY_FILE) { if (-not (Update-AgentFile -TargetFile $CODEBUDDY_FILE -AgentName 'CodeBuddy CLI')) { $ok = $false }; $found = $true }
    if (Test-Path $QODER_FILE)    { if (-not (Update-AgentFile -TargetFile $QODER_FILE    -AgentName 'Qoder CLI')) { $ok = $false }; $found = $true }
    if (Test-Path $SHAI_FILE)     { if (-not (Update-AgentFile -TargetFile $SHAI_FILE     -AgentName 'SHAI')) { $ok = $false }; $found = $true }
    if (Test-Path $Q_FILE)        { if (-not (Update-AgentFile -TargetFile $Q_FILE        -AgentName 'Amazon Q Developer CLI')) { $ok = $false }; $found = $true }
    if (Test-Path $BOB_FILE)      { if (-not (Update-AgentFile -TargetFile $BOB_FILE      -AgentName 'IBM Bob')) { $ok = $false }; $found = $true }
    if (-not $found) {
        Write-Info '找不到現有的代理程式檔案，正在建立預設的 Claude 檔案...'
        if (-not (Update-AgentFile -TargetFile $CLAUDE_FILE -AgentName 'Claude Code')) { $ok = $false }
    }
    return $ok
}

function Print-Summary {
    Write-Host ''
    Write-Info '變更摘要：'
    if ($NEW_LANG) { Write-Host "  - 已新增語言：$NEW_LANG" }
    if ($NEW_FRAMEWORK) { Write-Host "  - 已新增框架：$NEW_FRAMEWORK" }
    if ($NEW_DB -and $NEW_DB -ne 'N/A') { Write-Host "  - 已新增資料庫：$NEW_DB" }
    Write-Host ''
    Write-Info '用法：./update-agent-context.ps1 [-AgentType claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|roo|codebuddy|amp|shai|q|bob|qoder]'
}

function Main {
    Validate-Environment
    Write-Info "=== 正在更新特徵 $CURRENT_BRANCH 的代理程式上下文檔案 ==="
    if (-not (Parse-PlanData -PlanFile $NEW_PLAN)) { Write-Err '解析計畫資料失敗'; exit 1 }
    $success = $true
    if ($AgentType) {
        Write-Info "正在更新特定代理程式：$AgentType"
        if (-not (Update-SpecificAgent -Type $AgentType)) { $success = $false }
    }
    else {
        Write-Info '未指定代理程式，正在更新所有現有的代理程式檔案...'
        if (-not (Update-AllExistingAgents)) { $success = $false }
    }
    Print-Summary
    if ($success) { Write-Success '代理程式上下文更新成功完成'; exit 0 } else { Write-Err '代理程式上下文更新完成，但有錯誤'; exit 1 }
}

Main
