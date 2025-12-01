# AGENTS.md

## 關於 Spec Kit 與 Specify

**GitHub Spec Kit** 是一個用於實施規範驅動開發 (SDD) 的綜合工具包，該方法強調在實施之前建立清晰的規範。該工具包包含範本、指令碼和工作流程，引導開發團隊採用結構化的方法來建構軟體。

**Specify CLI** 是命令列介面，它使用 Spec Kit 框架引導專案。它設定必要的目錄結構、範本和 AI 代理整合，以支援規範驅動開發工作流程。

該工具包支援多個 AI 程式碼助理，允許團隊使用他們偏好的工具，同時保持一致的專案結構和開發實踐。

---

## 一般實踐

- Specify CLI 的 `__init__.py` 的任何變更都需要在 `pyproject.toml` 中進行版本修訂，並將條目新增到 `CHANGELOG.md`。

## 新增代理支援

本節說明如何為 Specify CLI 新增對新 AI 代理/助理的支援。在將新的 AI 工具整合到規範驅動開發工作流程時，請將本指南作為參考。

### 概述

Specify 透過在初始化專案時產生代理特定的命令檔案和目錄結構來支援多個 AI 代理。每個代理都有其自己的慣例：

- **命令檔案格式** (Markdown、TOML 等)
- **目錄結構** (`.claude/commands/`、`.windsurf/workflows/` 等)
- **命令呼叫模式** (斜線命令、CLI 工具等)
- **引數傳遞慣例** (`$ARGUMENTS`、`{{args}}` 等)

### 目前支援的代理

| 代理 | 目錄 | 格式 | CLI 工具 | 描述 |
|---|---|---|---|---|
| **Claude Code** | `.claude/commands/` | Markdown | `claude` | Anthropic 的 Claude Code CLI |
| **Gemini CLI** | `.gemini/commands/` | TOML | `gemini` | Google 的 Gemini CLI |
| **GitHub Copilot** | `.github/agents/` | Markdown | 不適用 (基於 IDE) | VS Code 中的 GitHub Copilot |
| **Cursor** | `.cursor/commands/` | Markdown | `cursor-agent` | Cursor CLI |
| **Qwen Code** | `.qwen/commands/` | TOML | `qwen` | 阿里巴巴的 Qwen Code CLI |
| **opencode** | `.opencode/command/` | Markdown | `opencode` | opencode CLI |
| **Codex CLI** | `.codex/commands/` | Markdown | `codex` | Codex CLI |
| **Windsurf** | `.windsurf/workflows/` | Markdown | 不適用 (基於 IDE) | Windsurf IDE 工作流程 |
| **Kilo Code** | `.kilocode/rules/` | Markdown | 不適用 (基於 IDE) | Kilo Code IDE |
| **Auggie CLI** | `.augment/rules/` | Markdown | `auggie` | Auggie CLI |
| **Roo Code** | `.roo/rules/` | Markdown | 不適用 (基於 IDE) | Roo Code IDE |
| **CodeBuddy CLI** | `.codebuddy/commands/` | Markdown | `codebuddy` | CodeBuddy CLI |
| **Amazon Q Developer CLI** | `.amazonq/prompts/` | Markdown | `q` | Amazon Q Developer CLI |
| **Amp** | `.agents/commands/` | Markdown | `amp` | Amp CLI |
| **SHAI** | `.shai/commands/` | Markdown | `shai` | SHAI CLI |
| **IBM Bob** | `.bob/commands/` | Markdown | N/A (IDE-based) | IBM Bob IDE |

### 逐步整合指南

請按照以下步驟新增代理 (以假設的新代理為範例)：

#### 1. 新增至 AGENT_CONFIG

**重要**：使用實際的 CLI 工具名稱作為鍵，而不是縮寫版本。

將新代理新增至 `src/specify_cli/__init__.py` 中的 `AGENT_CONFIG` 字典。這是所有代理 Metadata 的**單一事實來源**：

