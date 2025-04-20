# AINU-UL-KASHMIR
OCR for Kashmiri Language

This project focuses on building a custom OCR model for the Kashmiri language using Tesseract OCR. It involves training a model with custom data, including Kashmiri text and fonts, to improve recognition accuracy.

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [Prerequisites](#prerequisites)
3. [File Structure](#file-structure)
4. [Steps for Training](#steps-for-training)
5. [Common Issues and Fixes](#common-issues-and-fixes)
6. [Testing the Model](#testing-the-model)
7. [Acknowledgments](#acknowledgments)

---

## Project Overview
This project aims to:
- Train a custom Tesseract OCR model for the Kashmiri language.
- Use Kashmiri-specific fonts and text data to improve recognition accuracy.
- Provide a reusable workflow for OCR training and testing.

---

## Prerequisites
Before starting, ensure the following tools and dependencies are installed:
1. **Tesseract OCR** (with training tools like `text2image`, `unicharset_extractor`, and `lstmtraining`).
2. **Python** (optional, for additional scripting or automation).
3. **Fonts**: Kashmiri-specific fonts like `Noto Nastaliq Urdu`.
4. **Training Data**: Text files and corresponding images for Kashmiri text.

---

## File Structure
The project directory is organized as follows:

---

## Steps for Training

### 1. **Prepare Training Text**
- Add representative Kashmiri text to `training_text/kashmiri.training_text`.

### 2. **Generate Training Images**
- Use the `text2image` tool to generate synthetic images from the training text:
  ```cmd
  text2image ^
    --text=training_text\kashmiri.training_text ^
    --outputbase=images\kashmiri ^
    --font="Noto Nastaliq Urdu" ^
    --ptsize=32 ^
    --writing_mode=horizontal
  ```

### 3. **Extract Unicharset**
- Use the `unicharset_extractor` tool to extract the unicharset from the generated box files:
  ```cmd
  unicharset_extractor ^
    --output_unicharset unicharset\unicharset ^
    images\kashmiri.box
  ```

### 4. **Train the Model**
- Use the `tesseract` tool to train the model with the generated images and box files:
  ```cmd
  tesseract images\kashmiri.tif kas --psm 6 lstm.train
  ```

lstmtraining ^
  --model_output output\kas_checkpoint ^
  --continue_from tessdata\kas\kas.traineddata ^
  --traineddata tessdata\kas\kas.traineddata ^
  --train_listfile kas.training_files.txt ^
  --max_iterations 5000

lstmtraining ^
  --stop_training ^
  --continue_from output\kas_checkpoint ^
  --traineddata tessdata\kas\kas.traineddata ^
  --model_output output\kas.traineddata