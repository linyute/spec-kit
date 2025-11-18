---
description: 將現有任務轉換為可執行的、依賴排序的 GitHub 問題，以用於基於可用設計產物的特性。
tools: ['github/github-mcp-server/issue_write']
scripts:
  sh: scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks
  ps: scripts/powershell/check-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
---

## 使用者輸入

```text
$ARGUMENTS
```

您**必須**在繼續之前考慮使用者輸入（如果非空）。

## 概述

1. 從倉庫根目錄執行 `{SCRIPT}` 並解析 FEATURE_DIR 和 AVAILABLE_DOCS 列表。所有路徑都必須是絕對路徑。對於像 "I'm Groot" 這樣的參數中的單引號，請使用轉義語法：例如 'I'\''m Groot'（如果可能，也可以使用雙引號："I'm Groot"）。
1. 從執行腳本中，提取**任務**的路徑。
1. 透過執行以下命令獲取 Git 遠端：

```bash
git config --get remote.origin.url
```

**僅當遠端是 GITHUB URL 時才繼續執行後續步驟**

1. 對於列表中的每個任務，使用 GitHub MCP 伺服器在代表 Git 遠端的倉庫中建立一個新問題。

**在任何情況下都不得在與遠端 URL 不匹配的倉庫中建立問題**
