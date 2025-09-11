# 安裝指南

## 先決條件

- **Linux/macOS** (或 Windows 上的 WSL2)
- AI 程式碼代理程式：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/) 或 [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- [uv](https://docs.astral.sh/uv/) 用於套件管理
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

## 安裝

### 初始化新專案

最簡單的入門方法是初始化一個新專案：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

或在目前目錄中初始化：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init --here
```

### 指定 AI 代理程式

您可以在初始化期間主動指定您的 AI 代理程式：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai claude
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai gemini
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai copilot
```

### 忽略代理程式工具檢查

如果您希望在不檢查正確工具的情況下取得範本：

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai claude --ignore-agent-tools
```

## 驗證

初始化後，您應該會在您的 AI 代理程式中看到以下命令：
- `/specify` - 建立規格
- `/plan` - 產生實作計畫
- `/tasks` - 分解為可執行的任務

## 疑難排解

### Linux 上的 Git Credential Manager

如果您在 Linux 上遇到 Git 驗證問題，您可以安裝 Git Credential Manager：

```bash
#!/usr/bin/env bash
set -e
echo "Downloading Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "Installing Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "Configuring Git to use GCM..."
git config --global credential.helper manager
echo "Cleaning up..."
rm gcm-linux_amd64.2.6.1.deb
```
