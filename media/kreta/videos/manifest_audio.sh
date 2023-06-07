#!/bin/bash

# The original video file
VIDEO="ostern_original.mp4"

# The audio tracks
AUDIO1="ostern_audio.mp3"
AUDIO2="ostern_audio2.mp3"

# Convert video to DASH compatible format
ffmpeg -i $VIDEO -c:v libx264 -profile:v main -bf 1 -b_strategy 0 -sc_threshold 0 -c:a aac -f mp4 -movflags frag_keyframe+empty_moov $VIDEO.mpd

# Convert audio to DASH compatible format
ffmpeg -i $AUDIO1 -c:a aac -b:a 128k -vn $AUDIO1.mpd
ffmpeg -i $AUDIO2 -c:a aac -b:a 128k -vn $AUDIO2.mpd

# Segment with MP4Box
MP4Box -dash 5000 -rap -frag-rap -profile dashavc264:onDemand -out manifest.mpd $VIDEO.mpd $AUDIO1.mpd $AUDIO2.mpd
