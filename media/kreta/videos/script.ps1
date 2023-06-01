$videos = Get-ChildItem -Path .\ -Filter *.mp4

foreach ($video in $videos) {
    $filename = [IO.Path]::GetFileNameWithoutExtension($video.Name)
    & "C:\Users\lauberk\Documents\Lehre\3. Lehrjahr WH\INFA\M152\ffmpeg\ffmpeg-5.1.2-full_build\bin\ffmpeg.exe" -i $video.FullName -vf "scale=640:-1" "$filename-small.mp4"
    & "C:\Users\lauberk\Documents\Lehre\3. Lehrjahr WH\INFA\M152\ffmpeg\ffmpeg-5.1.2-full_build\bin\ffmpeg.exe" -i $video.FullName -vf "scale=1280:-1" "$filename-medium.mp4"
    & "C:\Users\lauberk\Documents\Lehre\3. Lehrjahr WH\INFA\M152\ffmpeg\ffmpeg-5.1.2-full_build\bin\ffmpeg.exe" -i $video.FullName -vf "scale=1920:-1" "$filename-large.mp4"
}
