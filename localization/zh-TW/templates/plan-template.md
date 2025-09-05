# 實作計畫：[FEATURE]

**分支**：`[###-feature-name]` | **日期**：[DATE] | **規範**：[link]
**輸入**：來自 `/specs/[###-feature-name]/spec.md` 的功能規範

## 執行流程 (/plan 命令範圍)
```
1. 從輸入路徑載入功能規範
   → 如果找不到：錯誤「在 {path} 沒有功能規範」
2. 填寫技術上下文（掃描 NEEDS CLARIFICATION）
   → 從上下文偵測專案類型（web=前端+後端，mobile=應用程式+API）
   → 根據專案類型設定結構決策
3. 評估下面的核心準則檢查部分
   → 如果存在違規：在複雜度追蹤中記錄
   → 如果無法證明合理：錯誤「請先簡化方法」
   → 更新進度追蹤：初始核心準則檢查
4. 執行階段 0 → research.md
   → 如果 NEEDS CLARIFICATION 仍然存在：錯誤「解決未知數」
5. 執行階段 1 → contracts, data-model.md, quickstart.md, 代理特定範本檔案（例如，Claude Code 的 `CLAUDE.md`，GitHub Copilot 的 `.github/copilot-instructions.md`，或 Gemini CLI 的 `GEMINI.md`）。
6. 重新評估核心準則檢查部分
   → 如果有新的違規：重構設計，返回階段 1
   → 更新進度追蹤：設計後核心準則檢查
7. 規劃階段 2 → 描述任務生成方法（不要建立 tasks.md）
8. 停止 - 準備好執行 /tasks 命令
```

**重要**：/plan 命令在步驟 7 停止。階段 2-4 由其他命令執行：
- 階段 2：/tasks 命令建立 tasks.md
- 階段 3-4：實作執行（手動或透過工具）

## 摘要
[從功能規範中提取：主要需求 + 來自研究的技術方法]

## 技術上下文
**語言/版本**：[例如，Python 3.11, Swift 5.9, Rust 1.75 或 NEEDS CLARIFICATION]
**主要依賴項**：[例如，FastAPI, UIKit, LLVM 或 NEEDS CLARIFICATION]
**儲存**：[如果適用，例如，PostgreSQL, CoreData, 檔案 或 N/A]
**測試**：[例如，pytest, XCTest, cargo test 或 NEEDS CLARIFICATION]
**目標平台**：[例如，Linux 伺服器, iOS 15+, WASM 或 NEEDS CLARIFICATION]
**專案類型**：[單一/Web/行動 - 決定原始碼結構]
**效能目標**：[領域特定，例如，1000 req/s, 10k 行/秒, 60 fps 或 NEEDS CLARIFICATION]
**約束**：[領域特定，例如，<200ms p95, <100MB 記憶體, 離線功能 或 NEEDS CLARIFICATION]
**規模/範圍**：[領域特定，例如，10k 使用者, 1M LOC, 50 螢幕 或 NEEDS CLARIFICATION]

## 核心準則檢查
*閘門：必須在階段 0 研究之前通過。在階段 1 設計之後重新檢查。*

