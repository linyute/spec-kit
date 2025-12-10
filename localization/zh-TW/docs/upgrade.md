# 升級指南

> 您已安裝 Spec Kit，並希望升級到最新版本以獲取新功能、錯誤修復或更新的斜線指令。本指南涵蓋了 CLI 工具的升級和專案檔案的更新。

---

## 快速參考

| 升級項目 | 指令 | 使用時機 |
|----------------|---------|-------------|
| **僅限 CLI 工具** | `uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git` | 獲取最新的 CLI 功能，而不觸及專案檔案 |
| **專案檔案** | `specify init --here --force --ai <your-agent>` | 更新專案中的斜線指令、範本和指令碼 |
| **兩者皆是** | 執行 CLI 升級，然後專案更新 | 建議用於主要版本更新 |

---

## 第 1 部分：升級 CLI 工具

CLI 工具 (`specify`) 與您的專案檔案是分開的。升級它以獲取最新的功能和錯誤修復。

### 如果您使用 `uv tool install` 安裝

```bash
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git
```

### 如果您使用一次性 `uvx` 指令

無需升級 — `uvx` 總是獲取最新版本。只需像往常一樣執行您的指令：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init --here --ai copilot
```

### 驗證升級

```bash
specify check
```

這會顯示已安裝的工具並確認 CLI 正在運作。

---

## 第 2 部分：更新專案檔案

當 Spec Kit 發布新功能（例如新的斜線指令或更新的範本）時，您需要重新整理專案的 Spec Kit 檔案。

### 哪些會被更新？

執行 `specify init --here --force` 將會更新：

- ✅ **斜線指令檔案** (`.claude/commands/`、`.github/prompts/` 等)
- ✅ **指令碼檔案** (`.specify/scripts/`)
- ✅ **範本檔案** (`.specify/templates/`)
- ✅ **共享記憶體檔案** (`.specify/memory/`) - **⚠️ 請參閱下面的警告**

### 哪些會保持安全？

這些檔案在升級時**永遠不會被觸及** — 範本套件甚至不包含它們：

- ✅ **您的規格** (`specs/001-my-feature/spec.md` 等) - **確認安全**
- ✅ **您的實作計畫** (`specs/001-my-feature/plan.md`、`tasks.md` 等) - **確認安全**
- ✅ **您的原始程式碼** - **確認安全**
- ✅ **您的 Git 歷史記錄** - **確認安全**

`specs/` 目錄完全從範本套件中排除，並且在升級期間永遠不會被修改。

### 更新指令

在您的專案目錄中執行此指令：

```bash
specify init --here --force --ai <your-agent>
```

將 `<your-agent>` 替換為您的 AI 助理。請參閱此 [支援的 AI 代理程式](../README.md#-supported-ai-agents) 清單

**範例：**

```bash
specify init --here --force --ai copilot
```

### 了解 `--force` 旗標

如果沒有 `--force`，CLI 會警告您並要求確認：

```text
Warning: Current directory is not empty (25 items)
Template files will be merged with existing content and may overwrite existing files
Proceed? [y/N]
```

使用 `--force`，它會跳過確認並立即執行。

**重要：您的 `specs/` 目錄始終是安全的。** `--force` 旗標僅影響範本檔案（指令、指令碼、範本、記憶體）。您的功能規格、計畫和 `specs/` 中的任務永遠不會包含在升級套件中，也無法被覆寫。

---

## ⚠️ 重要警告

### 1. Constitution 檔案將被覆寫

**已知問題：** `specify init --here --force` 目前會用預設範本覆寫 `.specify/memory/constitution.md`，從而清除您所做的任何自訂。

**解決方法：**

```bash
# 1. 在升級前備份您的 constitution
cp .specify/memory/constitution.md .specify/memory/constitution-backup.md

# 2. 執行升級
specify init --here --force --ai copilot

# 3. 恢復您自訂的 constitution
mv .specify/memory/constitution-backup.md .specify/memory/constitution.md
```

或者使用 Git 恢復它：

```bash
# 升級後，從 Git 歷史記錄中恢復
git restore .specify/memory/constitution.md
```

### 2. 自訂範本修改

如果您自訂了 `.specify/templates/` 中的任何範本，升級將會覆寫它們。請先備份它們：

```bash
# 備份自訂範本
cp -r .specify/templates .specify/templates-backup

# 升級後，手動將您的變更合併回去
```

### 3. 重複的斜線指令 (基於 IDE 的代理程式)

某些基於 IDE 的代理程式 (例如 Kilo Code、Windsurf) 在升級後可能會顯示**重複的斜線指令** — 新舊版本都會出現。

**解決方案：** 手動從代理程式的資料夾中刪除舊的指令檔案。

**Kilo Code 範例：**

```bash
# 導航到代理程式的指令資料夾
cd .kilocode/rules/

