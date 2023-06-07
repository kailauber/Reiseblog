#!/bin/bash

# Set the working directory to the script's directory
cd "$(dirname "$0")"

# Log file
log_file="conversion.log"

# Redirect all console output to log file
exec > "$log_file" 2>&1

# Check programs
if [ -z "$(which ffmpeg)" ]; then
    echo "Error: ffmpeg is not installed"
    exit 1
fi

if [ -z "$(which MP4Box)" ]; then
    echo "Error: MP4Box is not installed"
    exit 1
fi

# Find all MP4 files in the current folder and subfolders
TARGET_FILES=$(find ./ -type f -name "*.mp4")

# Loop through each MP4 file
for f in $TARGET_FILES
do
    fe=$(basename "$f") # Full name of the file
    f="${fe%.*}" # Name without extension

    if [ ! -d "${f}" ]; then # If directory does not exist, convert
        echo "Converting \"$f\" to multi-bitrate video in MPEG-DASH"

        mkdir "${f}"

        ffmpeg -y -i "${fe}" -c:a aac -b:a 192k -vn "${f}/${f}_audio.m4a"

        ffmpeg -y -i "${fe}" -preset slow -tune film -vsync passthrough -an -c:v libx264 -x264opts 'keyint=25:min-keyint=25:no-scenecut' -crf 22 -maxrate 5000k -bufsize 12000k -pix_fmt yuv420p -f mp4 "${f}/${f}_5000.mp4"
        ffmpeg -y -i "${fe}" -preset slow -tune film -vsync passthrough -an -c:v libx264 -x264opts 'keyint=25:min-keyint=25:no-scenecut' -crf 23 -maxrate 3000k -bufsize 6000k -pix_fmt yuv420p -f mp4  "${f}/${f}_3000.mp4"
        ffmpeg -y -i "${fe}" -preset slow -tune film -vsync passthrough -an -c:v libx264 -x264opts 'keyint=25:min-keyint=25:no-scenecut' -crf 23 -maxrate 1500k -bufsize 3000k -pix_fmt yuv420p -f mp4   "${f}/${f}_1500.mp4"
        ffmpeg -y -i "${fe}" -preset slow -tune film -vsync passthrough -an -c:v libx264 -x264opts 'keyint=25:min-keyint=25:no-scenecut' -crf 23 -maxrate 800k -bufsize 2000k -pix_fmt yuv420p -vf "scale=-2:720" -f mp4  "${f}/${f}_800.mp4"
        ffmpeg -y -i "${fe}" -preset slow -tune film -vsync passthrough -an -c:v libx264 -x264opts 'keyint=25:min-keyint=25:no-scenecut' -crf 23 -maxrate 400k -bufsize 1000k -pix_fmt yuv420p -vf "scale=-2:540" -f mp4  "${f}/${f}_400.mp4"

        # If audio stream exists, include it in MP4Box command
        if [ -e "${f}/${f}_audio.m4a" ]; then
            MP4Box -dash 2000 -rap -frag-rap -bs-switching no -profile "dashavc264:live" "${f}/${f}_5000.mp4" "${f}/${f}_3000.mp4" "${f}/${f}_1500.mp4" "${f}/${f}_800.mp4" "${f}/${f}_400.mp4" "${f}/${f}_audio.m4a" -out "${f}/${f}.mpd"
            rm "${f}/${f}_audio.m4a"
        else
            MP4Box -dash 2000 -rap -frag-rap -bs-switching no -profile "dashavc264:live" "${f}/${f}_5000.mp4" "${f}/${f}_3000.mp4" "${f}/${f}_1500.mp4" "${f}/${f}_800.mp4" "${f}/${f}_400.mp4" -out "${f}/${f}.mpd"
        fi

        # Create a poster image
        ffmpeg -i "${fe}" -ss 00:00:00 -vframes 1 -qscale:v 10 -n -f image2 "${f}/${f}.jpg"
    fi

done
