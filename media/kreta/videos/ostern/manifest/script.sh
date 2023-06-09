packager \
  in=ostern_withoutaudio_15sec.mp4,stream=video,init_segment=video_init.mp4,segment_template=video_\$Number\$.mp4 \
  in=ostern_audio.mp4,stream=audio,language=en,init_segment=audio1_init.mp4,segment_template=audio1_\$Number\$.mp4 \
  in=ostern_audio2.mp4,stream=audio,language=de,init_segment=audio2_init.mp4,segment_template=audio2_\$Number\$.mp4 \
  --generate_static_live_mpd --mpd_output manifest.mpd

read -p "Click"
