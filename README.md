# RaveX Live Wallpaper Loop Maker

A Windows-based FFmpeg automation utility that watches a folder for MP4 videos and converts each detected video into a **3-hour continuous loop**.

## About

This tool is what powers the wallpaper loops on my YouTube channel, **RaveX_Wallpapers** — I drop a source clip into `WATCH\`, this script turns it into a seamless multi-hour loop, and that's what gets uploaded.

📺 **[youtube.com/@RaveX_Wallpapers](https://www.youtube.com/@RaveX_Wallpapers)**
Smooth, seamless looping live wallpapers in HD/4K — gaming setups, PC wallpapers, anime aesthetics, and relaxing ambience for studying, focus, or just vibing. No jumps, no cuts, just continuous motion.

If you make loop content too, feel free to use this tool and drop a link back here or credit the channel — always appreciated. Like, comment, and subscribe if these loops are useful to you!

## Features

- Automatic WATCH-folder monitoring
- MP4 detection
- 3-hour output duration (`10800` seconds)
- FFmpeg concat-based looping
- Auto-detects clip length with `ffprobe` (if present) so even short clips repeat enough times to hit the full 3 hours
- Stream copy (`-c copy`) to avoid unnecessary re-encoding
- Automatic output into `FINAL`
- Portable project-relative paths
- Input is removed only after successful processing
- FFmpeg binaries intentionally excluded from Git

## Project Structure

```text
RaveX_Live-Wallpaper-Loop-Maker/
├── .gitignore
├── README.md
├── LICENSE
├── scripts/
│   ├── watch_process.bat
│   └── ...
├── config/
│   └── 3-hour-config.txt
├── bin/
│   └── ffmpeg.exe          <- place locally; not included in Git
├── WATCH/                  <- put source MP4 files here
├── FINAL/                  <- generated 3-hour videos appear here
├── docs/
│   └── watch_process_original.bat
└── third-party/
    └── ffmpeg/
        ├── FFmpeg-BUILD-INFO.txt
        └── FFmpeg-GPL-3.0.txt
```

## Requirements

- Windows
- FFmpeg for Windows
- An MP4 input video
- Sufficient disk space for the generated output
- For GPU-accelerated FFmpeg builds, compatible NVIDIA hardware/drivers may be used where applicable

## FFmpeg Setup

FFmpeg is **not included in this repository** because the executable/build files are third-party binaries and can be large.

1. Obtain a compatible Windows FFmpeg build.
2. Extract it.
3. Place the required executable at:

```text
bin\ffmpeg.exe
```

4. (Recommended) Also copy `ffprobe.exe` from the same build into `bin\`. It ships alongside `ffmpeg.exe` in almost every Windows build. It is optional, but without it the script assumes a fixed repeat count instead of measuring your actual clip length — see "Why ffprobe matters" below.

The project expects:

```text
bin\
├── ffmpeg.exe
└── ffprobe.exe   (optional, recommended)
```

The supplied FFmpeg build information is preserved under:

```text
third-party\ffmpeg\FFmpeg-BUILD-INFO.txt
third-party\ffmpeg\FFmpeg-GPL-3.0.txt
```

Do not claim the third-party FFmpeg binary as your own software. Review the applicable FFmpeg/build license and redistribution terms before redistributing binaries.

## How to Run

### 1. Put FFmpeg in `bin`

```text
bin\
└── ffmpeg.exe
```

### 2. Put a source MP4 in `WATCH`

```text
WATCH\
└── my_wallpaper.mp4
```

### 3. Start the watcher

Double-click:

```text
scripts\watch_process.bat
```

or run it from Command Prompt:

```cmd
scripts\watch_process.bat
```

### 4. Wait for processing

The script detects the MP4 and creates:

```text
FINAL\my_wallpaper.mp4
```

The target duration is:

```text
10800 seconds = 3 hours
```

### 5. After successful processing

The original input is removed from `WATCH`.

If FFmpeg fails, the input is intentionally retained so that it can be investigated and processed again.

## Important Notes

### Why ffprobe matters

The loop is built by repeating your clip N times in a list, then trimming that to exactly 10800 seconds. `N` needs to be big enough that N × (your clip length) is at least 3 hours.

- **With `bin\ffprobe.exe` present:** the script reads the real length of each clip and calculates the exact repeat count needed. Works correctly for clips of any length, short or long.
- **Without `ffprobe.exe`:** the script falls back to a fixed 2200 repeats. That's enough for clips of roughly 5 seconds or longer. If your source clip is shorter than that, the output will fall short of the full 3 hours.

If you only ever use clips longer than ~10 seconds, `ffprobe.exe` is not required. For short clips, add it to `bin\` to be safe.

### Changing the loop length

By default every output video is **10800 seconds (3 hours)**. To change this:

1. Open `scripts\watch_process.bat` in Notepad (or any text editor).
2. Find this line near the top:

```bat
set "target_duration=10800"
```

3. Replace `10800` with the number of seconds you want, and save the file.

Some common values:

| Desired length | Value to use          |
|-----------------|-----------------------|
| 1 hour           | `set "target_duration=3600"`  |
| 2 hours          | `set "target_duration=7200"`  |
| 3 hours (default)| `set "target_duration=10800"` |
| 4 hours          | `set "target_duration=14400"` |
| 8 hours          | `set "target_duration=28800"` |

No other file needs to change — the script recalculates everything else (including how many times to repeat short clips) automatically based on this one value.

### Why FFmpeg binaries are not on GitHub

This repository stores the project scripts, configuration and documentation. Large third-party executable files are deliberately excluded using `.gitignore`.

This keeps the Git repository lightweight and makes the project easier to maintain.

## GitHub Upload

From the project root:

```bash
git init
git branch -M main
git add .
git commit -m "Initial release"
git remote add origin https://github.com/YOUR_USERNAME/RaveX_Live-Wallpaper-Loop-Maker.git
git push -u origin main
```

Before pushing, verify that `bin/ffmpeg.exe` is not staged:

```bash
git status
```

## Technical Approach

The watcher uses FFmpeg's concat demuxer to repeat the source file many times and then limits the resulting stream to the configured duration.

The main processing command is conceptually:

```text
ffmpeg -y -safe 0 -f concat -i <concat-list> -c copy -t 10800 <output>
```

`-c copy` performs stream copying rather than re-encoding, which can significantly reduce processing overhead when the input is compatible.

## Third-Party Software

This project uses FFmpeg.

The repository contains FFmpeg build information supplied with the project materials for attribution/reference. See:

```text
third-party/ffmpeg/
```

## License

The repository's project code and the bundled third-party materials should not be assumed to have the same license.

The file:

```text
third-party/ffmpeg/FFmpeg-GPL-3.0.txt
```

is the GPLv3 license text associated with the supplied FFmpeg build information.

If you want to publish your own project under a specific open-source license, choose and add that license separately after confirming that it is appropriate for your code and dependencies.
