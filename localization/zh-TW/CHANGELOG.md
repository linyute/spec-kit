# 更新日誌

<!-- markdownlint-disable MD024 -->

Specify CLI 和範本的所有顯著變更都記錄在此處。

格式基於 [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)，
此專案遵循 [Semantic Versioning](https://semver.org/spec/v2.0.0.html)。

## [0.0.22] - 2025-11-07

- 支援 VS Code/Copilot 代理，並從提示轉向具有交接功能的適當代理。
- 轉為使用 `AGENTS.md` 處理 Copilot 工作負載，因為它已開箱即用。
- 新增對版本命令的支援。([#486](https://github.com/github/spec-kit/issues/486))
- 修正 `create-new-feature.ps1` 指令碼中可能存在的錯誤，該指令碼在確定下一個功能編號時會忽略現有的功能分支 ([#975](https://github.com/github/spec-kit/issues/975))
- 在範本擷取期間，為 GitHub API 速率限制新增優雅的降級和日誌記錄 ([#970](https://github.com/github/spec-kit/issues/970))

## [0.0.21] - 2025-10-21

- 修正 [#975](https://github.com/github/spec-kit/issues/975) (感謝 [@fgalarraga](https://github.com/fgalarraga))。
- 新增對 Amp CLI 的支援。
- 新增對 VS Code 交接的支援，並將提示轉變為成熟的聊天模式。
- 新增對 `version` 命令的支援 (解決 [#811](https://github.com/github/spec-kit/issues/811) 和 [#486](https://github.com/github/spec-kit/issues/486)，感謝 [@mcasalaina](https://github.com/mcasalaina) 和 [@dentity007](https://github.com/dentity007))。
- 新增對在遇到速率限制錯誤時從 CLI 呈現錯誤的支援 ([#970](https://github.com/github/spec-kit/issues/970)，感謝 [@psmman](https://github.com/psmman))。

## [0.0.20] - 2025-10-14

### 新增

- **智慧分支命名**：`create-new-feature` 指令碼現在支援 `--short-name` 參數，用於自訂分支名稱
  - 提供 `--short-name` 時：直接使用自訂名稱 (已清理和格式化)
  - 省略時：使用停用詞過濾和基於長度的過濾自動產生有意義的名稱
  - 過濾掉常見的停用詞 (I、want、to、the、for 等)
  - 移除少於 3 個字元的單詞 (除非它們是大寫縮寫)
  - 從描述中選取 3-4 個最有意義的單詞
  - **強制執行 GitHub 的 244 位元組分支名稱限制**，並自動截斷和警告
  - 範例：
    - 「I want to create user authentication」→ `001-create-user-authentication`
    - 「Implement OAuth2 integration for API」→ `001-implement-oauth2-integration-api`
    - 「Fix payment processing bug」→ `001-fix-payment-processing`
    - 非常長的描述會自動在單詞邊界處截斷，以保持在限制內
  - 旨在讓 AI 代理提供語義簡短名稱，同時保持獨立可用性

### 變更

- 增強了 `create-new-feature.sh` 和 `create-new-feature.ps1` 指令碼的說明文件，並附有範例
- 分支名稱現在會根據 GitHub 的 244 位元組限制進行驗證，並在需要時自動截斷

## [0.0.19] - 2025-10-10

### 新增

- 支援 CodeBuddy (感謝 [@lispking](https://github.com/lispking) 的貢獻)。
- 您現在可以在 Specify CLI 中看到 Git 來源的錯誤。

### 變更

- 修正了 `plan.md` 中憲法的路徑 (感謝 [@lyzno1](https://github.com/lyzno1) 的發現)。
- 修正了 Gemini 產生 TOML 檔案中的反斜線逸出 (感謝 [@hsin19](https://github.com/hsin19) 的貢獻)。
- 實作命令現在確保新增正確的忽略檔案 (感謝 [@sigent-amazon](https://github.com/sigent-amazon) 的貢獻)。

## [0.0.18] - 2025-10-06

### 新增

- 支援在 `specify init .` 命令中使用 `.` 作為目前目錄的簡寫，等同於 `--here` 旗標，但對使用者來說更直觀。
- 使用 `/speckit.` 命令前綴輕鬆發現 Spec Kit 相關命令。
- 重構提示和範本，以簡化其功能和追蹤方式。不再用不必要的測試污染事物。
- 確保每個使用者故事建立任務 (簡化測試和驗證)。
- 新增對 Visual Studio Code 提示捷徑和自動指令碼執行的支援。

### 變更

- 所有命令檔案現在都以 `speckit.` 為前綴 (例如 `speckit.specify.md`、`speckit.plan.md`)，以便在 IDE/CLI 命令面板和檔案總管中更好地發現和區分

## [0.0.17] - 2025-09-22

### 新增

- 新增 `/clarify` 命令範本，用於針對現有規格提出最多 5 個目標性釐清問題，並將答案儲存到規格的「釐清」部分。
- 新增 `/analyze` 命令範本，提供非破壞性的跨構件差異和對齊報告 (規格、釐清、計畫、任務、憲法)，插入在 `/tasks` 之後和 `/implement` 之前。
  - 注意：憲法規則被明確視為不可協商；任何衝突都是需要構件補救的關鍵發現，而不是削弱原則。

## [0.0.16] - 2025-09-22

### 新增

- `init` 命令的 `--force` 旗標，用於在使用 `--here` 在非空目錄中時繞過確認，並繼續合併/覆寫檔案。

## [0.0.15] - 2025-09-21

### 新增

- 支援 Roo Code。

## [0.0.14] - 2025-09-21

### 變更

- 錯誤訊息現在一致顯示。

## [0.0.13] - 2025-09-21

### 新增

- 支援 Kilo Code。感謝 [@shahrukhkhan489](https://github.com/shahrukhkhan489) 在 [#394](https://github.com/github/spec-kit/pull/394) 中的貢獻。
- 支援 Auggie CLI。感謝 [@hungthai1401](https://github.com/hungthai1401) 在 [#137](https://github.com/github/spec-kit/pull/137) 中的貢獻。
- 專案佈建完成後顯示代理資料夾安全通知，警告使用者某些代理可能會將憑證或驗證權杖儲存在其代理資料夾中，並建議將相關資料夾新增到 `.gitignore` 以防止意外憑證洩漏。

### 變更

- 顯示警告以確保人們意識到他們可能需要將其代理資料夾新增到 `.gitignore`。
- 清理了 `check` 命令的輸出。

## [0.0.12] - 2025-09-21

### 變更

- 為 OpenAI Codex 使用者新增了額外上下文 — 他們需要設定一個額外的環境變數，如 [#417](https://github.com/github/spec-kit/issues/417) 中所述。

## [0.0.11] - 2025-09-20

### 新增

- Codex CLI 支援 (感謝 [@honjo-hiroaki-gtt](https://github.com/honjo-hiroaki-gtt) 在 [#14](https://github.com/github/spec-kit/pull/14) 中的貢獻)
- 支援 Codex 的上下文更新工具 (Bash 和 PowerShell)，因此功能計畫會與現有助理一起重新整理 `AGENTS.md`，無需手動編輯。

## [0.0.10] - 2025-09-20

### 修正

- 解決了 [#378](https://github.com/github/spec-kit/issues/378) 中 GitHub 權杖在為空時可能附加到請求的問題。

## [0.0.9] - 2025-09-19

### 變更

- 透過代理鍵的青色高亮顯示和完整名稱的灰色括號改進了代理選擇器 UI

## [0.0.8] - 2025-09-19

### 新增

- Windsurf IDE 支援作為額外的 AI 助理選項 (感謝 [@raedkit](https://github.com/raedkit) 在 [#151](https://github.com/github/spec-kit/pull/151) 中的工作)
- GitHub 權杖支援 API 請求，以處理企業環境和速率限制 (由 [@zryfish](https://github.com/@zryfish) 在 [#243](https://github.com/github/spec-kit/pull/243) 中貢獻)

### 變更

- 更新了 README，其中包含 Windsurf 範例和 GitHub 權杖使用方式
- 增強了發布工作流程，以包含 Windsurf 範本

## [0.0.7] - 2025-09-18

### 變更

- 更新了 CLI 中的命令說明。
- 清理了程式碼，使其在通用時不呈現代理特定資訊。

## [0.0.6] - 2025-09-17

### 新增

- opencode 支援作為額外的 AI 助理選項

## [0.0.5] - 2025-09-17

### 新增

- Qwen Code 支援作為額外的 AI 助理選項

## [0.0.4] - 2025-09-14

### 新增

- 透過 `httpx[socks]` 依賴項支援企業環境的 SOCKS 代理

### 修正

不適用

### 變更

不適用
