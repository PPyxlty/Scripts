#!/bin/bash

# 讓腳本在自己的資料夾裡執行
cd "$(dirname "$0")"

# 讀取使用者輸入秒數
echo "⏱ 請輸入要裁剪掉的秒數（例如：10）："
read seconds

# 若未輸入則結束
if [[ -z "$seconds" ]]; then
  echo "⚠️ 沒有輸入秒數，結束腳本。"
  sleep 1
  exit 0
fi

echo "✂️ 即將裁剪每部影片前 $seconds 秒，並覆蓋原始檔案..."

# 處理所有 mp4、mov 檔案
for ext in mp4 MP4 mov MOV; do
  for file in *.$ext; do
    [[ -e "$file" ]] || continue

    temp="._trim_temp_${file}"
    echo "📁 處理影片：$file"

    # 裁剪影片
    ffmpeg -y -ss "$seconds" -i "$file" -c copy "$temp"

    if [[ -f "$temp" ]]; then
      mv "$temp" "$file"
      echo "✅ 已覆蓋：$file"
    else
      echo "❌ 失敗：$file"
    fi
  done
done

echo "🎉 所有影片處理完成，視窗即將關閉..."
sleep 1
exit 0
