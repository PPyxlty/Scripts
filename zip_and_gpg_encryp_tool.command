#!/bin/bash

# 【安全密島】Debug 模式 Secure Archive Tool 上線
# 打包、加密、解密 + 錯誤檢查 + 訊息點出

cd "$(dirname "$0")" || exit
set -e  # 遇錯立即退出

DATE=$(date +%Y-%m-%d_%H-%M)
ARCHIVE_NAME="backup_${DATE}.tar"
ENCRYPTED_NAME="${ARCHIVE_NAME}.gpg"

# 檢查是否有 .tar.gpg 要解密
GPG_FILE=$(ls *.tar.gpg 2>/dev/null | head -n 1)
if [[ -f "$GPG_FILE" ]]; then
  echo "🔐 偵測到加密檔: $GPG_FILE"
  echo -n "請輸入解密密碼："
  read -s PASSWORD
  echo

  echo "⛏️ 解密中..."
  echo "$PASSWORD" | gpg --batch --yes --passphrase-fd 0 --output "${GPG_FILE%.gpg}" --decrypt "$GPG_FILE"

  echo "📁 還原資料夾..."
  tar -xvf "${GPG_FILE%.gpg}"
  rm "${GPG_FILE%.gpg}" "$GPG_FILE"

  echo "✅ 解密 + 還原完成！"
  exit 0
fi

# 開始打包 + 加密
SCRIPT_NAME=$(basename "$0")
FILES_TO_ARCHIVE=()

for f in *; do
  [[ "$f" == "$SCRIPT_NAME" ]] && continue
  [[ "$f" == *.gpg || "$f" == *.tar ]] && continue
  FILES_TO_ARCHIVE+=("$f")
done

if [ ${#FILES_TO_ARCHIVE[@]} -eq 0 ]; then
  echo "⚠️ 沒有可封存的檔案！"
  exit 1
fi

# 列出打包檔案
echo "🔍 準備打包下列檔案:"
for f in "${FILES_TO_ARCHIVE[@]}"; do
  echo "  - $f"
done

# 打包
echo "📁 打包中: $ARCHIVE_NAME"
tar -cf "$ARCHIVE_NAME" "${FILES_TO_ARCHIVE[@]}"
ls -lh "$ARCHIVE_NAME"

# 輸入密碼
echo -n "🔐 請輸入加密密碼："
read -s PASSWORD

echo

# 加密
echo "⛓️ GPG AES256 加密中..."
echo "$PASSWORD" | gpg --symmetric --cipher-algo AES256 --batch --yes --passphrase-fd 0 "$ARCHIVE_NAME" || {
  echo "❌ gpg 加密失敗！原始檔案已保留。"
  rm "$ARCHIVE_NAME"
  exit 1
}

# 刪除原 tar 檔 & 原檔案
rm "$ARCHIVE_NAME"
echo "♻️ 準備刪除原檔案..."
for f in "${FILES_TO_ARCHIVE[@]}"; do
  echo "  - $f"
  rm -rf "$f"
done

# 完成
ls -lh "$ENCRYPTED_NAME"
echo "✅ 完成密島存檔: $ENCRYPTED_NAME"
echo "📅 備份日期: $DATE"
echo "🏡 位置: $(pwd)/$ENCRYPTED_NAME"
echo "✨ 請加以護理你的密碼。這是唯一的解密方式！"

echo "🚀 工具執行完畢。"
