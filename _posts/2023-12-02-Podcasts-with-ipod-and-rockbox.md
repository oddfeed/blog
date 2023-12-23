---
tags: [ipod, rockbox]
---

# Podcasts on ipod when running rockbox
It works like the following you have a file of subscriptions (youtube links) the script downloads files from thoose channels converts to mp3 and writes the metadtaa to the file, if it's downloaded a file it writes it to history.txt then excludes it going forward.


* TOC
{:toc}


# Software
## Requirements
These scripts rely upon yt-dlp and ffmpeg, if you prefer youtube-dl you should be able to swap it out 1:1

## subscriptions.csv

```
ChannelURL,ChannelName
https://www.youtube.com/@HSTPOD,HSTPOD
```


## podcasts.sh

```
#!/bin/bash

# Define the file paths
subscriptions_file="subscriptions.csv"
history_file="history.txt"

# Check if history file exists, if not create it
[ -f "$history_file" ] || touch "$history_file"

# Function to process a single video URL
process_video() {
    local url=$1
    local channel_name=$2
    full_url="https://www.youtube.com/watch?v=$url"

    # Extract the video title
    video_title=$(yt-dlp --get-title "$full_url")

    # Check if the video is already downloaded
    if ! grep -q "$full_url" "$history_file"; then
        # Download the video
        yt-dlp -x --audio-format mp3 --output "%(title)s.%(ext)s" "$full_url"
        downloaded_file="$(yt-dlp --get-filename -o '%(title)s.mp3' "$full_url")"

        # Check if the download was successful
        if [ -f "$downloaded_file" ]; then
            # Set the metadata for artist, title, and genre
            ffmpeg -i "$downloaded_file" -metadata artist="$channel_name" -metadata title="$video_title" -metadata genre="podcast" -acodec copy "temp_$downloaded_file"
            mv "temp_$downloaded_file" "$downloaded_file"

            # Add to history
            echo "$full_url" >> "$history_file"
        fi
    fi
}

# Skip the header line and read each line from subscriptions.csv
tail -n +2 "$subscriptions_file" | while IFS=, read -r channel_url channel_name; do
    # Use yt-dlp to get the list of videos from the channel
    yt-dlp -i --get-id "$channel_url" | while IFS= read -r url; do
        process_video "$url" "$channel_name"
    done
done
```



## single.sh

```
#!/bin/bash

# Ask the user for a YouTube URL
echo "Please enter the YouTube URL:"
read -r youtube_url

# Use yt-dlp to download the video and convert it to MP3
yt-dlp -x --audio-format mp3 --output "%(title)s.%(ext)s" "$youtube_url"

# Extract the video title for the metadata
video_title=$(yt-dlp --get-title "$youtube_url")

# Extract the channel name for the artist metadata
channel_name=$(yt-dlp --get-filename -o '%(channel)s' "$youtube_url")

# Get the filename of the downloaded MP3
mp3_file="$(yt-dlp --get-filename -o '%(title)s.mp3' "$youtube_url")"

# Check if the download and conversion was successful
if [ -f "$mp3_file" ]; then
    # Set the metadata for the title, artist, and genre
    ffmpeg -i "$mp3_file" -metadata title="$video_title" -metadata artist="$channel_name" -metadata genre="podcast" -acodec copy "temp_$mp3_file"
    mv "temp_$mp3_file" "$mp3_file"
else
    echo "Download failed or file not found."
fi

echo "Process completed."
```

# Rockbox

On rockbox I have a folder "Podcasts" in the root directory that I keep out of my rockbox database then I just use files to play something, I use the bookmarks feature to keep track of where I'm up to, just long press on it, then once I've finished I delete the file.