# 列出檔案並識別重複項
ls -la

# 刪除舊版本 (範例檔案名稱 — 您的可能不同)
rm speckit.specify-old.md
rm speckit.plan-v1.md
```

重新啟動您的 IDE 以重新整理指令清單。

---

## 常見情境

### 情境 1：「我只想要新的斜線指令」

```bash
# 升級 CLI (如果使用持久安裝)
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git

# 更新專案檔案以獲取新指令
specify init --here --force --ai copilot

# 如果已自訂，請恢復您的 constitution
git restore .specify/memory/constitution.md
```

### 情境 2：「我自訂了範本和 constitution」

```bash
# 1. 備份自訂項目
cp .specify/memory/constitution.md /tmp/constitution-backup.md
cp -r .specify/templates /tmp/templates-backup

# 2. 升級 CLI
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git

# 3. 更新專案
specify init --here --force --ai copilot

# 4. 恢復自訂項目
mv /tmp/constitution-backup.md .specify/memory/constitution.md
# 如果需要，手動合併範本變更
```

### 情境 3：「我在 IDE 中看到重複的斜線指令」

這發生在基於 IDE 的代理程式 (Kilo Code、Windsurf、Roo Code 等)。

```bash
# 找到代理程式資料夾 (範例：.kilocode/rules/)
cd .kilocode/rules/

# 列出所有檔案
ls -la

# 刪除舊的指令檔案
rm speckit.old-command-name.md

# 重新啟動您的 IDE
```

### 情境 4：「我正在沒有 Git 的專案上工作」

如果您使用 `--no-git` 初始化專案，您仍然可以升級：

```bash
# 手動備份您自訂的檔案
cp .specify/memory/constitution.md /tmp/constitution-backup.md

# 執行升級
specify init --here --force --ai copilot --no-git

# 恢復自訂項目
mv /tmp/constitution-backup.md .specify/memory/constitution.md
```

`--no-git` 旗標會跳過 Git 初始化，但不會影響檔案更新。

---

## 使用 `--no-git` 旗標

`--no-git` 旗標會告訴 Spec Kit **跳過 Git 儲存庫初始化**。這在以下情況很有用：

- 您以不同的方式管理版本控制 (Mercurial、SVN 等)
- 您的專案是具有現有 Git 設定的較大單一儲存庫的一部分
- 您正在實驗，暫時不需要版本控制

**初始設定期間：**

```bash
specify init my-project --ai copilot --no-git
```

**升級期間：**

```bash
specify init --here --force --ai copilot --no-git
```

### `--no-git` 不會做什麼

❌ 不會阻止檔案更新
❌ 不會跳過斜線指令安裝
❌ 不會影響範本合併

它**只會**跳過執行 `git init` 和建立初始提交。

### 沒有 Git 的工作

如果您使用 `--no-git`，您需要手動管理功能目錄：

在使用規劃指令之前，**設定 `SPECIFY_FEATURE` 環境變數**：

```bash
# Bash/Zsh
export SPECIFY_FEATURE="001-my-feature"

# PowerShell
$env:SPECIFY_FEATURE = "001-my-feature"
```

這會告訴 Spec Kit 在建立規格、計畫和任務時要使用哪個功能目錄。

**為什麼這很重要：** 沒有 Git，Spec Kit 無法偵測您目前的 branch 名稱來確定活動功能。環境變數會手動提供該上下文。

---

## 疑難排解

### 「升級後斜線指令沒有顯示」

**原因：** 代理程式沒有重新載入指令檔案。

**修復：**

1. **完全重新啟動您的 IDE/編輯器** (不只是重新載入視窗)
2. **對於基於 CLI 的代理程式**，驗證檔案是否存在：

   ```bash
   ls -la .claude/commands/      # Claude Code
   ls -la .gemini/commands/       # Gemini
   ls -la .cursor/commands/       # Cursor
   ```

3. **檢查代理程式特定的設定：**
   - Codex 需要 `CODEX_HOME` 環境變數
   - 某些代理程式需要重新啟動工作區或清除快取

### 「我遺失了我的 constitution 自訂項目」

**修復：** 從 Git 或備份中恢復：

```bash
# 如果您在升級前已提交
git restore .specify/memory/constitution.md

