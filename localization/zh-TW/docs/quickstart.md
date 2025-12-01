# 快速入門指南

本指南將協助您開始使用 Spec Kit 進行規格導向開發 (Spec-Driven Development)。

> [!NOTE]
> 所有自動化腳本現在都提供 Bash (`.sh`) 和 PowerShell (`.ps1`) 兩種版本。除非您傳遞 `--script sh|ps`，否則 `specify` CLI 會根據作業系統自動選擇。

## 6 個步驟的流程

> [!TIP]
> **上下文感知**：Spec Kit 命令會根據您目前的 Git 分支（例如 `001-feature-name`）自動偵測作用中的功能。若要切換不同的規格，只需切換 Git 分支即可。

### 步驟 1：安裝 Specify

**在您的終端機中**，執行 `specify` CLI 命令以初始化您的專案：

```bash
# 建立一個新的專案目錄
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>

# 或在目前目錄中初始化
uvx --from git+https://github.com/github/spec-kit.git specify init .
```

明確選擇腳本類型（選用）：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --script ps  # 強制使用 PowerShell
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --script sh  # 強制使用 POSIX shell
```

### 步驟 2：定義您的規範

**在您的 AI 代理程式聊天介面中**，使用 `/speckit.constitution` 斜線命令來建立您專案的核心規則和原則。您應該提供您專案的特定原則作為參數。

```markdown
/speckit.constitution 本專案遵循「函式庫優先」方法。所有功能都必須先實作為獨立函式庫。我們嚴格使用 TDD。我們偏好函式式程式設計模式。
```

### 步驟 3：建立規格

**在聊天中**，使用 `/speckit.specify` 斜線命令來描述您要建構的內容。專注於**做什麼**和**為什麼**，而不是技術堆疊。

```markdown
/speckit.specify 建構一個應用程式，可以協助我將照片整理到不同的相簿中。相簿按日期分組，並且可以在主頁面上透過拖放重新整理。相簿永遠不會嵌套在其他相簿中。在每個相簿中，照片以圖塊介面預覽。
```

### 步驟 4：完善規格

**在聊天中**，使用 `/speckit.clarify` 斜線命令來識別和解決您規格中的模糊之處。您可以提供特定的重點領域作為參數。

```bash
/speckit.clarify 專注於安全性和效能要求。
```

### 步驟 5：建立技術實作計畫

**在聊天中**，使用 `/speckit.plan` 斜線命令來提供您的技術堆疊和架構選擇。

```markdown
/speckit.plan 該應用程式使用 Vite，並盡量減少函式庫數量。盡可能使用原生 HTML、CSS 和 JavaScript。影像不會上傳到任何地方，且中繼資料儲存在本機 SQLite 資料庫中。
```

### 步驟 6：分解並實作

**在聊天中**，使用 `/speckit.tasks` 斜線命令來建立一個可執行的任務清單。

```markdown
/speckit.tasks
```

（選用）使用 `/speckit.analyze` 驗證計畫：

```markdown
/speckit.analyze
```

然後，使用 `/speckit.implement` 斜線命令來執行計畫。

```markdown
/speckit.implement
```

## 詳細範例：建構 Taskify

以下是建構團隊生產力平台的一個完整範例：

### 步驟 1：定義規範

初始化專案的規範以設定基本規則：

```markdown
/speckit.constitution Taskify 是一個「安全性優先」應用程式。所有使用者輸入都必須經過驗證。我們使用微服務架構。程式碼必須完整記錄。
```

### 步驟 2：使用 `/speckit.specify` 定義要求

```text
開發 Taskify，一個團隊生產力平台。它應該允許使用者建立專案、新增團隊成員、
分配任務、評論並在看板樣式中移動任務。在此功能的初始階段，
我們稱之為「建立 Taskify」，我們將有多個使用者，但使用者將會預先定義。
我想要五個不同類別的使用者，一位產品經理和四位工程師。我們建立三個
不同的範例專案。我們將為每個任務的狀態提供標準的看板欄位，例如「待辦」、
「進行中」、「審查中」和「完成」。此應用程式將不提供登入功能，因為這只是
第一個測試，以確保我們的基本功能已設定。
```

### 步驟 3：完善規格

使用 `/speckit.clarify` 命令以互動方式解決規格中的任何模糊之處。您還可以提供要確保包含的特定詳細資訊。

```bash
/speckit.clarify 我想澄清任務卡詳細資訊。對於任務卡 UI 中的每個任務，您應該能夠在看板工作板的不同欄位之間更改任務的目前狀態。您應該能夠為特定卡片留下無限數量的評論。您應該能夠從該任務卡片中分配其中一個有效使用者。
```

您可以繼續使用 `/speckit.clarify` 完善規格，提供更多詳細資訊：

```bash
/speckit.clarify 當您第一次啟動 Taskify 時，它會為您提供五個使用者清單供您選擇。不需要密碼。當您點擊使用者時，您會進入主檢視表，其中顯示專案清單。當您點擊專案時，您會開啟該專案的看板。您會看到欄位。您將能夠在不同欄位之間拖放卡片。您將會看到分配給您（目前登入的使用者）的任何卡片，其顏色與其他卡片不同，因此您可以快速檢視自己的卡片。您可以編輯您發表的任何評論，但不能編輯其他人發表的評論。您可以刪除您發表的任何評論，但不能刪除其他人發表的評論。
```

### 步驟 4：驗證規格

使用 `/speckit.checklist` 命令驗證規格清單：

```bash
/speckit.checklist
```

### 步驟 5：使用 `/speckit.plan` 產生技術計畫

具體說明您的技術堆疊和技術要求：

```bash
/speckit.plan 我們將使用 .NET Aspire 產生此內容，並使用 Postgres 作為資料庫。前端應該使用 Blazor 伺服器，並具有拖放任務板和即時更新功能。應該建立一個 REST API，其中包含專案 API、任務 API 和通知 API。
```

### 步驟 6：驗證和實作

讓您的 AI 代理程式使用 `/speckit.analyze` 審核實作計畫：

```bash
/speckit.analyze
```

最後，實作解決方案：

```bash
/speckit.implement
```

## 主要原則

-   **明確**您正在建構的內容以及原因
-   在規格階段**不要專注於技術堆疊**
-   在實作之前**迭代和完善**您的規格
-   在程式碼撰寫開始之前**驗證**計畫
-   **讓 AI 代理程式處理**實作細節

## 後續步驟

-   閱讀 [完整方法論](../spec-driven.md) 以獲取深入指導
-   查看儲存庫中的 [更多範例](../templates)
-   在 GitHub 上探索 [原始程式碼](https://github.com/github/spec-kit)
