#!/bin/bash

# 切換到腳本所在位置（保證輸出影片會存在這個資料夾）
cd "$(dirname "$0")"

echo "🎉 Wistia HTML 影片下載器（支援連續貼 HTML）"
echo "🔁 每次貼上影片 HTML 或網址後，會自動擷取並下載 1080p 影片"
echo "❌ 輸入 q 或直接按 Enter 可離開"
echo
#迴圈
while true; do
  # 提示輸入
  echo "👉 請貼上 HTML / 網址（包含 ?wvideo=xxxxx）："
  read INPUT

  # 離開條件
  if [[ -z "$INPUT" || "$INPUT" == "q" ]]; then
    echo "👋 結束下載器，掰掰～"
    break
  fi

  # 擷取 wvideo ID
  VIDEO_ID=$(echo "$INPUT" | sed -n 's/.*wvideo=\([^&"]*\).*/\1/p')

  # 判斷是否成功擷取
  if [ -z "$VIDEO_ID" ]; then
    echo "⚠️ 沒有找到有效的影片 ID，請重新檢查輸入格式。"
    continue
  fi

  # 組成下載網址與檔名（下載到目前目錄）
  VIDEO_URL="https://fast.wistia.net/embed/iframe/$VIDEO_ID"
  OUTPUT_TEMPLATE="./%(title)s-%(id)s.%(ext)s"

  echo "🎬 影片 ID：$VIDEO_ID"
  echo "🌐 來源：$VIDEO_URL"
  echo "⬇️ 開始下載..."

  # 執行下載
  yt-dlp \
    --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)" \
    -f "bestvideo[height=1080]+bestaudio/best[height=1080]" \
    -o "$OUTPUT_TEMPLATE" \
    "$VIDEO_URL"

  echo "✅ 下載完成！影片已存到目前資料夾。"
  echo "------------------------------------------"
done
