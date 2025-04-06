#!/bin/bash

# 🚩 切到腳本所在目錄
cd "$(dirname "$0")" || exit 1

# 🧠 專案名稱 = 資料夾名稱
REPO_NAME=$(basename "$PWD")

# 🧑 匿名使用者設定
GIT_NAME="Uploader Bot"
GIT_EMAIL="bot@example.com"

# 📁 取得當前腳本名稱
SCRIPT_NAME=$(basename "$0")

# 🧪 確認是否安裝 GitHub CLI
if ! command -v gh &> /dev/null; then
  echo "❌ 請先安裝 GitHub CLI：https://cli.github.com/"
  exit 1
fi

# 🔐 驗證 GitHub CLI 是否已登入
if ! gh auth status &>/dev/null; then
  echo "🔑 尚未登入 GitHub，請依指示登入..."
  gh auth login || { echo "❌ 登入失敗，終止腳本。"; exit 1; }
fi

# 🌀 初始化 git
if [ ! -d .git ]; then
  echo "📁 初始化 Git 倉庫..."
  git init
fi

# ⚙️ 設定匿名身份
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

# 🧼 建立或更新 .gitignore
if [ ! -f .gitignore ]; then
  touch .gitignore
fi

# 確保腳本本身被忽略
grep -qxF "$SCRIPT_NAME" .gitignore || echo "$SCRIPT_NAME" >> .gitignore

# 加入其他常見忽略檔案
grep -qxF "venv/" .gitignore || echo "venv/" >> .gitignore
grep -qxF ".env" .gitignore || echo ".env" >> .gitignore
grep -qxF "__pycache__/" .gitignore || echo "__pycache__/" >> .gitignore

# ➕ 加入所有檔案並提交
git add .
git commit -m "📦 Initial commit"

# 🚀 建立或推送 GitHub repo
if ! git remote | grep -q origin; then
  echo "🌐 建立 GitHub Repo 並推送..."
  gh repo create "$REPO_NAME" --source=. --private --push
else
  echo "🚀 推送更新到遠端 origin..."
  git push -u origin main
fi

echo "✅ 已成功上傳專案到 GitHub：https://github.com/<你的帳號>/$REPO_NAME"