**簡潔性**：
- 專案：[#] (最多 3 個 - 例如，api, cli, tests)
- 直接使用框架？(沒有包裝類別)
- 單一資料模型？(除非序列化不同，否則沒有 DTO)
- 避免模式？(沒有經過證明的需求，則沒有 Repository/UoW)

**架構**：
- 每個功能都作為函式庫？(沒有直接的應用程式程式碼)
- 列出的函式庫：[名稱 + 每個函式庫的目的]
- 每個函式庫的 CLI：[帶有 --help/--version/--format 的命令]
- 函式庫文件：llms.txt 格式已規劃？

**測試 (不可協商)**：
- 強制執行紅-綠-重構循環？(測試必須先失敗)
- Git 提交顯示測試在實作之前？
- 順序：契約→整合→端到端→單元嚴格遵循？
- 使用真實依賴項？(實際資料庫，而不是模擬)
- 整合測試用於：新函式庫、契約變更、共享模式？
- 禁止：測試前實作，跳過紅色階段

**可觀察性**：
- 包含結構化日誌記錄？
- 前端日誌 → 後端？(統一串流)
- 錯誤上下文足夠？

**版本控制**：
- 已分配版本號？(MAJOR.MINOR.BUILD)
- 每次變更都增加 BUILD？
- 破壞性變更已處理？(平行測試，遷移計畫)

## 專案結構

### 文件 (此功能)
```
specs/[###-feature]/
├── plan.md              # 此檔案 (/plan 命令輸出)
├── research.md          # 階段 0 輸出 (/plan 命令)
├── data-model.md        # 階段 1 輸出 (/plan 命令)
├── quickstart.md        # 階段 1 輸出 (/plan 命令)
├── contracts/           # 階段 1 輸出 (/plan 命令)
└── tasks.md             # 階段 2 輸出 (/tasks 命令 - 非由 /plan 建立)
```

### 原始碼 (儲存庫根目錄)
```
# 選項 1：單一專案 (預設)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# 選項 2：Web 應用程式 (當偵測到「前端」+「後端」時)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# 選項 3：行動裝置 + API (當偵測到「iOS/Android」時)
api/
└── [同上方後端]

ios/ or android/
└── [平台特定結構]
```

**結構決策**：[除非技術上下文指示 Web/行動應用程式，否則預設為選項 1]

## 階段 0：大綱與研究
1. **從上方技術上下文提取未知數**：
   - 每個 NEEDS CLARIFICATION → 研究任務
   - 每個依賴項 → 最佳實踐任務
   - 每個整合 → 模式任務

2. **生成並分派研究代理**：
   ```
   對於技術上下文中的每個未知數：
     任務：「研究 {unknown} 以用於 {feature context}」
   對於每個技術選擇：
     任務：「尋找 {domain} 中 {tech} 的最佳實踐」
   ```

3. **在 `research.md` 中整合發現**，使用格式：
   - 決策：[選擇了什麼]
   - 理由：[為什麼選擇]
   - 考慮的替代方案：[還評估了什麼]

**輸出**：research.md，所有 NEEDS CLARIFICATION 已解決

## 階段 1：設計與契約
*先決條件：research.md 完成*

1. **從功能規範中提取實體** → `data-model.md`：
   - 實體名稱、欄位、關係
   - 來自需求的驗證規則
   - 如果適用，狀態轉換

2. **從功能需求生成 API 契約**：
   - 每個使用者動作 → 端點
   - 使用標準 REST/GraphQL 模式
   - 將 OpenAPI/GraphQL 模式輸出到 `/contracts/`

3. **從契約生成契約測試**：
   - 每個端點一個測試檔案
   - 斷言請求/回應模式
   - 測試必須失敗（尚未實作）

4. **從使用者故事中提取測試場景**：
   - 每個故事 → 整合測試場景
   - 快速入門測試 = 故事驗證步驟

5. **逐步更新代理檔案** (O(1) 操作)：
   - 為您的 AI 助理執行 `/scripts/update-agent-context.sh [claude|gemini|copilot]`
   - 如果存在：僅從目前計畫中新增新技術
   - 在標記之間保留手動新增
   - 更新最近變更（保留最後 3 個）
   - 保持在 150 行以下以提高令牌效率
   - 輸出到儲存庫根目錄

**輸出**：data-model.md, /contracts/*, 失敗的測試, quickstart.md, 代理特定檔案

## 階段 2：任務規劃方法
*本節描述 /tasks 命令將做什麼 - 在 /plan 期間不要執行*

**任務生成策略**：
- 將 `/templates/tasks-template.md` 作為基礎載入
- 從階段 1 設計文件（契約、資料模型、快速入門）生成任務
- 每個契約 → 契約測試任務 [P]
- 每個實體 → 模型建立任務 [P]
- 每個使用者故事 → 整合測試任務
- 實作任務以使測試通過

**排序策略**：
- TDD 順序：測試在實作之前
- 依賴順序：模型在服務之前，服務在 UI 之前
- 標記 [P] 以進行平行執行（獨立檔案）

**預計輸出**：tasks.md 中有 25-30 個編號、排序的任務

**重要**：此階段由 /tasks 命令執行，而不是由 /plan 執行

## 階段 3+：未來實作
*這些階段超出 /plan 命令的範圍*

**階段 3**：任務執行（/tasks 命令建立 tasks.md）
**階段 4**：實作（執行 tasks.md，遵循核心準則原則）
**階段 5**：驗證（執行測試，執行 quickstart.md，效能驗證）

## 複雜度追蹤
*僅在核心準則檢查有必須證明的違規時填寫*

| 違規 | 為何需要 | 拒絕更簡單替代方案的原因 |
|---|---|---|
| [例如，第四個專案] | [目前需求] | [為什麼三個專案不足] |
| [例如，Repository 模式] | [特定問題] | [為什麼直接資料庫存取不足] |


## 進度追蹤
*此檢查清單在執行流程期間更新*

**階段狀態**：
- [ ] 階段 0：研究完成（/plan 命令）
- [ ] 階段 1：設計完成（/plan 命令）
- [ ] 階段 2：任務規劃完成（/plan 命令 - 僅描述方法）
- [ ] 階段 3：任務生成（/tasks 命令）
- [ ] 階段 4：實作完成
- [ ] 階段 5：驗證通過

**閘門狀態**：
- [ ] 初始核心準則檢查：通過
- [ ] 設計後核心準則檢查：通過
- [ ] 所有 NEEDS CLARIFICATION 已解決
- [ ] 複雜度偏差已記錄

---
*基於核心準則 v2.1.1 - 請參閱 `/memory/constitution.md`*