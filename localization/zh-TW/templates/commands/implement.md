---
description: 透過處理和執行 tasks.md 中定義的所有任務來執行實作計畫。
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

1. 從倉庫根目錄執行 `{SCRIPT}` 並解析 FEATURE_DIR 和 AVAILABLE_DOCS 列表。所有路徑都必須是絕對路徑。對於像 "I'm Groot" 這樣的參數中的單引號，請使用轉義語法：例如 'I'm Groot'（如果可能，也可以使用雙引號："I'm Groot"）。

2. **檢查檢查表狀態**（如果 FEATURE_DIR/checklists/ 存在）：
   - 掃描 checklists/ 目錄中的所有檢查表檔案
   - 對於每個檢查表，計算：
     - 總項目：所有匹配 `- [ ]` 或 `- [X]` 或 `- [x]` 的行
     - 已完成項目：匹配 `- [X]` 或 `- [x]` 的行
     - 未完成項目：匹配 `- [ ]` 的行
   - 建立一個狀態表：

     ```text
     | 檢查表 | 總計 | 已完成 | 未完成 | 狀態 | 
     |-----------|-------|-----------|------------|--------|
     | ux.md     | 12    | 12        | 0          | ✓ 通過 |
     | test.md   | 8     | 5         | 3          | ✗ 失敗 |
     | security.md | 6   | 6         | 0          | ✓ 通過 |
     ```

   - 計算總體狀態：
     - **通過**：所有檢查表都沒有未完成項目
     - **失敗**：一個或多個檢查表有未完成項目

   - **如果任何檢查表未完成**：
     - 顯示包含未完成項目計數的表格
     - **停止**並詢問：「某些檢查表未完成。您是否仍要繼續實作？(是/否)」
     - 在繼續之前等待使用者回應
     - 如果使用者說「否」或「等待」或「停止」，則停止執行
     - 如果使用者說「是」或「繼續」或「繼續」，則繼續執行步驟 3

   - **如果所有檢查表都已完成**：
     - 顯示所有檢查表都已通過的表格
     - 自動繼續執行步驟 3

3. 載入並分析實作上下文：
   - **必填**：讀取 tasks.md 以獲取完整的任務列表和執行計畫
   - **必填**：讀取 plan.md 以獲取技術堆疊、架構和檔案結構
   - **如果存在**：讀取 data-model.md 以獲取實體和關係
   - **如果存在**：讀取 contracts/ 以獲取 API 規格和測試要求
   - **如果存在**：讀取 research.md 以獲取技術決策和約束
   - **如果存在**：讀取 quickstart.md 以獲取整合情境

