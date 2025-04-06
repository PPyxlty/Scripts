# 🛠 從零開始的 Python 開發環境設定（macOS）

這份指南將指導你如何從頭開始在 macOS 上設定一個完整的 Python 開發環境。包含安裝 **Homebrew**、**Python**、**pip** 及相關工具。

## 1. 安裝 Homebrew（macOS 必備包管理器）

[Homebrew](https://brew.sh/) 是 macOS 上最常用的包管理工具，可以輕鬆安裝各種軟體和庫。

執行以下指令安裝 Homebrew：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

安裝完成後，執行以下指令設定環境變數：

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile
```

## 2. 安裝 Python（pyenv 管理版本）

### 安裝 pyenv

[pyenv](https://github.com/pyenv/pyenv) 是一個 Python 版本管理工具，可以讓你在不同版本的 Python 之間輕鬆切換。

安裝 pyenv：

```bash
brew install pyenv
```

在你的 `~/.zshrc`（或 `~/.bash_profile`）中加入以下設定：

```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
```

重新載入 shell 配置：

```bash
source ~/.zshrc
```

### 安裝並設為默認 Python 版本

安裝你想要的 Python 版本，並設置為默認：

```bash
pyenv install 3.11.8
pyenv global 3.11.8
```

## 3. 安裝 pip（Python 套件管理工具）

pip 是 Python 的套件管理工具，用來安裝和管理 Python 套件。

安裝後可以檢查 pip 版本：

```bash
python -m ensurepip --upgrade
pip --version
```

## 4. 安裝虛擬環境管理工具（venv）

`venv` 是 Python 用來建立虛擬環境的標準工具。虛擬環境讓你可以在同一台電腦上，為不同的專案建立不同的 Python 環境和依賴。

建立虛擬環境：

```bash
python -m venv myenv
```

激活虛擬環境：

```bash
source myenv/bin/activate
```

此時，你會看到提示符變為 `(myenv)`，表示虛擬環境已經啟動。

## 5. 安裝所需的 Python 套件（例如 selenium, python-dotenv）

建立好虛擬環境後，你可以開始安裝所需的套件。例如，安裝 `selenium` 和 `python-dotenv`：

```bash
pip install selenium python-dotenv
```

## 6. 安裝其他開發工具（CLI）

### 安裝 yt-dlp（影片下載工具）

[yt-dlp](https://github.com/yt-dlp/yt-dlp) 是一個更強大的 `youtube-dl` 替代品，可以用來下載影片和音樂。

安裝 `yt-dlp`：

```bash
pip install yt-dlp
```

或者如果你想要安裝命令行工具版本（更方便使用）：

```bash
brew install yt-dlp
```

### 安裝 ffmpeg（影片處理工具）

[ffmpeg](https://ffmpeg.org/) 是一個強大的多媒體處理工具，能夠處理視頻、音頻等格式轉換。

安裝 `ffmpeg`：

```bash
brew install ffmpeg
```

## 7. 確認所有工具都安裝成功

### 確認 Python 版本：

```bash
python --version
# 預期：Python 3.11.8
```

### 確認 pip 版本：

```bash
pip --version
# 預期：pip 21.3.1 或更新版本
```

### 確認 yt-dlp 版本：

```bash
yt-dlp --version
# 預期：yt-dlp 版本號
```

### 確認 ffmpeg 是否安裝成功：

```bash
ffmpeg -version
# 預期：ffmpeg 版本號
```

---

## 💡 附加建議

1. **使用 `requirements.txt` 管理依賴**：將所有依賴列在 `requirements.txt` 中，讓團隊更方便安裝依賴。

   ```bash
   pip freeze > requirements.txt
   ```

2. **使用 `.gitignore` 忽略虛擬環境**：確保你的虛擬環境不會被推送到 GitHub 等版本控制系統。

   ```
   .env
   .whisper-env
   venv/
   ```

---

這樣，你的 macOS 就設置好了完整的 Python 開發環境，並且可以隨時開始開發或執行腳本！🚀