# 如果您手動備份
cp /tmp/constitution-backup.md .specify/memory/constitution.md
```

**預防：** 在升級前，務必提交或備份 `constitution.md`。

### 「警告：目前目錄不為空」

**完整警告訊息：**

```text
Warning: Current directory is not empty (25 items)
Template files will be merged with existing content and may overwrite existing files
Do you want to continue? [y/N]
```

**這表示：**

當您在已經有檔案的目錄中執行 `specify init --here` (或 `specify init .`) 時，會出現此警告。它告訴您：

1. **目錄中存在現有內容** — 在範例中，有 25 個檔案/資料夾
2. **檔案將被合併** — 新的範本檔案將與您現有的檔案一起新增
3. **某些檔案可能會被覆寫** — 如果您已經有 Spec Kit 檔案 (`.claude/`、`.specify/` 等)，它們將被新版本替換

**哪些會被覆寫：**

僅限 Spec Kit 基礎設施檔案：

- 代理程式指令檔案 (`.claude/commands/`、`.github/prompts/` 等)
- `.specify/scripts/` 中的指令碼
- `.specify/templates/` 中的範本
- `.specify/memory/` 中的記憶體檔案 (包括 constitution)

**哪些保持不變：**

- 您的 `specs/` 目錄 (規格、計畫、任務)
- 您的原始程式碼檔案
- 您的 `.git/` 目錄和 Git 歷史記錄
- 任何不屬於 Spec Kit 範本的其他檔案

**如何回應：**

- **輸入 `y` 並按下 Enter** — 繼續合併 (升級時建議)
- **輸入 `n` 並按下 Enter** — 取消操作
- **使用 `--force` 旗標** — 完全跳過此確認：

  ```bash
  specify init --here --here --force --ai copilot
  ```

**當您看到此警告時：**

- ✅ **預期** 在升級現有的 Spec Kit 專案時
- ✅ **預期** 在將 Spec Kit 新增到現有程式碼庫時
- ⚠️ **意外** 如果您認為您正在空目錄中建立新專案

**預防提示：** 在升級之前，如果您自訂了 `.specify/memory/constitution.md`，請提交或備份它。

### 「CLI 升級似乎不起作用」

驗證安裝：

```bash
# 檢查已安裝的工具
uv tool list

# 應該顯示 specify-cli

# 驗證路徑
which specify

# 應該指向 uv 工具安裝目錄
```

如果找不到，請重新安裝：

```bash
uv tool uninstall specify-cli
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

### 「我每次打開專案都需要執行 specify 嗎？」

**簡短回答：** 不，您每個專案只需執行 `specify init` 一次 (或在升級時)。

**解釋：**

`specify` CLI 工具用於：

- **初始設定：** `specify init` 在您的專案中啟動 Spec Kit
- **升級：** `specify init --here --force` 更新範本和指令
- **診斷：** `specify check` 驗證工具安裝

一旦您執行了 `specify init`，斜線指令 (例如 `/speckit.specify`、`/speckit.plan` 等) 就會**永久安裝**在您專案的代理程式資料夾中 (`.claude/`、`.github/prompts/` 等)。您的 AI 助理會直接讀取這些指令檔案 — 無需再次執行 `specify`。

**如果您的代理程式無法識別斜線指令：**

1. **驗證指令檔案是否存在：**

   ```bash
   # 對於 GitHub Copilot
   ls -la .github/prompts/

   # 對於 Claude
   ls -la .claude/commands/
   ```

2. **完全重新啟動您的 IDE/編輯器** (不只是重新載入視窗)

3. **檢查您是否在執行 `specify init` 的正確目錄中**

4. **對於某些代理程式**，您可能需要重新載入工作區或清除快取

**相關問題：** 如果 Copilot 無法打開本地檔案或意外使用 PowerShell 指令，這通常是 IDE 上下文問題，與 `specify` 無關。嘗試：

- 重新啟動 VS Code
- 檢查檔案權限
- 確保工作區資料夾已正確打開

---

## 版本相容性

Spec Kit 遵循主要版本的語義版本控制。CLI 和專案檔案設計為在同一主要版本中相容。

**最佳實踐：** 在主要版本變更期間，同時升級 CLI 和專案檔案，使其保持同步。

---

## 後續步驟

升級後：

- **測試新的斜線指令：** 執行 `/speckit.constitution` 或其他指令以驗證一切正常
- **查看發布說明：** 檢查 [GitHub Releases](https://github.com/github/spec-kit/releases) 以了解新功能和重大變更
- **更新工作流程：** 如果新增了指令，請更新您團隊的開發工作流程
- **檢查文件：** 訪問 [github.github.io/spec-kit](https://github.github.io/spec-kit/) 以獲取更新的指南
