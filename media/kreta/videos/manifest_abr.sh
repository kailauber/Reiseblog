#!/bin/bash

# The original video file
INPUT="landung_final.mp4"
OUTPUT="landung"

# Define an array of resolutions
declare -a RESOLUTIONS=("360x640" "540x960" "720x1280")

# Loop over each resolution and create an encoded video file
for RES in "${RESOLUTIONS[@]}"
do
    ffmpeg -i $INPUT -vf scale=$RES -c:v libx264 -b:v 1M -c:a aac $OUTPUT"_$RES".mp4
done

# Segment with MP4Box and create the DASH manifest
MP4Box -dash 5000 -rap -frag-rap -bs-switching no -profile dashavc264:live \
-out manifest.mpd $OUTPUT"_${RESOLUTIONS[0]}".mp4 \
$urlf:$OUTPUT"_${RESOLUTIONS[1]}".mp4 \
$urlf:$OUTPUT"_${RESOLUTIONS[2]}".mp4
