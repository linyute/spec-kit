---
description: 從自然語言功能描述建立或更新功能規格。
scripts:
  sh: scripts/bash/create-new-feature.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json "{ARGS}"
---

根據作為引數提供的功能描述，執行以下操作：

1. 從儲存庫根目錄執行 `{SCRIPT}` 並解析其 JSON 輸出以取得 BRANCH_NAME 和 SPEC_FILE。所有檔案路徑都必須是絕對路徑。
2. 載入 `templates/spec-template.md` 以了解所需的部分。
3. 使用範本結構將規格寫入 SPEC_FILE，用從功能描述 (引數) 派生的具體細節替換佔位符，同時保留部分順序和標題。
4. 報告完成，包括分支名稱、規格檔案路徑以及準備好進入下一階段。

注意：腳本會在寫入之前建立並切換到新分支並初始化規格檔案。