4. **專案設定驗證**：
   - **必填**：根據實際專案設定建立/驗證忽略檔案：

   **偵測與建立邏輯**：
   - 檢查以下命令是否成功，以確定倉庫是否為 git 倉庫（如果是，則建立/驗證 .gitignore）：

     ```sh
     git rev-parse --git-dir 2>/dev/null
     ```

   - 檢查 Dockerfile* 是否存在或 plan.md 中是否有 Docker → 建立/驗證 .dockerignore
   - 檢查 .eslintrc* 是否存在 → 建立/驗證 .eslintignore
   - 檢查 eslint.config.* 是否存在 → 確保配置的 `ignores` 條目涵蓋所需模式
   - 檢查 .prettierrc* 是否存在 → 建立/驗證 .prettierignore
   - 檢查 .npmrc 或 package.json 是否存在 → 建立/驗證 .npmignore（如果發布）
   - 檢查 terraform 檔案 (*.tf) 是否存在 → 建立/驗證 .terraformignore
   - 檢查是否需要 .helmignore（是否存在 helm 圖表）→ 建立/驗證 .helmignore

   **如果忽略檔案已存在**：驗證它是否包含基本模式，僅附加缺少的關鍵模式
   **如果忽略檔案缺失**：使用檢測到的技術的完整模式集建立

   **按技術劃分的常見模式**（來自 plan.md 技術堆疊）：
   - **Node.js/JavaScript/TypeScript**：`node_modules/`、`dist/`、`build/`、`*.log`、`.env*`
   - **Python**：`__pycache__/`、`*.pyc`、`.venv/`、`venv/`、`dist/`、`*.egg-info/`
   - **Java**：`target/`、`*.class`、`*.jar`、`.gradle/`、`build/`
   - **C#/.NET**：`bin/`、`obj/`、`*.user`、`*.suo`、`packages/`
   - **Go**：`*.exe`、`*.test`、`vendor/`、`*.out`
   - **Ruby**：`.bundle/`、`log/`、`tmp/`、`*.gem`、`vendor/bundle/`
   - **PHP**：`vendor/`、`*.log`、`*.cache`、`*.env`
   - **Rust**：`target/`、`debug/`、`release/`、`*.rs.bk`、`*.rlib`、`*.prof*`、`.idea/`、`*.log`、`.env*`
   - **Kotlin**：`build/`、`out/`、`.gradle/`、`.idea/`、`*.class`、`*.jar`、`*.iml`、`*.log`、`.env*`
   - **C++**：`build/`、`bin/`、`obj/`、`out/`、`*.o`、`*.so`、`*.a`、`*.exe`、`*.dll`、`.idea/`、`*.log`、`.env*`
   - **C**：`build/`、`bin/`、`obj/`、`out/`、`*.o`、`*.a`、`*.so`、`*.exe`、`Makefile`、`config.log`、`.idea/`、`*.log`、`.env*`
   - **Swift**：`.build/`、`DerivedData/`、`*.swiftpm/`、`Packages/`
   - **R**：`.Rproj.user/`、`.Rhistory`、`.RData`、`.Ruserdata`、`*.Rproj`、`packrat/`、`renv/`
   - **通用**：`.DS_Store`、`Thumbs.db`、`*.tmp`、`*.swp`、`.vscode/`、`.idea/`

   **工具特定模式**：
   - **Docker**：`node_modules/`、`.git/`、`Dockerfile*`、`.dockerignore`、`*.log*`、`.env*`、`coverage/`
   - **ESLint**：`node_modules/`、`dist/`、`build/`、`coverage/`、`*.min.js`
   - **Prettier**：`node_modules/`、`dist/`、`build/`、`coverage/`、`package-lock.json`、`yarn.lock`、`pnpm-lock.yaml`
   - **Terraform**：`.terraform/`、`*.tfstate*`、`*.tfvars`、`.terraform.lock.hcl`
   - **Kubernetes/k8s**：`*.secret.yaml`、`secrets/`、`.kube/`、`kubeconfig*`、`*.key`、`*.crt`

5. 解析 tasks.md 結構並提取：
   - **任務階段**：設定、測試、核心、整合、優化
   - **任務依賴關係**：順序執行與並行執行規則
   - **任務詳細資訊**：ID、描述、檔案路徑、並行標記 [P]
   - **執行流程**：順序和依賴要求

6. 按照任務計畫執行實作：
   - **逐階段執行**：在進入下一個階段之前完成每個階段
   - **尊重依賴關係**：按順序執行順序任務，並行任務 [P] 可以一起執行
   - **遵循 TDD 方法**：在對應的實作任務之前執行測試任務
   - **基於檔案的協調**：影響相同檔案的任務必須按順序執行
   - **驗證檢查點**：在繼續之前驗證每個階段的完成情況

7. 實作執行規則：
   - **首先設定**：初始化專案結構、依賴關係、配置
   - **程式碼之前先測試**：如果您需要為合約、實體和整合情境編寫測試
   - **核心開發**：實作模型、服務、CLI 命令、端點
   - **整合工作**：資料庫連接、中介軟體、日誌記錄、外部服務
   - **優化和驗證**：單元測試、效能優化、文件

8. 進度追蹤和錯誤處理：
   - 每個完成的任務後報告進度
   - 如果任何非並行任務失敗，則停止執行
   - 對於並行任務 [P]，繼續執行成功的任務，報告失敗的任務
   - 提供清晰的錯誤訊息和上下文以進行偵錯
   - 如果實作無法繼續，則建議下一步
   - **重要**：對於已完成的任務，請務必在任務檔案中將任務標記為 [X]。

9. 完成驗證：
   - 驗證所有必需的任務都已完成
   - 檢查已實作的功能是否與原始規格匹配
   - 驗證測試是否通過且覆蓋率是否符合要求
   - 確認實作遵循技術計畫
   - 報告最終狀態以及已完成工作的摘要

注意：此命令假設 tasks.md 中存在完整的任務分解。如果任務不完整或缺失，請建議先執行 `/speckit.tasks` 以重新產生任務列表。
