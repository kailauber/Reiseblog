import os
import subprocess
import glob

# Create directories if they don't exist
os.makedirs('large', exist_ok=True)
os.makedirs('medium', exist_ok=True)
os.makedirs('small', exist_ok=True)

# Get list of all .jpg files in current directory
images = glob.glob('*.jpg')

for image in images:
    # Create FFmpeg command for each size
    commands = [
        ('large', '1500:2000'),
        ('medium', '1200:1600'),
        ('small', '600:800'),
    ]

    for folder, size in commands:
        output_path = os.path.join(folder, f'{folder}_{image}')
        command = f'ffmpeg.exe -i {image} -vf "crop=iw:ih:(iw-iw)/2:(ih-ih)/2,scale={size}" {output_path}'

        # Call the FFmpeg command
        subprocess.call(command, shell=True)
