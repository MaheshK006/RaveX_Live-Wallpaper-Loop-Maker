@echo off
setlocal enabledelayedexpansion

set "ffmpeg=E:\MyVideoProcessor\ffmpeg.exe"
set "watchfolder=E:\MyVideoProcessor\WATCH"
set "outputfolder=E:\MyVideoProcessor\FINAL"

rem 8500 seconds = 2.5 hours
set target_duration=8500

echo ==========================================
echo LIVE WALLPAPER LOOP MAKER - WATCH MODE
echo Put MP4 files in WATCH folder and wait...
echo Output will appear in FINAL folder
echo ==========================================
echo.

:loop
echo Checking for MP4 files...
dir "%watchfolder%\*.mp4" /b >nul 2>&1

if errorlevel 1 (
    echo No MP4 found, waiting...
    timeout /t 3 >nul
    goto loop
)

for %%f in ("%watchfolder%\*.mp4") do (
    echo Found file: %%~nxf

    set "name=%%~nf"
    set "input=%%f"
    set "output=%outputfolder%\!name!.mp4"

    echo Processing: !name!.mp4 ...

    rem Generate list for looping
    >list.txt (
        for /L %%i in (1,1,2200) do echo file '!input!'
    )

    "%ffmpeg%" -y -safe 0 -f concat -i list.txt -c copy -t !target_duration! "!output!"

    del list.txt
    del "!input!"

    echo Done: !output!
    echo Waiting for next file...
)

goto loop
