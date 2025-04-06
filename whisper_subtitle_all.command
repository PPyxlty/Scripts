#!/bin/bash

# whisper_subtitle_all.command
# 丟進任何資料夾即可處理所有影片產生字幕（含音訊壓縮）

cd "$(dirname "$0")" || exit

# 1. 建立/使用虛擬環境
ENV_NAME=".whisper-env"
if [ ! -d "$ENV_NAME" ]; then
  echo "🌱 建立虛擬環境..."
  python3 -m venv "$ENV_NAME"
fi
source "$ENV_NAME/bin/activate"

# 2. 安裝必要套件（如未安裝）
python3 -m pip install --upgrade pip >/dev/null 2>&1
pip show openai >/dev/null 2>&1 || pip install openai

# 3. 檢查 API KEY：儲存在 ~/.whisper_key
if [ ! -f "$HOME/.whisper_key" ]; then
  echo "🔑 請輸入你的 OpenAI API 金鑰（只需輸入一次）："
  read -r KEY
  echo "$KEY" > "$HOME/.whisper_key"
fi
# shellcheck disable=SC2155
export OPENAI_API_KEY=$(cat "$HOME/.whisper_key")

# 4. 找出所有影片，開始處理
exts=("mp4" "mov" "mkv")
echo "🎬 開始處理影片..."
for ext in "${exts[@]}"; do
  find . -type f -name "*.${ext}" | while read -r file; do
    base="${file%.*}"
    audio_wav="${base}.wav"
    audio_mp3="${base}.mp3"
    srt="${base}.srt"

    echo "🎧 擷取音訊：$file → .wav"
    ffmpeg -nostdin -y -i "$file" -ar 16000 -ac 1 -c:a pcm_s16le "$audio_wav"

    echo "🔄 壓縮音訊為 mp3（降低檔案大小）"
    ffmpeg -nostdin -y -i "$audio_wav" -ar 16000 -ac 1 -b:a 64k "$audio_mp3"

    echo "☁️ 上傳 Whisper 處理中..."
    response=$(curl -s https://api.openai.com/v1/audio/transcriptions \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -H "Content-Type: multipart/form-data" \
      -F file=@"$audio_mp3" \
      -F model=whisper-1 \
      -F response_format=srt)

    echo "$response" > "$srt"
    echo "✅ 字幕完成：$srt"
    rm "$audio_wav" "$audio_mp3"
  done
  echo "----------------------------"
done

echo "🎉 所有影片處理完成！"
exit 0
