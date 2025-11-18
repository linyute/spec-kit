---
description: 執行實作規劃工作流程，使用規劃範本建立設計成品。
handoffs: 
  - label: 建立任務
    agent: speckit.tasks
    prompt: 將規劃分解為任務
    send: true
  - label: 建立檢查清單
    agent: speckit.checklist
    prompt: 為以下領域建立檢查清單...
scripts:
  sh: scripts/bash/setup-plan.sh --json
  ps: scripts/powershell/setup-plan.ps1 -Json
agent_scripts:
  sh: scripts/bash/update-agent-context.sh __AGENT__
  ps: scripts/powershell/update-agent-context.ps1 -AgentType __AGENT__
---

## 使用者輸入

```text
$ARGUMENTS
```

您**必須**在繼續之前考慮使用者輸入（如果非空）。

## 大綱

1. **設定**：從儲存庫根目錄執行 `{SCRIPT}` 並解析 JSON 以取得 FEATURE_SPEC、IMPL_PLAN、SPECS_DIR、BRANCH。對於像 "I'm Groot" 這樣的單引號參數，請使用跳脫語法：例如 'I'\''m Groot'（或如果可能，使用雙引號："I'm Groot"）。

2. **載入上下文**：讀取 FEATURE_SPEC 和 `/memory/constitution.md`。載入 IMPL_PLAN 範本（已複製）。

3. **執行規劃工作流程**：遵循 IMPL_PLAN 範本中的結構以：
   - 填寫技術上下文（將未知標記為「需要釐清」）
   - 從憲法中填寫憲法檢查部分
   - 評估閘門（如果違規不合理則為錯誤）
   - 階段 0：建立 research.md（解決所有「需要釐清」）
   - 階段 1：建立 data-model.md、contracts/、quickstart.md
   - 階段 1：透過執行代理程式指令碼更新代理程式上下文
   - 設計後重新評估憲法檢查

4. **停止並報告**：命令在階段 2 規劃後結束。報告分支、IMPL_PLAN 路徑和建立的成品。

## 階段

### 階段 0：大綱與研究

1. **從上方技術上下文提取未知**：
   - 對於每個「需要釐清」→ 研究任務
   - 對於每個依賴項 → 最佳實踐任務
   - 對於每個整合 → 模式任務

2. **建立並分派研究代理程式**：

   ```text
   對於技術上下文中的每個未知：
     任務：「研究 {unknown} 以取得 {feature context}」
   對於每個技術選擇：
     任務：「在 {domain} 中尋找 {tech} 的最佳實踐」
   ```

3. **在 `research.md` 中整合發現**，使用以下格式：
   - 決策：[選擇了什麼]
   - 理由：[為什麼選擇]
   - 考慮的替代方案：[還評估了什麼]

**輸出**：research.md，所有「需要釐清」已解決

### 階段 1：設計與合約

**先決條件**：`research.md` 完成

1. **從功能規格中提取實體** → `data-model.md`：
   - 實體名稱、欄位、關係
   - 來自需求的驗證規則
   - 如果適用，狀態轉換

2. **從功能需求建立 API 合約**：
   - 對於每個使用者動作 → 端點
   - 使用標準 REST/GraphQL 模式
   - 將 OpenAPI/GraphQL 綱要輸出到 `/contracts/`

3. **代理程式上下文更新**：
   - 執行 `{AGENT_SCRIPT}`
   - 這些指令碼偵測正在使用哪個 AI 代理程式
   - 更新適當的代理程式特定上下文檔案
   - 僅從目前規劃中新增技術
   - 保留標記之間的手動新增內容

**輸出**：data-model.md、/contracts/*、quickstart.md、代理程式特定檔案

## 主要規則

- 使用絕對路徑
- 閘門失敗或未解決的釐清則為錯誤
