## 貢獻 Spec Kit

您好！我們很高興您願意貢獻 Spec Kit。本專案的貢獻根據 [專案的開源授權](LICENSE) [發布](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license) 給大眾。

請注意，本專案發布時附帶 [貢獻者行為準則](CODE_OF_CONDUCT.md)。參與本專案即表示您同意遵守其條款。

## 執行與測試程式碼的先決條件

這些是作為 Pull Request (PR) 提交過程的一部分，在本地測試您的變更所需的一次性安裝。

1. 安裝 [Python 3.11+](https://www.python.org/downloads/)
2. 安裝 [uv](https://docs.astral.sh/uv/) 以進行套件管理
3. 安裝 [Git](https://git-scm.com/downloads)
4. 具備 AI 程式碼代理程式：推薦使用 [Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/) 或 [Gemini CLI](https://github.com/google-gemini/gemini-cli)，但我們也正在努力新增對其他代理程式的支援。

## 提交 Pull Request

>[!NOTE]
>如果您的 Pull Request 引入了對 CLI 或儲存庫其餘部分的工作產生實質影響的重大變更（例如，您正在引入新的範本、引數或其他重大變更），請確保它已由專案維護者 **討論並同意**。未經事先討論和同意的重大變更 Pull Request 將會被關閉。

1. Fork 並複製儲存庫
2. 設定並安裝依賴項：`uv sync`
3. 確保 CLI 在您的機器上正常執行：`uv run specify --help`
4. 建立一個新分支：`git checkout -b my-branch-name`
5. 進行您的變更，新增測試，並確保一切正常執行
6. 如果相關，請使用範例專案測試 CLI 功能
7. 推送到您的 Fork 並提交 Pull Request
8. 等待您的 Pull Request 被審查並合併。

以下是一些您可以做的事情，它們將增加您的 Pull Request 被接受的可能性：

- 遵循專案的程式碼慣例。
- 為新功能撰寫測試。
- 如果您的變更影響使用者導向功能，請更新文件 (`README.md,` `spec-driven.md`)。
- 盡可能讓您的變更保持專注。如果有多個您想進行的變更且彼此不依賴，請考慮將它們作為單獨的 Pull Request 提交。
- 撰寫一個 [好的提交訊息](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)。
- 使用 Spec-Driven Development 工作流程測試您的變更以確保相容性。

## 開發工作流程

在開發 spec-kit 時：

1. 在您選擇的程式碼代理程式中，使用 `specify` CLI 命令 (`/specify`、`/plan`、`/tasks`) 測試變更
2. 驗證 `templates/` 目錄中的範本是否正常運作
3. 測試 `scripts/` 目錄中的腳本功能
4. 如果進行了主要的流程變更，請確保記憶體檔案 (`memory/constitution.md`) 已更新

## 資源

- [Spec-Driven 開發方法](./spec-driven.md)
- [如何貢獻開源專案](https://opensource.guide/how-to-contribute/)
- [使用 Pull Request](https://help.github.com/articles/about-pull-requests/)
- [GitHub 說明](https://help.github.com)
