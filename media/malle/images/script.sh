#!/bin/bash

# Create the directories if they do not exist
mkdir -p small
mkdir -p medium
mkdir -p large

# Scale and move images to respective directories
for j in *.jpg
do
    filename=$(basename -- "$j")
    ffmpeg.exe -i "$j" -vf scale=800:-1 "small/Small-${filename}"
    ffmpeg.exe -i "$j" -vf scale=1200:-1 "medium/Medium-${filename}"
    ffmpeg.exe -i "$j" -vf scale=1500:-1 "large/Large-${filename}"
done
