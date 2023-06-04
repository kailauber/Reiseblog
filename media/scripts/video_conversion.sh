original_path=$(pwd)

for videoDir in ../media/kreta/videos*; do
  cd "$original_path"
  if compgen -G "${videoDir}/original.*" > /dev/null; then
    echo "[INFO] Found original file in $videoDir."
    cd "$videoDir"

    echo "[INFO] Converting to webm..."
    ffmpeg -y -i original.* -c:v libvpx-vp9 -keyint_min 150 \
      -g 150 -tile-columns 4 -frame-parallel 1 -f webm -dash 1 \
      -an -sn -vf scale=-1:480 -b:v 1000k -dash 1 converted_480p.webm \
      -an -sn -vf scale=-1:720 -b:v 1500k -dash 1 converted_720p.webm \
      -an -sn -vf scale=-1:1080 -b:v 2500k -dash 1 converted_1080p.webm \
      -an -sn -b:v 7000k -dash 1 converted_original.webm
    echo "[INFO] Done"
    echo "[INFO] Generating Manifest"
    # if has audio
    if compgen -G "audio.webm" > /dev/null; then
      # if has subtitles
      if compgen -G "subtitles.webm" > /dev/null; then
        # TODO: make work
        ffmpeg -y \
          -f webm_dash_manifest -i converted_480p.webm \
          -f webm_dash_manifest -i converted_720p.webm \
          -f webm_dash_manifest -i converted_1080p.webm \
          -f webm_dash_manifest -i converted_original.webm \
          -f webm_dash_manifest -i audio.webm \
          -f webm_dash_manifest -i subtitles.webm \
          -c copy \
          -map 0 -map 1 -map 2 -map 3 -map 4 -map 5 \
          -f webm_dash_manifest \
          -adaptation_sets "id=0,streams=0,1,2,3 id=1,streams=4 id=2,streams=5" \
          manifest.mpd
        else
          ffmpeg -y \
            -f webm_dash_manifest -i converted_480p.webm \
            -f webm_dash_manifest -i converted_720p.webm \
            -f webm_dash_manifest -i converted_1080p.webm \
            -f webm_dash_manifest -i converted_original.webm \
            -f webm_dash_manifest -i audio.webm \
            -c copy \
            -map 0 -map 1 -map 2 -map 3 -map 4 \
            -f webm_dash_manifest \
            -adaptation_sets "id=0,streams=0,1,2,3 id=1,streams=4" \
            manifest.mpd
        fi
    else
      ffmpeg -y \
        -f webm_dash_manifest -i converted_480p.webm \
        -f webm_dash_manifest -i converted_720p.webm \
        -f webm_dash_manifest -i converted_1080p.webm \
        -f webm_dash_manifest -i converted_original.webm \
        -c copy \
        -map 0 -map 1 -map 2 -map 3 \
        -f webm_dash_manifest \
        -adaptation_sets "id=0,streams=0,1,2,3" \
        manifest.mpd
    fi
    echo "[INFO] Done"
    echo "[INFO] Creating Thumbnails and Animated Thumbnails"
    ffmpeg -n -i original.* -an -ss 3 -c:v libwebp -vf scale=400:300 -frames:v 1 thumbnail_400x300p.webp
    ffmpeg -n -i original.* -an -ss 3 -c:v libwebp -vf scale=800:600 -frames:v 1 thumbnail_800x600p.webp
    ffmpeg -n -i original.* -an -ss 3 -vf scale=400:300 -t 3 thumbnail_animated_400x300p.webm
    ffmpeg -n -i original.* -an -ss 3 -vf scale=800:600 -t 3 thumbnail_animated_800x600p.webm
    echo "[INFO] Done"
  else
    echo "[Warning] $videoDir does not contain an original file!"
  fi
done
