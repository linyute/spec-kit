<div align="center">
    <img src="./media/logo_small.webp"/>
    <h1>🌱 Spec Kit</h1>
    <h3><em>更快地建構高品質軟體。</em></h3>
</div>

<p align="center">
    <strong>透過規範驅動開發，讓組織專注於產品情境，而非編寫無差異化的程式碼。</strong>
</p>

[![Release](https://github.com/github/spec-kit/actions/workflows/release.yml/badge.svg)](https://github.com/github/spec-kit/actions/workflows/release.yml)

---

## 目錄

- [🤔 什麼是規範驅動開發？](#-什麼是規範驅動開發)
- [⚡ 開始使用](#-開始使用)
- [📚 核心理念](#-核心理念)
- [🌟 開發階段](#-開發階段)
- [🎯 實驗目標](#-實驗目標)
- [🔧 先決條件](#-先決條件)
- [📖 了解更多](#-了解更多)
- [詳細流程](#詳細流程)
- [疑難排解](#疑難排解)

## 🤔 什麼是規範驅動開發？

規範驅動開發**顛覆了**傳統軟體開發模式。數十年來，程式碼一直是核心——規範只是我們在「真正」的編碼工作開始後建立並丟棄的腳手架。規範驅動開發改變了這一點：**規範變得可執行**，直接生成工作實作，而不僅僅是指導它們。

## ⚡ 開始使用

### 1. 安裝 Specify

根據您使用的程式碼代理初始化您的專案：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

### 2. 建立規範

使用 `/specify` 命令描述您想要建構的內容。專注於**是什麼**和**為什麼**，而不是技術堆疊。

```bash
/specify 建構一個應用程式，幫助我將照片整理到獨立的相簿中。相簿按日期分組，並可在主頁面上透過拖放重新組織。相簿中永遠不會有其他巢狀相簿。在每個相簿中，照片會以磁磚狀介面預覽。
```

### 3. 建立技術實作計畫

使用 `/plan` 命令提供您的技術堆疊和架構選擇。

```bash
/plan 應用程式使用 Vite，並盡可能減少函式庫數量。盡可能使用原生的 HTML、CSS 和 JavaScript。圖片不會上傳到任何地方，中繼資料儲存在本地 SQLite 資料庫中。
```

### 4. 分解並實作

使用 `/tasks` 建立可執行的任務清單，然後要求您的代理實作該功能。

有關詳細的逐步說明，請參閱我們的[綜合指南](./spec-driven.md)。

## 📚 核心理念

規範驅動開發是一個結構化的流程，強調：

- **意圖驅動開發**，其中規範在「如何做」之前定義「是什麼」
- **豐富的規範建立**，使用護欄和組織原則
- **多步驟細化**，而不是從提示一次性生成程式碼
- **高度依賴**進階 AI 模型能力進行規範解釋

## 🌟 開發階段

| 階段 | 焦點 | 主要活動 |
|---|---|---|
| **0 到 1 開發**（「綠地」） | 從頭開始生成 | <ul><li>從高層次需求開始</li><li>生成規範</li><li>規劃實作步驟</li><li>建構生產就緒應用程式</li></ul> |
| **創意探索** | 平行實作 | <ul><li>探索多樣化解決方案</li><li>支援多種技術堆疊和架構</li><li>實驗使用者體驗模式</li></ul> |
| **迭代增強**（「棕地」） | 棕地現代化 | <ul><li>迭代新增功能</li><li>現代化舊有系統</li><li>調整流程</li></ul> |

## 🎯 實驗目標

我們的研究和實驗重點是：

### 技術獨立性

- 使用多樣化技術堆疊建立應用程式
- 驗證規範驅動開發是一個不依賴特定技術、程式語言或框架的流程

### 企業限制

- 展示關鍵任務應用程式開發
- 納入組織限制（雲端供應商、技術堆疊、工程實踐）
- 支援企業設計系統和合規性要求

### 以使用者為中心的開發

- 為不同的使用者群體和偏好建構應用程式
- 支援各種開發方法（從隨性編碼到 AI 原生開發）

### 創意與迭代流程

- 驗證平行實作探索的概念
- 提供強大的迭代功能開發工作流程
- 擴展流程以處理升級和現代化任務

## 🔧 先決條件

- **Linux/macOS** (或 Windows 上的 WSL2)
- AI 程式碼代理：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/) 或 [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- [uv](https://docs.astral.sh/uv/) 用於套件管理
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

## 📖 了解更多

- **[完整的規範驅動開發方法](./spec-driven.md)** - 深入了解完整流程
- **[詳細逐步解說](#detailed-process)** - 逐步實作指南

---

## 詳細流程

<details>
<summary>點擊展開詳細的逐步解說</summary>

您可以使用 Specify CLI 啟動您的專案，這將在您的環境中引入所需的構件。執行：

```bash
specify init <project_name>
```

或在目前目錄中初始化：

```bash
specify init --here
```

![Specify CLI 在終端機中啟動新專案](./media/specify_cli.gif)

系統將提示您選擇正在使用的 AI 代理。您也可以直接在終端機中主動指定：

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

### **步驟 1：** 啟動專案

進入專案資料夾並執行您的 AI 代理。在我們的範例中，我們使用 `claude`。

![啟動 Claude Code 環境](./media/bootstrap-claude-code.gif)

如果您看到 `/specify`、`/plan` 和 `/tasks` 命令可用，則表示設定正確。

第一步應該是建立新的專案骨架。使用 `/specify` 命令，然後提供您要開發專案的具體要求。

>[!IMPORTANT]
>盡可能明確地說明您要建構的**是什麼**以及**為什麼**。**此時不要專注於技術堆疊**。

範例提示：

```text
開發 Taskify，一個團隊生產力平台。它應該允許使用者建立專案、新增團隊成員、
分配任務、評論並在看板風格的面板之間移動任務。在此功能的初始階段，
我們稱之為「建立 Taskify」，我們將有多個使用者，但這些使用者將預先定義。
我想要五個使用者，分為兩個不同的類別：一個產品經理和四個工程師。讓我們建立三個
不同的範例專案。讓我們為每個任務的狀態設定標準的看板欄位，例如「待辦事項」、
「進行中」、「審查中」和「完成」。此應用程式將不需要登入，因為這只是為了確保我們的基本功能已設定好的
第一個測試。對於任務卡 UI 中的每個任務，
您應該能夠在看板工作面板的不同欄位之間變更任務的目前狀態。
您應該能夠為特定卡片留下無限數量的評論。您應該能夠從該任務
卡片中，指派其中一個有效的使用者。當您第一次啟動 Taskify 時，它會為您提供五個使用者清單供您選擇。
將不需要密碼。當您點擊使用者時，您會進入主視圖，其中顯示專案清單。
當您點擊專案時，您會開啟該專案的看板。您將會看到欄位。
您將能夠在不同欄位之間拖放卡片。您將會看到指派給您（目前登入的使用者）的任何卡片，
其顏色與其他卡片不同，因此您可以快速看到您的卡片。您可以編輯您所做的任何評論，但不能編輯其他人所做的評論。您可以
刪除您所做的任何評論，但不能刪除其他人所做的評論。
```

輸入此提示後，您應該會看到 Claude Code 啟動規劃和規範草擬流程。Claude Code 還會觸發一些內建腳本來設定儲存庫。

完成此步驟後，您應該會建立一個新分支（例如 `001-create-taskify`），以及在 `specs/001-create-taskify` 目錄中建立一個新規範。

產生的規範應包含一組使用者故事和功能需求，如範本中所定義。

在此階段，您的專案資料夾內容應類似於以下內容：

```text
├── memory
│  ├── constitution.md
│  └── constitution_update_checklist.md
├── scripts
│  ├── check-task-prerequisites.sh
│  ├── common.sh
│  ├── create-new-feature.sh
│  ├── get-feature-paths.sh
│  ├── setup-plan.sh
│  └── update-claude-md.sh
├── specs
│  └── 001-create-taskify
│      └── spec.md
└── templates
    ├── CLAUDE-template.md
    ├── plan-template.md
    ├── spec-template.md
    └── tasks-template.md
```

### **步驟 2：** 功能規範澄清

建立基準規範後，您可以繼續澄清在第一次嘗試中未正確擷取的任何要求。例如，您可以在相同的 Claude Code 會話中使用類似這樣的提示：

```text
對於您建立的每個範例專案或專案，任務數量應介於 5 到 15 個之間，
每個任務隨機分佈在不同的完成狀態。請確保每個完成階段至少有一個任務。
```

您還應該要求 Claude Code 驗證**審查與接受清單**，勾選已驗證/符合要求的事項，並將未勾選的事項留空。可以使用以下提示：

```text
閱讀審查與接受清單，如果功能規範符合條件，請勾選清單中的每個項目。如果沒有，請留空。
```

重要的是要利用與 Claude Code 的互動作為澄清和詢問規範相關問題的機會——**不要將其第一次嘗試視為最終結果**。

### **步驟 3：** 產生計畫

您現在可以具體說明技術堆疊和其他技術要求。您可以使用專案範本中內建的 `/plan` 命令，並使用類似這樣的提示：

```text
我們將使用 .NET Aspire 生成此內容，並使用 Postgres 作為資料庫。前端應使用
Blazor 伺服器，具備拖放任務板和即時更新功能。應建立一個 REST API，包含專案 API、
任務 API 和通知 API。
```

此步驟的輸出將包含許多實作細節文件，您的目錄樹將類似於：

```text
.
├── CLAUDE.md
├── memory
│  ├── constitution.md
│  └── constitution_update_checklist.md
├── scripts
│  ├── check-task-prerequisites.sh
│  ├── common.sh
│  ├── create-new-feature.sh
│  ├── get-feature-paths.sh
│  ├── setup-plan.sh
│  └── update-claude-md.sh
├── specs
│  └── 001-create-taskify
│      ├── contracts
│      │  ├── api-spec.json
│      │  └── signalr-spec.md
│      ├── data-model.md
│      ├── plan.md
│      ├── quickstart.md
│      ├── research.md
│      └── spec.md
└── templates
    ├── CLAUDE-template.md
    ├── plan-template.md
    ├── spec-template.md
    └── tasks-template.md
```

檢查 `research.md` 文件，確保根據您的指示使用了正確的技術堆疊。如果任何組件突出，您可以要求 Claude Code 進行細化，甚至讓它檢查您要使用的平台/框架（例如 .NET）的本地安裝版本。

此外，您可能希望要求 Claude Code 研究有關所選技術堆疊的詳細資訊，如果它正在快速變化（例如 .NET Aspire、JS 框架），可以使用類似這樣的提示：

```text
我希望您仔細審閱實作計畫和實作細節，尋找可能受益於額外研究的領域，因為 .NET Aspire 是一個快速變化的函式庫。對於您確定需要進一步研究的領域，我希望您更新研究文件，提供有關我們將在此 Taskify 應用程式中使用的特定版本的更多詳細資訊，並啟動平行研究任務，以使用網路上的研究來澄清任何細節。
```

在此過程中，您可能會發現 Claude Code 陷入了錯誤的研究方向——您可以使用類似這樣的提示來幫助它朝正確的方向前進：

```text
我認為我們需要將其分解為一系列步驟。首先，列出您在實作過程中需要執行但尚不確定或將受益於進一步研究的任務。寫下這些任務的清單。然後對於這些任務中的每一個，我希望您啟動一個單獨的研究任務，以便最終結果是我們正在平行研究所有這些非常具體的任務。我看到您所做的是，您似乎正在研究一般的 .NET Aspire，我認為這對我們來說沒有多大幫助。那是過於沒有目標的研究。研究需要幫助您解決一個特定的目標問題。
```

>[!NOTE]
>Claude Code 可能會過於熱心並添加您未要求的功能。請它澄清變更的理由和來源。

### **步驟 4：** 讓 Claude Code 驗證計畫

計畫到位後，您應該讓 Claude Code 審查它，以確保沒有遺漏的部分。您可以使用類似這樣的提示：

```text
現在我希望您審核實作計畫和實作細節文件。
仔細閱讀，判斷是否存在您需要執行的任務序列，這些任務從閱讀中顯而易見。因為我不知道這裡是否有足夠的資訊。例如，
當我查看核心實作時，參考實作細節中適當的位置會很有用，以便在核心實作或細化過程中找到資訊。
```

這有助於完善實作計畫，並幫助您避免 Claude Code 在其規劃週期中遺漏的潛在盲點。一旦初始細化通過，請 Claude Code 再次檢查清單，然後您才能進行實作。

您還可以要求 Claude Code（如果您已安裝 [GitHub CLI](https://docs.github.com/en/github-cli/github-cli)）從您目前的分支向 `main` 建立一個帶有詳細說明的拉取請求，以確保工作得到適當的追蹤。

>[!NOTE]
>在讓代理實作之前，也值得提示 Claude Code 交叉檢查詳細資訊，看看是否有任何過度設計的部分（請記住——它可能會過於熱心）。如果存在過度設計的組件或決策，您可以要求 Claude Code 解決它們。確保 Claude Code 遵循 [constitution](./memory/constitution.md) 作為建立計畫時必須遵守的基礎。

### 步驟 5：實作

準備就緒後，指示 Claude Code 實作您的解決方案（包含範例路徑）：

```text
implement specs/002-create-taskify/plan.md
```

Claude Code 將會開始行動並建立實作。

>[!IMPORTANT]
>Claude Code 將執行本地 CLI 命令（例如 `dotnet`）——請確保您的機器上已安裝它們。

實作步驟完成後，要求 Claude Code 嘗試執行應用程式並解決任何出現的建置錯誤。如果應用程式執行，但存在 Claude Code 無法透過 CLI 日誌直接取得的**執行時錯誤**（例如，瀏覽器日誌中呈現的錯誤），請將錯誤複製並貼上到 Claude Code 中，並讓它嘗試解決。

</details>

---

## 疑難排解

### Linux 上的 Git 憑證管理員

如果您在 Linux 上遇到 Git 驗證問題，可以安裝 Git 憑證管理員：

```bash
#!/bin/bash
set -e
echo "正在下載 Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "正在安裝 Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "正在設定 Git 使用 GCM..."
git config --global credential.helper manager
echo "正在清理..."
rm gcm-linux_amd64.2.6.1.deb
```

## 維護者

- Den Delimarsky ([@localden](https://github.com/localden))
- John Lam ([@jflam](https://github.com/jflam))

## 支援

如需支援，請開啟 [GitHub issue](https://github.com/github/spec-kit/issues/new)。我們歡迎錯誤報告、功能請求以及有關使用規範驅動開發的問題。

## 致謝

此專案深受 [John Lam](https://github.com/jflam) 的工作和研究影響並以此為基礎。

## 授權

此專案根據 MIT 開源授權條款授權。請參閱 [LICENSE](./LICENSE) 文件以了解完整條款。
