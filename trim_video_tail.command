#!/bin/bash

# 📁 whisper_tail_trim_all.command
# 丟進任何資料夾，會裁剪所有影片的尾端幾秒（包含子資料夾）

cd "$(dirname "$0")" || exit

# 🔢 互動輸入要裁掉幾秒
read -p "⏱️ 請輸入要裁掉的片尾秒數：" TRIM_SECONDS

if [[ -z "$TRIM_SECONDS" || ! "$TRIM_SECONDS" =~ ^[0-9]+$ ]]; then
  echo "❗ 請輸入有效的整數秒數！"
  exit 1
fi

# 支援影片副檔名
VIDEO_EXTS=("mp4" "mov" "mkv")

echo "🎬 開始處理影片（包含子資料夾）..."
echo

for EXT in "${VIDEO_EXTS[@]}"; do
  find . -type f -iname "*.${EXT}" | while read -r file; do
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file")
    new_duration=$(echo "$duration - $TRIM_SECONDS" | bc)

    if (( $(echo "$new_duration > 0" | bc -l) )); then
      echo "✂️ 裁剪：$file"
      tmp_output="${file%.*}_trim.${file##*.}"
      ffmpeg -nostdin -y -i "$file" -t "$new_duration" -c copy "$tmp_output"
      mv "$tmp_output" "$file"
      echo "✅ 已覆蓋原始檔案"
    else
      echo "⚠️ 影片太短無法裁剪：$file"
    fi
    echo "--------------------------------"
  done
done

echo "🎉 所有影片裁剪完成！"
exit 0