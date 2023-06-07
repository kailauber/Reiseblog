#!/bin/bash

# Input MP4 file and output MPD file names
input_file="ostern_final.mp4"
output_mpd="output.mpd"

# Temporary directory for storing encoded audio files
temp_dir="temp_audio"

# Create temporary directory if it doesn't exist
mkdir -p "$temp_dir"

# Extract selected audio channels as separate audio files
ffmpeg -i "$input_file" -map 0:1 -c:a copy "$temp_dir/audio1.mp4"
ffmpeg -i "$input_file" -map 0:2 -c:a copy "$temp_dir/audio2.mp4"

# Generate audio segment files for each audio channel
mp4box -dash 1000 -frag 1000 -rap -profile "dashavc264:live" -bs-switching no -out "$temp_dir/audio1_dash.mpd" "$temp_dir/audio1.mp4"
mp4box -dash 1000 -frag 1000 -rap -profile "dashavc264:live" -bs-switching no -out "$temp_dir/audio2_dash.mpd" "$temp_dir/audio2.mp4"

# Merge the generated MPD files
mp4box -dash 1000 -rap -profile "dashavc264:live" -bs-switching no -out "$output_mpd" "$temp_dir/audio1_dash.mpd" "$temp_dir/audio2_dash.mpd"

# Cleanup temporary directory
rm -rf "$temp_dir"
