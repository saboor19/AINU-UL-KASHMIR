@echo off
setlocal enabledelayedexpansion

:: === CONFIG ===
set FONT="Noto Nastaliq Urdu"
set LANG=kas
set OUTPUTBASE=images\kashmiri
set TRAINING_TEXT=training_text\kashmiri.training_text
set BOXFILE=box_files\kashmiri.box
set UNICHARSET=unicharset\unicharset
set LSTMF=images\kashmiri.lstmf
set LISTFILE=kas.training_files.txt
set TRAINEDDATA=tessdata\kas\kas.traineddata
set MODEL_OUT=output\kas_checkpoint
set FINAL_MODEL=output\kas.traineddata
set BASE_MODEL=tessdata\kas\kas.traineddata

echo [1] Generating training image and box file...
text2image ^
  --text=%TRAINING_TEXT% ^
  --outputbase=%OUTPUTBASE% ^
  --font=%FONT% ^
  --ptsize=32 ^
  --writing_mode=horizontal

if not exist %OUTPUTBASE%.box (
  echo [ERROR] Box file not generated. Exiting...
  exit /b
)

echo [2] Copying box file...
copy %OUTPUTBASE%.box %BOXFILE%

echo [3] Extracting unicharset...
unicharset_extractor %BOXFILE%
move unicharset %UNICHARSET%

echo [4] Generating .lstmf file...
tesseract %OUTPUTBASE%.tif %LANG% --psm 6 lstm.train

if not exist %LSTMF% (
  echo [ERROR] LSTM file not generated. Exiting...
  exit /b
)

echo [5] Creating lstmf list file...
echo %LSTMF% > %LISTFILE%

echo [6] Starting training...
lstmtraining ^
  --model_output %MODEL_OUT% ^
  --continue_from %BASE_MODEL% ^
  --traineddata %TRAINEDDATA% ^
  --train_listfile %LISTFILE% ^
  --max_iterations 5000

if not exist %MODEL_OUT%_checkpoint (
  echo [ERROR] Training failed. Exiting...
  exit /b
)

echo [7] Stopping training and packaging model...
lstmtraining ^
  --stop_training ^
  --continue_from %MODEL_OUT%_checkpoint ^
  --traineddata %TRAINEDDATA% ^
  --model_output %FINAL_MODEL%

if not exist %FINAL_MODEL% (
  echo [ERROR] Final model not generated. Exiting...
  exit /b
)

echo [✓] Training Complete! Trained data saved as: %FINAL_MODEL%

pause
