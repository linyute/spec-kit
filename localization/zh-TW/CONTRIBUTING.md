# 貢獻 Spec Kit

您好！我們很高興您願意為 Spec Kit 貢獻。對此專案的貢獻將根據 [專案的開源授權](LICENSE) [發布](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license) 給大眾。

請注意，此專案是根據 [貢獻者行為準則](CODE_OF_CONDUCT.md) 發布的。參與此專案即表示您同意遵守其條款。

## 執行和測試程式碼的先決條件

這些是一次性安裝，以便能夠在拉取請求 (PR) 提交過程中在本地測試您的變更。

1. 安裝 [Python 3.11+](https://www.python.org/downloads/)
1. 安裝 [uv](https://docs.astral.sh/uv/) 用於套件管理
1. 安裝 [Git](https://git-scm.com/downloads)
1. 擁有可用的 [AI 程式碼代理](README.md#-supported-ai-agents)

<details>
<summary><b>💡 如果您使用 <code>VSCode</code> 或 <code>GitHub Codespaces</code> 作為您的 IDE，請注意</b></summary>

<br>

如果您在機器上安裝了 [Docker](https://docker.com)，您可以透過此 [VSCode 擴充功能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) 利用 [開發容器](https://containers.dev)，輕鬆設定您的開發環境，並已安裝和配置上述工具，這要歸功於 `.devcontainer/devcontainer.json` 檔案 (位於專案根目錄)。

為此，只需：

- 簽出儲存庫
- 使用 VSCode 開啟它
- 開啟 [命令面板](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette) 並選擇「開發容器：在容器中開啟資料夾...」

在 [GitHub Codespaces](https://github.com/features/codespaces) 上，這甚至更簡單，因為它在開啟 codespace 時會自動利用 `.devcontainer/devcontainer.json`。

</details>

## 提交拉取請求

>[!NOTE]
>如果您的拉取請求引入了對 CLI 或儲存庫其餘部分的工作產生實質影響的大型變更 (例如，您正在引入新的範本、引數或其他重大變更)，請確保它已由專案維護者**討論並同意**。未經事先討論和同意的大型變更的拉取請求將被關閉。

1. Fork 並複製儲存庫
1. 配置並安裝依賴項：`uv sync`
1. 確保 CLI 在您的機器上運作：`uv run specify --help`
1. 建立一個新分支：`git checkout -b my-branch-name`
1. 進行您的變更，新增測試，並確保一切仍然運作
1. 如果相關，請使用範例專案測試 CLI 功能
1. 推送到您的 fork 並提交拉取請求
1. 等待您的拉取請求被審查和合併。

以下是一些可以增加您的拉取請求被接受的可能性：

- 遵循專案的程式碼慣例。
- 為新功能編寫測試。
- 如果您的變更影響使用者面向的功能，請更新文件 (`README.md`、`spec-driven.md`)。
- 盡可能讓您的變更保持專注。如果有多個您想要進行的變更彼此不依賴，請考慮將它們作為單獨的拉取請求提交。
- 編寫一個 [好的提交訊息](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)。
- 使用規格驅動開發工作流程測試您的變更，以確保相容性。

## 開發工作流程

在處理 spec-kit 時：

1. 使用您選擇的程式碼代理中的 `specify` CLI 命令 (`/speckit.specify`、`/speckit.plan`、`/speckit.tasks`) 測試變更
2. 驗證 `templates/` 目錄中的範本是否正常運作
3. 測試 `scripts/` 目錄中的指令碼功能
4. 如果進行了主要流程變更，請確保記憶體檔案 (`memory/constitution.md`) 已更新

### 在本地測試範本和命令變更

執行 `uv run specify init` 會拉取已發布的套件，其中不包含您的本地變更。
要在本地測試您的範本、命令和其他變更，請遵循以下步驟：

1. **建立發布套件**

   執行以下命令以產生本地套件：

   ```
   ./.github/workflows/scripts/create-release-packages.sh v1.0.0
   ```

2. **將相關套件複製到您的測試專案**

   ```
   cp -r .genreleases/sdd-copilot-package-sh/. <path-to-test-project>/
   ```

3. **開啟並測試代理**

   導航到您的測試專案資料夾並開啟代理以驗證您的實作。

## Spec Kit 中的 AI 貢獻

> [!IMPORTANT]
>
> 如果您使用**任何形式的 AI 協助**來貢獻 Spec Kit，
> 則必須在拉取請求或問題中披露。

我們歡迎並鼓勵使用 AI 工具來幫助改進 Spec Kit！許多有價值的貢獻都透過 AI 協助進行了增強，用於程式碼產生、問題偵測和功能定義。

話雖如此，如果您在貢獻 Spec Kit 時使用任何形式的 AI 協助 (例如，代理、ChatGPT)，
**則必須在拉取請求或問題中披露**，以及 AI 協助的使用程度 (例如，文件評論與程式碼產生)。

如果您的 PR 回應或評論是由 AI 產生的，也請披露。

作為例外，微不足道的間距或錯字修正無需披露，只要變更僅限於程式碼的小部分或短語。

範例披露：

> 此 PR 主要由 GitHub Copilot 編寫。

或更詳細的披露：

> 我諮詢了 ChatGPT 以了解程式碼庫，但解決方案
> 完全由我自己手動撰寫。

未能披露這一點首先是對拉取請求另一端的人類操作員不禮貌，但它也使得
難以確定對貢獻施加多少審查。

在一個完美的世界中，AI 協助將產生與人類相同或更高品質的工作。這不是我們今天所處的世界，在大多數情況下
如果沒有人類監督或專業知識，它會產生無法合理維護或演進的程式碼。

### 我們正在尋找什麼

提交 AI 輔助貢獻時，請確保它們包含：

- **明確披露 AI 使用** - 您對 AI 使用及其在貢獻中的使用程度保持透明
- **人類理解和測試** - 您已親自測試變更並了解它們的作用
- **明確的理由** - 您可以解釋為什麼需要變更以及它如何符合 Spec Kit 的目標
- **具體證據** - 包含測試案例、情境或範例，以證明改進
- **您自己的分析** - 分享您對端到端開發人員體驗的看法

### 我們將關閉什麼

我們保留關閉似乎是以下情況的貢獻的權利：

- 未經驗證提交的未經測試的變更
- 未解決特定 Spec Kit 需求的通用建議
- 未經人工審查或理解的大量提交

### 成功的準則

關鍵是證明您理解並已驗證您建議的變更。如果維護者可以輕易判斷貢獻完全由 AI 產生，沒有人工輸入或測試，那麼它可能需要更多工作才能提交。

持續提交低努力 AI 產生變更的貢獻者可能會根據維護者的判斷被限制進一步貢獻。

請尊重維護者並披露 AI 協助。

## 資源

- [規格驅動開發方法](./spec-driven.md)
- [如何貢獻開源](https://opensource.guide/how-to-contribute/)
- [使用拉取請求](https://help.github.com/articles/about-pull-requests/)
- [GitHub 說明](https://help.github.com)
