#!/bin/bash



# Scale and move images to respective directories
for j in *.png
do
    filename=$(basename -- "$j")
    ffmpeg.exe -i "$j" -vf scale=800:-1 "Small-${filename}"
    ffmpeg.exe -i "$j" -vf scale=1200:-1 "Medium-${filename}"
    ffmpeg.exe -i "$j" -vf scale=1500:-1 "Large-${filename}"
done
