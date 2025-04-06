#!/bin/bash

# 🌐 universal_video_downloader.command
# 支援 YouTube、Wistia、Vimeo、Bilibili 等網站影片/播放清單下載
# 自動依平台推薦格式（不超過 1080p）、字幕、播放清單下載、互動選單等

cd "$(dirname "$0")" || exit

echo "🎯 請貼上影片或播放清單網址（支援各大平台）："
read -r VIDEO_URL
VIDEO_URL=$(echo "$VIDEO_URL" | tr -d '\r' | xargs)

if [[ -z "$VIDEO_URL" ]]; then
  echo "❗ 未輸入有效網址，結束腳本。"
  exit 1
fi

# 🔍 推薦格式依平台選擇（限制最高 1080p）
case "$VIDEO_URL" in
  *youtube.com*|*youtu.be*)
    FORMAT="-f 'bestvideo[height<=1080]+bestaudio'"
    ;;
  *wistia.com*|*wistia.net*)
    FORMAT="-f 'best[ext=mp4][height<=1080]'"
    ;;
  *xvideos.com*)
    FORMAT="-f 'best[height<=1080]' --merge-output-format mp4"
    ;;
  *)
    FORMAT="-f 'best[height<=1080]'"
    ;;
esac

# 🧠 嘗試判斷是否為播放清單
IS_PLAYLIST=$(yt-dlp --no-warnings --skip-download --print-json "$VIDEO_URL" | jq -r '.playlist_count // empty')

# 🎛 使用者互動選單
if [[ -n "$IS_PLAYLIST" ]]; then
  echo "🔗 偵測到播放清單，共 $IS_PLAYLIST 支影片"
  echo "選擇你想下載的方式："
  echo "1️⃣ 全部下載"
  echo "2️⃣ 下載特定範圍（例如第 3 到 7 支）"
  echo "3️⃣ 只下載第一支影片"
  read -p "請輸入 1 / 2 / 3: " MODE
  case $MODE in
    1)
      RANGE=""
      ;;
    2)
      read -p "請輸入開始編號：" START
      read -p "請輸入結束編號：" END
      RANGE="--playlist-start $START --playlist-end $END"
      ;;
    3)
      RANGE="--playlist-items 1"
      ;;
    *)
      echo "⚠️ 無效選項，預設下載第一支影片"
      RANGE="--playlist-items 1"
      ;;
  esac
else
  RANGE=""
fi

# ⚙️ 設定輸出模板：包含播放清單排序（如有）
OUTPUT_TEMPLATE="./%(playlist_index)s-%(title).100s-%(id)s.%(ext)s"

# ⏬ 執行影片下載
echo "📥 開始下載影片..."
eval yt-dlp \
  --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X)" \
  "$FORMAT" \
  -o "$OUTPUT_TEMPLATE" \
  --merge-output-format mp4 \
  --write-sub --write-auto-sub --sub-lang "en,zh-Hant,zh" \
  --convert-subs srt \
  "$RANGE" \
  "$VIDEO_URL"

# ✅ 顯示結果
if [[ $? -eq 0 ]]; then
  echo "✅ 影片下載完成，已存至目前資料夾。"
else
  echo "❌ 下載失敗，請檢查網址或網路連線。"
fi

read -p "🔚 按 Enter 關閉視窗..."
echo "🎉 完成！"
exit 0