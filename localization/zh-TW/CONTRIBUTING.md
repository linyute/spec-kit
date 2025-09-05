## 貢獻 Spec Kit

您好！我們很高興您願意為 Spec Kit 貢獻。本專案的貢獻根據[專案的開源許可證](LICENSE)向公眾[發布](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license)。

請注意，本專案發布時附帶[貢獻者行為準則](CODE_OF_CONDUCT.md)。參與本專案即表示您同意遵守其條款。

## 執行和測試程式碼的先決條件

這些是作為拉取請求 (PR) 提交過程的一部分，在本地測試您的變更所需的一次性安裝。

1. 安裝 [Python 3.11+](https://www.python.org/downloads/)
1. 安裝 [uv](https://docs.astral.sh/uv/) 用於套件管理
1. 安裝 [Git](https://git-scm.com/downloads)
1. 準備一個 AI 程式碼代理：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/) 或 [Gemini CLI](https://github.com/google-gemini/gemini-cli)

## 提交拉取請求

1. Fork 並複製儲存庫
1. 配置並安裝依賴項：`uv sync`
1. 確保 CLI 在您的機器上正常運作：`uv run specify --help`
1. 建立一個新分支：`git checkout -b my-branch-name`
1. 進行您的變更、新增測試，並確保一切仍然正常運作
1. 如果相關，請使用範例專案測試 CLI 功能
1. 推送到您的 Fork 並提交拉取請求
1. 等待您的拉取請求被審查和合併。

以下是一些可以增加您的拉取請求被接受可能性的事項：

- 遵循專案的編碼慣例。
- 為新功能編寫測試。
- 如果您的變更影響使用者可見的功能，請更新文件（`README.md`、`spec-driven.md`）。
- 讓您的變更盡可能集中。如果有多個您想進行但彼此不依賴的變更，請考慮將它們作為單獨的拉取請求提交。
- 編寫[良好的提交訊息](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)。
- 使用規範驅動開發工作流程測試您的變更，以確保相容性。

## 開發工作流程

在開發 spec-kit 時：

1. 使用您選擇的程式碼代理中的 `specify` CLI 命令（`/specify`、`/plan`、`/tasks`）測試變更
2. 驗證 `templates/` 目錄中的範本是否正常運作
3. 測試 `scripts/` 目錄中的腳本功能
4. 如果進行了主要的流程變更，請確保記憶體文件（`memory/constitution.md`）已更新

## 資源

- [規範驅動開發方法](./spec-driven.md)
- [如何貢獻開源](https://opensource.guide/how-to-contribute/)
- [使用拉取請求](https://help.github.com/articles/about-pull-requests/)
- [GitHub 幫助](https://help.github.com)
