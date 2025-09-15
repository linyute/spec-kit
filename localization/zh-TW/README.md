<div align="center">
    <img src="./media/logo_small.webp"/>
    <h1>🌱 Spec Kit</h1>
    <h3><em>更快地建立高品質軟體。</em></h3>
</div>

<p align="center">
    <strong>一項旨在透過規範驅動開發，讓組織專注於產品情境，而非編寫無差異程式碼的努力。</strong>
</p>

[![Release](https://github.com/github/spec-kit/actions/workflows/release.yml/badge.svg)](https://github.com/github/spec-kit/actions/workflows/release.yml)

---

## 目錄

- [目錄](#目錄)
- [🤔 什麼是規範驅動開發？](#-什麼是規範驅動開發)
- [⚡ 開始使用](#-開始使用)
  - [1. 安裝 Specify](#1-安裝-specify)
  - [2. 建立規範](#2-建立規範)
  - [3. 建立技術實作計畫](#3-建立技術實作計畫)
  - [4. 分解並實作](#4-分解並實作)
- [📽️ 影片概覽](#️-影片概覽)
- [🔧 Specify CLI 參考](#-specify-cli-參考)
  - [命令](#命令)
  - [`specify init` 引數與選項](#specify-init-引數與選項)
  - [範例](#範例)
- [📚 核心理念](#-核心理念)
- [🌟 開發階段](#-開發階段)
- [🎯 實驗目標](#-實驗目標)
  - [技術獨立性](#技術獨立性)
  - [企業限制](#企業限制)
  - [以使用者為中心的開發](#以使用者為中心的開發)
  - [創意與迭代流程](#創意與迭代流程)
- [🔧 先決條件](#-先決條件)
- [📖 了解更多](#-了解更多)
- [📋 詳細流程](#-詳細流程)
  - [**步驟 1：** 引導專案](#步驟-1-引導專案)
  - [**步驟 2：** 功能規範澄清](#步驟-2-功能規範澄清)
  - [**步驟 3：** 產生計畫](#步驟-3-產生計畫)
  - [**步驟 4：** 讓 Claude Code 驗證計畫](#步驟-4-讓-claude-code-驗證計畫)
  - [步驟 5：實作](#步驟-5實作)
- [🔍 疑難排解](#-疑難排解)
  - [Linux 上的 Git Credential Manager](#linux-上的-git-credential-manager)
- [👥 維護者](#-維護者)
- [💬 支援](#-支援)
- [🙏 致謝](#-致謝)
- [📄 授權](#-授權)

## 🤔 什麼是規範驅動開發？

規範驅動開發**顛覆了**傳統軟體開發。數十年來，程式碼一直是王道——規範只是我們在編碼「真正的工作」開始後建立並丟棄的鷹架。規範驅動開發改變了這一點：**規範變得可執行**，直接產生工作中的實作，而不僅僅是引導它們。

## ⚡ 開始使用

### 1. 安裝 Specify

根據您使用的程式碼代理程式初始化您的專案：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

### 2. 建立規範

使用 **`/specify`** 命令來描述您想要建立的內容。專注於**什麼**和**為什麼**，而不是技術堆疊。

```bash
/specify 建立一個應用程式，可以幫助我將照片整理到獨立的相簿中。相簿按日期分組，可以透過在主頁上拖放來重新組織。相簿永遠不會嵌套在其他相簿中。在每個相簿中，照片以平鋪介面預覽。
```

### 3. 建立技術實作計畫

使用 **`/plan`** 命令來提供您的技術堆疊和架構選擇。

```bash
/plan 該應用程式使用 Vite，並盡可能減少函式庫數量。盡可能使用原生的 HTML、CSS 和 JavaScript。圖片不會上傳到任何地方，Metadata 儲存在本地 SQLite 資料庫中。
```

### 4. 分解並實作

使用 **`/tasks`** 建立一個可執行的任務清單，然後要求您的代理程式實作該功能。

有關詳細的逐步說明，請參閱我們的[綜合指南](./spec-driven.md)。

## 📽️ 影片概覽

想看看 Spec Kit 的實際應用嗎？觀看我們的[影片概覽](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)！

[![Spec Kit video header](/media/spec-kit-video-header.jpg)](https://www.youtube.com/watch?v=a9eR1xsfvHg&pp=0gcJCckJAYcqIYzv)

## 🔧 Specify CLI 參考

`specify` 命令支援以下選項：

### 命令

| 命令        | 描述                                                           |
|-------------|----------------------------------------------------------------|
| `init`      | 從最新的範本初始化一個新的 Specify 專案                      |
| `check`     | 檢查已安裝的工具 (`git`, `claude`, `gemini`, `code`/`code-insiders`, `cursor-agent`) |

### `specify init` 引數與選項

| 引數/選項            | 類型     | 描述                                                                  |
|--------------------|----------|-----------------------------------------------------------------------|
| `<project-name>`   | 引數     | 新專案目錄的名稱 (如果使用 `--here` 則為可選)                        |
| `--ai`             | 選項     | 要使用的 AI 助理：`claude`、`gemini`、`copilot` 或 `cursor`             |
| `--script`         | 選項     | 要使用的指令碼變體：`sh` (bash/zsh) 或 `ps` (PowerShell)                 |
| `--ignore-agent-tools` | 旗標     | 跳過對 Claude Code 等 AI 代理程式工具的檢查                         |
| `--no-git`         | 旗標     | 跳過 git 儲存庫初始化                                                 |
| `--here`           | 旗標     | 在目前目錄中初始化專案，而不是建立一個新專案                          |
| `--skip-tls`       | 旗標     | 跳過 SSL/TLS 驗證 (不建議)                                            |
| `--debug`          | 旗標     | 啟用詳細的偵錯輸出以進行疑難排解                                      |

### 範例

```bash
# 基本專案初始化
specify init my-project

# 使用特定的 AI 助理初始化
specify init my-project --ai claude

# 使用 Cursor 支援初始化
specify init my-project --ai cursor

# 使用 PowerShell 指令碼初始化 (Windows/跨平台)
specify init my-project --ai copilot --script ps

# 在目前目錄中初始化
specify init --here --ai copilot

# 跳過 git 初始化
specify init my-project --ai gemini --no-git

# 啟用偵錯輸出以進行疑難排解
specify init my-project --ai claude --debug

# 檢查系統要求
specify check
```

## 📚 核心理念

規範驅動開發是一個結構化的流程，強調：

- **意圖驅動開發**，其中規範定義了「_什麼_」而不是「_如何_」
- 使用護欄和組織原則**建立豐富的規範**
- **多步驟細化**，而不是從提示一次性產生程式碼
- **高度依賴**進階 AI 模型功能來解釋規範

## 🌟 開發階段

| 階段 | 焦點 | 主要活動 |
|-------|-------|----------------|
| **從 0 到 1 開發** (「綠地」) | 從頭開始產生 | <ul><li>從高層次要求開始</li><li>產生規範</li><li>規劃實作步驟</li><li>建立可投入生產的應用程式</li></ul> |
| **創意探索** | 平行實作 | <ul><li>探索多樣化的解決方案</li><li>支援多種技術堆疊和架構</li><li>實驗 UX 模式</li></ul> |
| **迭代增強** (「棕地」) | 棕地現代化 | <ul><li>迭代新增功能</li><li>現代化舊有系統</li><li>調整流程</li></ul> |

## 🎯 實驗目標

我們的研究和實驗重點是：

### 技術獨立性

- 使用多樣化的技術堆疊建立應用程式
- 驗證規範驅動開發是一個不依賴特定技術、程式語言或框架的流程的假設

### 企業限制

- 展示關鍵任務應用程式開發
- 納入組織限制 (雲端供應商、技術堆疊、工程實踐)
- 支援企業設計系統和合規要求

### 以使用者為中心的開發

- 為不同的使用者群體和偏好建立應用程式
- 支援各種開發方法 (從 vibe-coding 到 AI 原生開發)

### 創意與迭代流程

- 驗證平行實作探索的概念
- 提供強大的迭代功能開發工作流程
- 擴展流程以處理升級和現代化任務

## 🔧 先決條件

- **Linux/macOS** (或 Windows 上的 WSL2)
- AI 編碼代理程式：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/)、[Gemini CLI](https://github.com/google-gemini/gemini-cli) 或 [Cursor](https://cursor.sh/)
- [uv](https://docs.astral.sh/uv/) 用於套件管理
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

## 📖 了解更多

- **[完整的規範驅動開發方法](./spec-driven.md)** - 深入了解完整流程
- **[詳細逐步解說](#-詳細流程)** - 逐步實作指南

---

## 📋 詳細流程

<details>
<summary>點擊展開詳細的逐步解說</summary>

您可以使用 Specify CLI 來引導您的專案，這將在您的環境中引入所需的構件。執行：

```bash
specify init <project_name>
```

或在目前目錄中初始化：

```bash
specify init --here
```

![Specify CLI 在終端機中引導新專案](./media/specify_cli.gif)

系統將提示您選擇正在使用的 AI 代理程式。您也可以直接在終端機中主動指定它：

```bash
specify init <project_name> --ai claude
specify init <project_name> --ai gemini
specify init <project_name> --ai copilot
# 或在目前目錄中：
specify init --here --ai claude
```

CLI 將檢查您是否已安裝 Claude Code 或 Gemini CLI。如果您沒有安裝，或者您希望在不檢查正確工具的情況下取得範本，請在命令中使用 `--ignore-agent-tools`：

```bash
specify init <project_name> --ai claude --ignore-agent-tools
```

### **步驟 1：** 引導專案

進入專案資料夾並執行您的 AI 代理程式。在我們的範例中，我們使用 `claude`。

![引導 Claude Code 環境](./media/bootstrap-claude-code.gif)

如果您看到 `/specify`、`/plan` 和 `/tasks` 命令可用，您就會知道配置正確。

第一步應該是建立新的專案鷹架。使用 `/specify` 命令，然後提供您想要開發的專案的具體要求。

>[!IMPORTANT]
>盡可能明確地說明您正在嘗試建立**什麼**以及**為什麼**。**此時不要專注於技術堆疊**。

範例提示：

```text
開發 Taskify，一個團隊生產力平台。它應該允許使用者建立專案、新增團隊成員、
分配任務、評論並在看板樣式中移動任務。在此功能的初始階段，
我們稱之為「建立 Taskify」，我們將有多個使用者，但使用者將預先聲明、預先定義。
我想要五個使用者，分為兩個不同的類別，一個產品經理和四個工程師。讓我們建立三個
不同的範例專案。讓我們為每個任務的狀態設定標準的看板欄位，例如「待辦」、
「進行中」、「審查中」和「完成」。此應用程式將不提供登入功能，因為這只是
第一個測試，以確保我們的基本功能已設定。對於任務卡 UI 中的每個任務，
您應該能夠在看板工作板的不同欄位之間變更任務的目前狀態。
您應該能夠為特定卡片留下無限數量的評論。您應該能夠從該任務卡片中
分配其中一個有效使用者。當您第一次啟動 Taskify 時，它會為您提供五個使用者清單供您選擇。
不需要密碼。當您點擊使用者時，您會進入主檢視，其中顯示專案清單。
當您點擊專案時，您會開啟該專案的看板。您將看到欄位。
您將能夠在不同欄位之間拖放卡片。您將看到分配給您（目前登入的使用者）的任何卡片，
其顏色與所有其他卡片不同，因此您可以快速查看您的卡片。您可以編輯您所做的任何評論，
但不能編輯其他人所做的評論。您可以刪除您所做的任何評論，但不能刪除其他人所做的評論。
```

輸入此提示後，您應該會看到 Claude Code 啟動規劃和規範草擬流程。Claude Code 還將觸發一些內建指令碼來設定儲存庫。

完成此步驟後，您應該會建立一個新分支 (例如 `001-create-taskify`)，以及 `specs/001-create-taskify` 目錄中的新規範。

產生的規範應包含一組使用者故事和功能要求，如範本中所定義。

在此階段，您的專案資料夾內容應類似於以下內容：

```text
├── memory
│	 ├── constitution.md
│	 └── constitution_update_checklist.md
├── scripts
│	 ├── check-task-prerequisites.sh
│	 ├── common.sh
│	 ├── create-new-feature.sh
│	 ├── get-feature-paths.sh
│	 ├── setup-plan.sh
│	 └── update-claude-md.sh
├── specs
│	 └── 001-create-taskify
│	     └── spec.md
└── templates
    ├── plan-template.md
    ├── spec-template.md
    └── tasks-template.md
```

### **步驟 2：** 功能規範澄清

建立基準規範後，您可以繼續澄清在第一次嘗試中未正確捕獲的任何要求。例如，您可以在相同的 Claude Code 會話中使用類似這樣的提示：

```text
對於您建立的每個範例專案或專案，任務數量應在 5 到 15 個之間，
隨機分佈到不同的完成狀態。確保每個完成階段至少有一個任務。
```

您還應該要求 Claude Code 驗證**審查與接受檢查清單**，勾選已驗證/符合要求的項目，並將未勾選的項目留空。可以使用以下提示：

```text
閱讀審查與接受檢查清單，如果功能規範符合條件，請勾選檢查清單中的每個項目。如果不符合，請留空。
```

重要的是要將與 Claude Code 的互動視為澄清和提出有關規範問題的機會——**不要將其第一次嘗試視為最終結果**。

### **步驟 3：** 產生計畫

您現在可以具體說明技術堆疊和其他技術要求。您可以使用專案範本中內建的 `/plan` 命令，並使用類似這樣的提示：

```text
我們將使用 .NET Aspire 產生此內容，並使用 Postgres 作為資料庫。前端應使用
Blazor 伺服器，具有拖放任務板、即時更新。應建立一個 REST API，包含專案 API、
任務 API 和通知 API。
```

此步驟的輸出將包含許多實作細節文件，您的目錄樹將類似於以下內容：

```text
.
├── CLAUDE.md
├── memory
│	 ├── constitution.md
│	 └── constitution_update_checklist.md
├── scripts
│	 ├── check-task-prerequisites.sh
│	 ├── common.sh
│	 ├── create-new-feature.sh
│	 ├── get-feature-paths.sh
│	 ├── setup-plan.sh
│	 └── update-claude-md.sh
├── specs
│	 └── 001-create-taskify
│	     ├── contracts
│	     │	 ├── api-spec.json
│	     │	 └── signalr-spec.md
│	     ├── data-model.md
│	     ├── plan.md
│	     ├── quickstart.md
│	     ├── research.md
│	     └── spec.md
└── templates
    ├── CLAUDE-template.md
    ├── plan-template.md
    ├── spec-template.md
    └── tasks-template.md
```

檢查 `research.md` 文件以確保根據您的指示使用了正確的技術堆疊。如果任何元件突出，您可以要求 Claude Code 進行細化，甚至讓它檢查您想要使用的平台/框架的本地安裝版本 (例如 .NET)。

此外，如果所選技術堆疊變化迅速 (例如 .NET Aspire、JS 框架)，您可能希望要求 Claude Code 研究其詳細資訊，並使用類似這樣的提示：

```text
我希望您仔細閱讀實作計畫和實作細節，尋找可能受益於額外研究的領域，
因為 .NET Aspire 是一個快速變化的函式庫。對於您確定需要進一步研究的領域，
我希望您更新研究文件，其中包含有關我們將在此 Taskify 應用程式中使用的特定
版本以及產生平行研究任務以澄清
使用網路研究的任何詳細資訊。
```

在此過程中，您可能會發現 Claude Code 陷入了錯誤的研究方向——您可以使用類似這樣的提示來幫助它朝正確的方向前進：

```text
我認為我們需要將其分解為一系列步驟。首先，確定您在實作過程中需要執行但
不確定或會受益於進一步研究的任務清單。寫下這些任務的清單。然後對於這些任務中的每一個，
我希望您啟動一個單獨的研究任務，以便最終結果是我們正在平行研究
所有這些非常具體的任務。我看到您所做的看起來像是在研究
一般的 .NET Aspire，我認為這在這種情況下對我們沒有多大幫助。
那是過於沒有目標的研究。研究需要幫助您解決一個特定的目標問題。
```

>[!NOTE]
>Claude Code 可能會過於熱切地新增您未要求的元件。要求它澄清理由和變更來源。

### **步驟 4：** 讓 Claude Code 驗證計畫

計畫到位後，您應該讓 Claude Code 執行一遍，以確保沒有遺漏任何部分。您可以使用類似這樣的提示：

```text
現在我希望您去審核實作計畫和實作細節文件。
仔細閱讀，著眼於確定是否存在您需要執行的任務序列，這些任務從閱讀中顯而易見。
因為我不知道這裡是否有足夠的內容。例如，
當我查看核心實作時，參考實作細節中適當的位置會很有用，
以便在核心實作或細化過程中逐步找到資訊。
```

這有助於完善實作計畫，並幫助您避免 Claude Code 在其規劃週期中遺漏的潛在盲點。一旦初始細化通過完成，請要求 Claude Code 在您開始實作之前再次檢查清單。

您還可以要求 Claude Code (如果您已安裝 [GitHub CLI](https://docs.github.com/en/github-cli/github-cli)) 繼續從您目前的分支向 `main` 建立一個帶有詳細描述的拉取請求，以確保工作得到適當的追蹤。

>[!NOTE]
>在讓代理程式實作之前，還值得提示 Claude Code 交叉檢查詳細資訊，看看是否有任何過度設計的部分 (請記住——它可能會過於熱切)。如果存在過度設計的元件或決策，您可以要求 Claude Code 解決它們。確保 Claude Code 遵循 [憲法](base/memory/constitution.md) 作為其在建立計畫時必須遵守的基礎。

### 步驟 5：實作

準備就緒後，指示 Claude Code 實作您的解決方案 (包含範例路徑)：

```text
implement specs/002-create-taskify/plan.md
```

Claude Code 將立即行動並開始建立實作。

>[!IMPORTANT]
>Claude Code 將執行本地 CLI 命令 (例如 `dotnet`)——請確保您已將它們安裝在您的機器上。

實作步驟完成後，要求 Claude Code 嘗試執行應用程式並解決任何出現的建構錯誤。如果應用程式執行，但存在 Claude Code 無法透過 CLI 日誌直接取得的_執行時錯誤_ (例如，瀏覽器日誌中呈現的錯誤)，請將錯誤複製並貼上到 Claude Code 中，並讓它嘗試解決。

</details>

---

## 🔍 疑難排解

### Linux 上的 Git Credential Manager

如果您在 Linux 上遇到 Git 驗證問題，您可以安裝 Git Credential Manager：

```bash
#!/usr/bin/env bash
set -e
echo "下載 Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "安裝 Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "設定 Git 使用 GCM..."
git config --global credential.helper manager
echo "清理..."
rm gcm-linux_amd64.2.6.1.deb
```

## 👥 維護者

- Den Delimarsky ([@localden](https://github.com/localden))
- John Lam ([@jflam](https://github.com/jflam))

## 💬 支援

如需支援，請開啟 [GitHub issue](https://github.com/github/spec-kit/issues/new)。我們歡迎錯誤報告、功能要求以及有關使用規範驅動開發的問題。

## 🙏 致謝

此專案深受 [John Lam](https://github.com/jflam) 的工作和研究影響並以此為基礎。

## 📄 授權

此專案根據 MIT 開源授權條款授權。請參閱 [LICENSE](./LICENSE) 文件以獲取完整條款。
