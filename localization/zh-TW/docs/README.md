# 文件

此資料夾包含使用 [DocFX](https://dotnet.github.io/docfx/) 建立的規格套件文件原始檔案。

## 本地建構

要在本地建構文件：

1. 安裝 DocFX：
   ```bash
   dotnet tool install -g docfx
   ```

2. 建構文件：
   ```bash
   cd docs
   docfx docfx.json --serve
   ```

3. 在瀏覽器中開啟 `http://localhost:8080` 以檢視文件。

## 結構

- `docfx.json` - DocFX 配置檔案
- `index.md` - 主要文件首頁
- `toc.yml` - 目錄配置
- `installation.md` - 安裝指南
- `quickstart.md` - 快速入門指南
- `_site/` - 產生文件輸出 (被 git 忽略)

## 部署

當變更推送到 `main` 分支時，文件會自動建構並部署到 GitHub Pages。工作流程定義在 `.github/workflows/docs.yml` 中。