```python
AGENT_CONFIG = {
    # ... 現有代理 ...
    "new-agent-cli": {  # 使用實際的 CLI 工具名稱 (使用者在終端機中輸入的名稱)
        "name": "新代理顯示名稱",
        "folder": ".newagent/",  # 代理檔案的目錄
        "install_url": "https://example.com/install",  # 安裝文件的 URL (如果基於 IDE 則為 None)
        "requires_cli": True,  # 如果需要 CLI 工具則為 True，基於 IDE 的代理則為 False
    },
}
```

**關鍵設計原則**：字典鍵應與使用者安裝的實際可執行檔名稱相符。例如：

- ✅ 使用 `"cursor-agent"`，因為 CLI 工具的名稱就是 `cursor-agent`
- ❌ 如果工具是 `cursor-agent`，請勿使用 `"cursor"` 作為捷徑

這消除了整個程式碼庫中特殊情況對應的需要。

**欄位說明**：

- `name`：顯示給使用者的易讀顯示名稱
- `folder`：儲存代理特定檔案的目錄 (相對於專案根目錄)
- `install_url`：安裝文件 URL (基於 IDE 的代理設定為 `None`)
- `requires_cli`：代理在初始化期間是否需要 CLI 工具檢查

#### 2. 更新 CLI 說明文字

更新 `init()` 命令中的 `--ai` 參數說明文字，以包含新代理：

```python
ai_assistant: str = typer.Option(None, "--ai", help="要使用的 AI 助理：claude, gemini, copilot, cursor-agent, qwen, opencode, codex, windsurf, kilocode, auggie, codebuddy, new-agent-cli, 或 q"),
```

同時更新任何列出可用代理的函式文件字串、範例和錯誤訊息。

#### 3. 更新 README 文件

更新 `README.md` 中的**支援的 AI 代理**部分，以包含新代理：

- 將新代理新增至表格，並提供適當的支援級別 (完整/部分)
- 包含代理的官方網站連結
- 新增有關代理實施的任何相關備註
- 確保表格格式保持對齊和一致

#### 4. 更新發布套件指令碼

修改 `.github/workflows/scripts/create-release-packages.sh`：

##### 新增至 ALL_AGENTS 陣列

```bash
ALL_AGENTS=(claude gemini copilot cursor-agent qwen opencode windsurf q)
```

##### 新增目錄結構的 case 語句

```bash
case $agent in
  # ... 現有案例 ...
  windsurf) 
    mkdir -p "$base_dir/.windsurf/workflows"
    generate_commands windsurf md "\$ARGUMENTS" "$base_dir/.windsurf/workflows" "$script" ;;
esac
```

#### 4. 更新 GitHub 發布指令碼

修改 `.github/workflows/scripts/create-github-release.sh` 以包含新代理的套件：

```bash
gh release create "$VERSION" \
  # ... 現有套件 ...
  .genreleases/spec-kit-template-windsurf-sh-"$VERSION".zip \
  .genreleases/spec-kit-template-windsurf-ps-"$VERSION".zip \
  # 在此新增新代理套件
```

#### 5. 更新代理上下文指令碼

##### Bash 指令碼 (`scripts/bash/update-agent-context.sh`)

新增檔案變數：

```bash
WINDSURF_FILE="$REPO_ROOT/.windsurf/rules/specify-rules.md"
```

新增至 case 語句：

```bash
case "$AGENT_TYPE" in
  # ... 現有案例 ...
  windsurf) update_agent_file "$WINDSURF_FILE" "Windsurf" ;;
  "" ) 
    # ... 現有檢查 ...
    [ -f "$WINDSURF_FILE" ] && update_agent_file "$WINDSURF_FILE" "Windsurf";
    # 更新預設建立條件
    ;;
esac
```

##### PowerShell 指令碼 (`scripts/powershell/update-agent-context.ps1`)

新增檔案變數：

```powershell
$windsurfFile = Join-Path $repoRoot '.windsurf/rules/specify-rules.md'
```

新增至 switch 語句：

