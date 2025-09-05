# [PROJECT_NAME] 核心準則
<!-- 範例：Spec 核心準則、TaskFlow 核心準則等。 -->

## 核心原則

### [PRINCIPLE_1_NAME]
<!-- 範例：I. 函式庫優先 -->
[PRINCIPLE_1_DESCRIPTION]
<!-- 範例：每個功能都以獨立函式庫的形式開始；函式庫必須是自包含、可獨立測試、有文件記錄的；需要明確的目的——沒有僅限組織的函式庫 -->

### [PRINCIPLE_2_NAME]
<!-- 範例：II. CLI 介面 -->
[PRINCIPLE_2_DESCRIPTION]
<!-- 範例：每個函式庫都透過 CLI 公開功能；文字輸入/輸出協定：stdin/args → stdout，錯誤 → stderr；支援 JSON + 人類可讀格式 -->

### [PRINCIPLE_3_NAME]
<!-- 範例：III. 測試優先 (不可妥協) -->
[PRINCIPLE_3_DESCRIPTION]
<!-- 範例：TDD 強制：測試編寫 → 使用者批准 → 測試失敗 → 然後實作；嚴格執行紅-綠-重構循環 -->

### [PRINCIPLE_4_NAME]
<!-- 範例：IV. 整合測試 -->
[PRINCIPLE_4_DESCRIPTION]
<!-- 範例：需要整合測試的重點領域：新函式庫契約測試、契約變更、服務間通訊、共享模式 -->

### [PRINCIPLE_5_NAME]
<!-- 範例：V. 可觀察性、VI. 版本控制與破壞性變更、VII. 簡潔性 -->
[PRINCIPLE_5_DESCRIPTION]
<!-- 範例：文字 I/O 確保可偵錯性；需要結構化日誌記錄；或：MAJOR.MINOR.BUILD 格式；或：從簡單開始，YAGNI 原則 -->

## [SECTION_2_NAME]
<!-- 範例：額外約束、安全要求、效能標準等。 -->

[SECTION_2_CONTENT]
<!-- 範例：技術堆疊要求、合規標準、部署策略等。 -->

## [SECTION_3_NAME]
<!-- 範例：開發工作流程、審查流程、品質閘門等。 -->

[SECTION_3_CONTENT]
<!-- 範例：程式碼審查要求、測試閘門、部署批准流程等。 -->

## 治理
<!-- 範例：核心準則取代所有其他實踐；修正案需要文件記錄、批准、遷移計畫 -->

[GOVERNANCE_RULES]
<!-- 範例：所有 PR/審查都必須驗證合規性；複雜性必須合理化；使用 [GUIDANCE_FILE] 獲取執行時開發指南 -->

**版本**：[CONSTITUTION_VERSION] | **批准**：[RATIFICATION_DATE] | **上次修訂**：[LAST_AMENDED_DATE]
<!-- 範例：版本：2.1.1 | 批准：2025-06-13 | 上次修訂：2025-07-16 -->
