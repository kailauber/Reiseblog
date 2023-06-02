for imageDir in ../public/images/*; do
  if compgen -G "${imageDir}/original.*" > /dev/null; then
    echo "[INFO] Found original file in $imageDir."
    echo "[INFO] Converting and scaling to webp 2160p..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=-1:2160 ./"$imageDir"/converted_2160p.webp
    echo "[INFO] Done"
    echo "[INFO] Converting and scaling to webp 1440p..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=-1:1440 ./"$imageDir"/converted_1440p.webp
    echo "[INFO] Done"
    echo "[INFO] Converting and scaling to webp 1080p..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=-1:1080 ./"$imageDir"/converted_1080p.webp
    echo "[INFO] Done"
    echo "[INFO] Converting and scaling to webp 720p..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=-1:720 ./"$imageDir"/converted_720p.webp
    echo "[INFO] Done"
    echo "[INFO] Converting and scaling to webp 480p..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=-1:480 ./"$imageDir"/converted_480p.webp
    echo "[INFO] Done"
    echo "[INFO] Creating thumbnails..."
    echo "[INFO] 400:300..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=400:300 ./"$imageDir"/converted_400x300p.webp
    echo "[INFO] Done"
    echo "[INFO] 800:600..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=800:600 ./"$imageDir"/converted_800x600p.webp
    echo "[INFO] Done"
    echo "[INFO] Thumbnails created"
  else
    echo "[Warning] $imageDir does not contain an original file!"
  fi
done
# TODO: Remove duplication
for imageDir in ../public/abstract/images/*; do
  if compgen -G "${imageDir}/original.*" > /dev/null; then
    echo "[INFO] Found original file in $imageDir."
    echo "[INFO] Converting and scaling to webp 2160p..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=-1:2160 ./"$imageDir"/converted_2160p.webp
    echo "[INFO] Done"
    echo "[INFO] Converting and scaling to webp 1440p..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=-1:1440 ./"$imageDir"/converted_1440p.webp
    echo "[INFO] Done"
    echo "[INFO] Converting and scaling to webp 1080p..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=-1:1080 ./"$imageDir"/converted_1080p.webp
    echo "[INFO] Done"
    echo "[INFO] Converting and scaling to webp 720p..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=-1:720 ./"$imageDir"/converted_720p.webp
    echo "[INFO] Done"
    echo "[INFO] Converting and scaling to webp 480p..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=-1:480 ./"$imageDir"/converted_480p.webp
    echo "[INFO] Done"
    echo "[INFO] Creating thumbnails..."
    echo "[INFO] 400:300..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=400:300 ./"$imageDir"/converted_400x300p.webp
    echo "[INFO] Done"
    echo "[INFO] 800:600..."
    ffmpeg -y -i ./"$imageDir"/original.* -c:v libwebp -loop 0 -vf scale=800:600 ./"$imageDir"/converted_800x600p.webp
    echo "[INFO] Done"
    echo "[INFO] Thumbnails created"
  else
    echo "[Warning] $imageDir does not contain an original file!"
  fi
done