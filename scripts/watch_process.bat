@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM RaveX Live Wallpaper Loop Maker - Watch Mode
REM ============================================================
REM Place MP4 files in WATCH\
REM Processed 3-hour videos are written to FINAL\
REM FFmpeg executable is expected at bin\ffmpeg.exe
REM ============================================================

set "PROJECT_ROOT=%~dp0.."
set "ffmpeg=%PROJECT_ROOT%\bin\ffmpeg.exe"
set "ffprobe=%PROJECT_ROOT%\bin\ffprobe.exe"
set "watchfolder=%PROJECT_ROOT%\WATCH"
set "outputfolder=%PROJECT_ROOT%\FINAL"
set "target_duration=10800"
set "default_repeats=2200"

if not exist "%ffmpeg%" (
    echo.
    echo [ERROR] FFmpeg was not found:
    echo %ffmpeg%
    echo.
    echo Download a compatible Windows FFmpeg build and place ffmpeg.exe in:
    echo %PROJECT_ROOT%\bin\
    echo.
    pause
    exit /b 1
)

if not exist "%watchfolder%" mkdir "%watchfolder%"
if not exist "%outputfolder%" mkdir "%outputfolder%"

echo ==========================================
echo RAVEX LIVE WALLPAPER LOOP MAKER
echo WATCH MODE - 3 HOUR OUTPUT
echo ==========================================
echo.
echo Put MP4 files in:
echo %watchfolder%
echo.
echo Output will appear in:
echo %outputfolder%
echo.
echo Target duration: 10800 seconds (3 hours)
echo.

:loop
echo [%date% %time%] Checking for MP4 files...

dir "%watchfolder%\*.mp4" /b >nul 2>&1

if errorlevel 1 (
    echo No MP4 found, waiting...
    timeout /t 3 /nobreak >nul
    goto loop
)

for %%f in ("%watchfolder%\*.mp4") do (
    if exist "%%f" (
        echo.
        echo Found file: %%~nxf

        set "name=%%~nf"
        set "input=%%f"
        set "output=%outputfolder%\!name!.mp4"
        set "listfile=%TEMP%\ravex_ffmpeg_list_!RANDOM!.txt"

        echo Processing: !name!.mp4
        echo Creating 3-hour loop...

        REM ---- Work out how many times the clip must repeat ----
        REM Uses ffprobe (if present in bin\) to read the real clip
        REM length, so short clips still reach the full target
        REM duration. Falls back to a safe fixed count otherwise.
        set "repeats=%default_repeats%"
        set "rawduration="
        if exist "%ffprobe%" (
            for /f "usebackq delims=" %%p in (`"%ffprobe%" -v error -show_entries format=duration -of csv=p=0 "%%f" 2^>nul`) do set "rawduration=%%p"
        )

        if defined rawduration (
            set "whole="
            set "frac="
            for /f "tokens=1,2 delims=." %%a in ("!rawduration!") do (
                set "whole=%%a"
                set "frac=%%b"
            )
            if not defined whole set "whole=0"
            set "frac1=!frac:~0,1!"
            if not defined frac1 set "frac1=0"
            set "duration_x10="
            set /a "duration_x10=(whole*10)+frac1" >nul 2>&1
            if defined duration_x10 if !duration_x10! GTR 0 (
                set /a "repeats=(target_duration*10)/duration_x10 + 2"
            )
        )

        echo Clip repeats needed: !repeats!

        >"!listfile!" (
            for /L %%i in (1,1,!repeats!) do echo file '%%f'
        )

        "%ffmpeg%" -y -safe 0 -f concat -i "!listfile!" -c copy -t !target_duration! "!output!"

        set "ffmpeg_exit=!ERRORLEVEL!"
        del /q "!listfile!" >nul 2>&1

        if "!ffmpeg_exit!"=="0" (
            echo.
            echo [SUCCESS] Created:
            echo !output!
            del /q "!input!" >nul 2>&1
        ) else (
            echo.
            echo [ERROR] FFmpeg failed with exit code !ffmpeg_exit!
            echo Input file was NOT deleted.
        )

        echo.
        echo Waiting for next file...
    )
)

goto loop