```powershell
switch ($AgentType) {
    # ... 現有案例 ...
    'windsurf' { Update-AgentFile $windsurfFile 'Windsurf' }
    '' {
        foreach ($pair in @(
            # ... 現有配對 ...
            @{file=$windsurfFile; name='Windsurf'}
        )) {
            if (Test-Path $pair.file) { Update-AgentFile $pair.file $pair.name }
        }
        # 更新預設建立條件
    }
}
```

#### 6. 更新 CLI 工具檢查 (可選)

對於需要 CLI 工具的代理，請在 `check()` 命令和代理驗證中新增檢查：

```python
# 在 check() 命令中
tracker.add("windsurf", "Windsurf IDE (可選)")
windsurf_ok = check_tool_for_tracker("windsurf", "https://windsurf.com/", tracker)

# 在 init 驗證中 (僅當需要 CLI 工具時)
elif selected_ai == "windsurf":
    if not check_tool("windsurf", "從以下位置安裝：https://windsurf.com/"):
        console.print("[red]錯誤：[/red] Windsurf 專案需要 Windsurf CLI")
        agent_tool_missing = True
```

**注意**：CLI 工具檢查現在根據 `AGENT_CONFIG` 中的 `requires_cli` 欄位自動處理。`check()` 或 `init()` 命令中不需要額外的程式碼變更 - 它們會自動循環遍歷 `AGENT_CONFIG` 並根據需要檢查工具。

## 重要設計決策

### 使用實際的 CLI 工具名稱作為鍵

**關鍵**：將新代理新增至 AGENT_CONFIG 時，始終使用**實際可執行檔名稱**作為字典鍵，而不是縮寫或方便的版本。

**為什麼這很重要**：

- `check_tool()` 函式使用 `shutil.which(tool)` 在系統 PATH 中尋找可執行檔
- 如果鍵與實際的 CLI 工具名稱不符，您將需要在整個程式碼庫中進行特殊情況對應
- 這會產生不必要的複雜性和維護負擔

**範例 - Cursor 的教訓**：

❌ **錯誤方法** (需要特殊情況對應)：

```python
AGENT_CONFIG = {
    "cursor": {  # 與實際工具不符的簡寫
        "name": "Cursor",
        # ...
    }
}

# 然後您需要在各處處理特殊情況：
cli_tool = agent_key
if agent_key == "cursor":
    cli_tool = "cursor-agent"  # 對應到真實的工具名稱
```

✅ **正確方法** (無需對應)：

```python
AGENT_CONFIG = {
    "cursor-agent": {  # 與實際可執行檔名稱相符
        "name": "Cursor",
        # ...
    }
}

# 無需特殊情況 - 只需直接使用 agent_key！
```

**這種方法的好處**：

- 消除了散佈在整個程式碼庫中的特殊情況邏輯
- 使程式碼更易於維護和理解
- 減少新增代理時出現錯誤的機會
- 工具檢查「正常運作」而無需額外對應

#### 7. 更新 Devcontainer 檔案 (可選)

對於具有 VS Code 擴充功能或需要 CLI 安裝的代理，請更新 devcontainer 配置檔案：

##### 基於 VS Code 擴充功能的代理

對於可作為 VS Code 擴充功能使用的代理，請將它們新增至 `.devcontainer/devcontainer.json`：

```json
{
  "customizations": {
    "vscode": {
      "extensions": [
        // ... 現有擴充功能 ...
        // [新代理名稱]
        "[新代理擴充功能 ID]"
      ]
    }
  }
}
```

##### 基於 CLI 的代理

對於需要 CLI 工具的代理，請將安裝命令新增至 `.devcontainer/post-create.sh`：

```bash
#!/bin/bash

# 現有安裝...

echo -e "\n🤖 安裝 [新代理名稱] CLI..."
# run_command "npm install -g [agent-cli-package]@latest" # Node.js CLI 的範例
# 或其他安裝說明 (必須是非互動式且與 Linux Debian "Trixie" 或更高版本相容)...
echo "✅ 完成"

```

**快速提示**：

- **基於擴充功能的代理**：新增至 `devcontainer.json` 中的 `extensions` 陣列
- **基於 CLI 的代理**：將安裝指令碼新增至 `post-create.sh`
- **混合代理**：可能需要擴充功能和 CLI 安裝
- **徹底測試**：確保安裝在 devcontainer 環境中正常運作

