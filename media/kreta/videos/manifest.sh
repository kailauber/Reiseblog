#!/bin/bash

# Variables
input_video="landung.mp4" # your input video file
output_folder="landung" # folder to store output files
output_name="stream" # prefix for output files

echo "Starting script..."

# Create output folder if it doesn't exist
mkdir -p $output_folder || { echo "Error creating directory $output_folder" ; exit 1; }

echo "Directory created. Encoding video at different bitrates..."

# Bitrates for adaptive streaming
bitrates=(500k 1000k 1500k)

# Loop through bitrates and create an output for each
for bitrate in ${bitrates[*]}
do
  ffmpeg.exe -y -i $input_video -c:v libx264 -b:v $bitrate -g 48 -keyint_min 48 -sc_threshold 0 -f dash $output_folder/$output_name$bitrate.mpd || { echo "Error encoding video at bitrate $bitrate"; exit 1; }
  echo "Video encoded at bitrate $bitrate"
done

echo "All bitrates encoded. Creating DASH manifest..."

# Define the python script as a variable
PY_SCRIPT=$(cat <<-END
import xml.etree.ElementTree as ET

bitrates = ['500k', '1000k', '1500k']
output_folder = "landung"
output_name = "stream"
master_manifest = "manifest.mpd"

# Parse one of the individual manifests to use as the base for the master manifest
tree = ET.parse(f'{output_folder}/{output_name}{bitrates[0]}.mpd')
root = tree.getroot()

# Find the AdaptationSet element
adaptation_set = root.find('{urn:mpeg:dash:schema:mpd:2011}Period').find('{urn:mpeg:dash:schema:mpd:2011}AdaptationSet')

# Remove the existing Representation element
for representation in adaptation_set.findall('{urn:mpeg:dash:schema:mpd:2011}Representation'):
    adaptation_set.remove(representation)

# Loop through bitrates and add the Representation from each individual manifest
for bitrate in bitrates:
    individual_tree = ET.parse(f'{output_folder}/{output_name}{bitrate}.mpd')
    individual_root = individual_tree.getroot()
    representation = individual_root.find('{urn:mpeg:dash:schema:mpd:2011}Period').find('{urn:mpeg:dash:schema:mpd:2011}AdaptationSet').find('{urn:mpeg:dash:schema:mpd:2011}Representation')
    adaptation_set.append(representation)

# Write the master manifest
tree.write(f'{output_folder}/{master_manifest}')
END
)

# Run the python script
echo "$PY_SCRIPT" | python

echo "DASH manifest created. Script completed."