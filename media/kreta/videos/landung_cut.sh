#!/bin/bash

# Define the input file
input="landung.mp4"

# Cut the first 15 seconds
ffmpeg.exe -i $input -ss 00:00:00 -to 00:00:15 -c copy output1.mp4

# Cut the last 15 seconds
ffmpeg.exe -i $input -ss 00:02:28 -to 00:02:43 -c copy output2.mp4

# Prepare the list of files to concatenate
echo -e "file 'output1.mp4'\nfile 'output2.mp4'" > files.txt

# Concatenate the two clips
ffmpeg.exe -f concat -safe 0 -i files.txt -c copy cut_landung.mp4

# Remove temporary files
rm output1.mp4 output2.mp4 files.txt

echo "The final output is saved as cut_landung.mp4"
