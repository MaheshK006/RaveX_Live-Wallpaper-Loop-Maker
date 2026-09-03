# GitHub Upload Checklist

1. Keep `bin/ffmpeg.exe` out of Git.
2. Keep large input/output videos out of Git.
3. Run:

```bash
git init
git branch -M main
git add .
git status
git commit -m "Initial release"
git remote add origin https://github.com/YOUR_USERNAME/RaveX_Live-Wallpaper-Loop-Maker.git
git push -u origin main
```

4. Confirm that no FFmpeg executable or large video is shown as staged.
