@echo off
setlocal enabledelayedexpansion

:: === CONFIGURATION ===
set FONT="Noto Nastaliq Urdu"
set OUTPUT_DIR=images
set TRAINING_TEXT_DIR=training_text
set BOX_DIR=box_files
set UNICHARSET_DIR=unicharset
set LSTMF_DIR=lstmf

:: Ensure required directories exist
if not exist %OUTPUT_DIR% mkdir %OUTPUT_DIR%
if not exist %BOX_DIR% mkdir %BOX_DIR%
if not exist %UNICHARSET_DIR% mkdir %UNICHARSET_DIR%
if not exist %LSTMF_DIR% mkdir %LSTMF_DIR%

:: === Process Each Character ===
for %%f in (%TRAINING_TEXT_DIR%\*.txt) do (
  set FILENAME=%%~nf
  set OUTPUT_BASE=%OUTPUT_DIR%\!FILENAME!
  set BOX_FILE=%BOX_DIR%\!FILENAME!.box
  set LSTMF_FILE=%LSTMF_DIR%\!FILENAME!.lstmf

  echo [1] Generating training image and box file for !FILENAME!...
  text2image ^
    --text=%%f ^
    --outputbase=!OUTPUT_BASE! ^
    --font=%FONT% ^
    --fonts_dir=C:\Windows\Fonts ^
    --ptsize=32 ^
    --writing_mode=horizontal

  if not exist !BOX_FILE! (
    echo [ERROR] Box file not generated for !FILENAME!. Skipping...
    exit /b
  )

  echo [2] Extracting unicharset for !FILENAME!...
  unicharset_extractor ^
    --output_unicharset %UNICHARSET_DIR%\unicharset ^
    !BOX_FILE!

  echo [3] Generating LSTM training file for !FILENAME!...
  tesseract ^
    !OUTPUT_BASE!.tif ^
    !LSTMF_FILE! ^
    --psm 6 ^
    lstm.train

  if not exist !LSTMF_FILE! (
    echo [ERROR] LSTM training file not generated for !FILENAME!. Skipping...
    exit /b
  )
)

echo [✓] Character-wise raw data processing complete!
pause