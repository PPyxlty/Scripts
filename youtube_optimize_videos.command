#!/bin/bash

# 🎥 youtube_optimize_videos.command
# 功能：將腳本所在資料夾及所有子資料夾內影片轉為 YouTube 最適化格式（H.264 + AAC）

cd "$(dirname "$0")" || exit

echo "🔄 開始轉換所有影片為 YouTube 最適化格式（包含子資料夾）..."

# 支援副檔名
exts=("mp4" "mov" "mkv")

for ext in "${exts[@]}"; do
  find . -type f -iname "*.${ext}" | while read -r file; do
    output="${file%.*}_yt.mp4"
    echo "🎬 處理影片：$file"
    ffmpeg -nostdin -y -i "$file" \
      -c:v libx264 -preset slow -crf 21 \
      -c:a aac -b:a 128k \
      "$output"
    echo "✅ 完成：$output"
    echo "-----------------------------------"
  done
done

echo "🎉 所有影片已轉換完成！"
exit 0