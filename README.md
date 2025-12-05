# 🎬 Live Wallpaper Loop Maker — Watch Mode

Automatically converts short MP4 live wallpapers into long seamless loop videos (2–4 hours) optimized for YouTube uploads.

This tool watches the **WATCH** folder and continuously processes any new video placed inside it.  
Output files are generated inside the **FINAL** folder automatically.

---

## ✨ Features

- Seamless looping of MP4 live wallpapers
- Auto-detection of new input files (Watch mode)
- Output duration target 2:35h – 3:45h
- High-quality preservation
- Suitable for long YouTube wallpaper uploads
- Fully automated — no manual looping required

---

## 📂 Folder Structure

Live-Wallpaper-Loop-Maker/
├── WATCH/ # Put input MP4 files here
├── FINAL/ # Processed final output is saved here
└── loop.sh # Looping script (auto run)


---

## 🛠 How to Use

### Windows / Mac / Linux

1. Place your `.mp4` video into the **WATCH** folder
2. The script will automatically:
   - Detect the file
   - Loop it until total length reaches 2:35–3:45 hours
   - Save output as `.mp4` inside **FINAL**
3. Upload the generated file to YouTube 😎

---

## 📌 Requirements

- FFmpeg installed (latest version recommended)
- Bash supported terminal (WSL / Linux / macOS / Git Bash / Termux)

---

## 🚀 Use Case Examples

- YouTube long live wallpapers
- Anime / Gaming / Scenic loop backgrounds
- PC wallpaper engine looping sources

---

## 💡 Example Command (manual run)

ffmpeg -stream_loop -1 -i input.mp4 -t 14400 -c copy output.mp4


---

## 🤝 Contributing

Pull requests and suggestions are welcome!  
Feel free to fork the project and improve it.

---

## 📝 License

MIT License — Free for personal & commercial use.

---

## 🌟 Author

Created by Mahesh  
🔗 YouTube Automation & Live Wallpaper Production Tools