## 代理類別

### 基於 CLI 的代理

需要安裝命令列工具：

- **Claude Code**：`claude` CLI
- **Gemini CLI**：`gemini` CLI
- **Cursor**：`cursor-agent` CLI
- **Qwen Code**：`qwen` CLI
- **opencode**：`opencode` CLI
- **Amazon Q Developer CLI**：`q` CLI
- **CodeBuddy CLI**：`codebuddy` CLI
- **Amp**：`amp` CLI
- **SHAI**：`shai` CLI

### 基於 IDE 的代理

在整合開發環境中工作：

- **GitHub Copilot**：內建於 VS Code/相容編輯器
- **Windsurf**：內建於 Windsurf IDE
- **IBM Bob**：內建於 IBM Bob IDE

## 命令檔案格式

### Markdown 格式

由以下代理使用：Claude、Cursor、opencode、Windsurf、Amazon Q Developer、Amp、SHAI, IBM Bob

**標準格式**：

```markdown
---
description: "命令描述"
---

包含 {SCRIPT} 和 $ARGUMENTS 佔位符的命令內容。
```

**GitHub Copilot Chat 模式格式**：

```markdown
---
description: "命令描述"
mode: speckit.command-name
---

包含 {SCRIPT} 和 $ARGUMENTS 佔位符的命令內容。
```

### TOML 格式

由以下代理使用：Gemini、Qwen

```toml
description = "命令描述"

prompt = """
包含 {SCRIPT} 和 {{args}} 佔位符的命令內容。
"""
```

## 目錄慣例

- **CLI 代理**：通常是 `.<agent-name>/commands/`
- **IDE 代理**：遵循 IDE 特定模式：
  - Copilot：`.github/agents/`
  - Cursor：`.cursor/commands/`
  - Windsurf：`.windsurf/workflows/`

## 引數模式

不同的代理使用不同的引數佔位符：

- **基於 Markdown/提示**：`$ARGUMENTS`
- **基於 TOML**：`{{args}}`
- **指令碼佔位符**：`{SCRIPT}` (替換為實際指令碼路徑)
- **代理佔位符**：`__AGENT__` (替換為代理名稱)

## 測試新代理整合

1. **建構測試**：在本機執行套件建立指令碼
2. **CLI 測試**：測試 `specify init --ai <agent>` 命令
3. **檔案產生**：驗證正確的目錄結構和檔案
4. **命令驗證**：確保產生的命令與代理一起正常運作
5. **上下文更新**：測試代理上下文更新指令碼

## 常見陷阱

1. **使用縮寫鍵而不是實際的 CLI 工具名稱**：始終使用實際可執行檔名稱作為 AGENT_CONFIG 鍵 (例如，`"cursor-agent"` 而不是 `"cursor"`)。這可以避免在整個程式碼庫中進行特殊情況對應。
2. **忘記更新指令碼**：新增代理時必須更新 bash 和 PowerShell 指令碼。
3. **不正確的 `requires_cli` 值**：僅對於實際需要檢查 CLI 工具的代理設定為 `True`；對於基於 IDE 的代理設定為 `False`。
4. **錯誤的引數格式**：為每種代理類型使用正確的佔位符格式 (`$ARGUMENTS` 用於 Markdown，`{{args}}` 用於 TOML)。
5. **目錄命名**：嚴格遵循代理特定的慣例 (檢查現有代理的模式)。
6. **說明文字不一致**：一致地更新所有面向使用者的文字 (說明字串、文件字串、README、錯誤訊息)。

## 未來考量

新增代理時：

- 考量代理的原生命令/工作流程模式
- 確保與規範驅動開發流程的相容性
- 記錄任何特殊要求或限制
- 使用所學到的經驗更新本指南
- 在新增至 AGENT_CONFIG 之前驗證實際的 CLI 工具名稱

---

*每當新增代理時，都應更新此文件以保持準確性和完整性。*
