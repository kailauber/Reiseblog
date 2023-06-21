mkdir -p large-retina
for img in $(ls *.jpg); do
    ffmpeg.exe -i "$img" -vf "scale=iw*2:ih*2" "large-retina/$img"
done
