#!/bin/bash

# File Organizer Script
# Automatically moves downloaded files to folders based on their format

# Configuration
DOWNLOAD_DIR="$HOME/Downloads"
WATCH_INTERVAL=5  # Check every 5 seconds

# Destination folders
VIDEO_DIR="$HOME/Videos"
AUDIO_DIR="$HOME/Audio"
IMAGES_DIR="$HOME/Pictures"
DOCUMENTS_DIR="$HOME/Documents"
ARCHIVES_DIR="$HOME/Archives"
PROGRAMS_DIR="$HOME/Programs"
SCRIPT_DIR="$HOME/.scripts"

# Create destination folders if they don't exist
mkdir -p "$VIDEO_DIR"
mkdir -p "$AUDIO_DIR"
mkdir -p "$IMAGES_DIR"
mkdir -p "$DOCUMENTS_DIR"
mkdir -p "$ARCHIVES_DIR"
mkdir -p "$PROGRAMS_DIR"
mkdir -p "$SCRIPT_DIR"

# Function to get file extension in lowercase
get_extension() {
    filename="$1"
    echo "${filename##*.}" | tr '[:upper:]' '[:lower:]'
}

# Function to move file to appropriate folder
organize_file() {
    filepath="$1"
    filename=$(basename "$filepath")
    extension=$(get_extension "$filename")
    
    # Skip if file is in a subfolder
    if [ "$(dirname "$filepath")" != "$DOWNLOAD_DIR" ]; then
        return
    fi
    
    # Determine destination based on extension
    case "$extension" in
        # Video formats
        mp4|mkv|avi|mov|wmv|flv|webm|m4v|mpg|mpeg|3gp|ts)
            dest="$VIDEO_DIR"
            ;;
        # Audio formats
        mp3|wav|flac|aac|ogg|wma|m4a|opus|aiff)
            dest="$AUDIO_DIR"
            ;;
        # Image formats
        jpg|jpeg|png|gif|bmp|svg|webp|ico|tiff|tif|heic|raw|psd)
            dest="$IMAGES_DIR"
            ;;
        # Document formats
        pdf|doc|docx|txt|rtf|odt|xls|xlsx|ppt|pptx|csv|epub|pages)
            dest="$DOCUMENTS_DIR"
            ;;
        # Archive formats
        zip|rar|7z|tar|gz|bz2|xz|tgz|iso|dmg)
            dest="$ARCHIVES_DIR"
            ;;
        # Program/executable formats
        exe|deb|rpm|appimage|pkg|apk|msi|bat|jar|app|bin)
            dest="$PROGRAMS_DIR"
            ;;
        # Shell scripts
        sh)
            dest="$SCRIPT_DIR"
            ;;
        *)
            # Unknown format, don't move
            return
            ;;
    esac
    
    # Move the file
    if [ -f "$filepath" ]; then
      if [ -f "$dest/$filename" ]; then
        echo "$filename already exists... Making a backup"
        # Use backup option
        mv_arg="-b"
      else
        # Use do not overwrite option (just to make sure)
        mv_arg="-n"
      fi
      mv "$mv_arg" "$filepath" "$dest/"
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] Moved: $filename -> $(basename "$dest")"
    fi
}

# Main monitoring loop
echo "File Organizer started!"
echo "Monitoring: $DOWNLOAD_DIR"
echo "Press Ctrl+C to stop"
echo ""

while true; do
    # Process all files in download directory
    for file in "$DOWNLOAD_DIR"/*; do
        # Skip if it's a directory or doesn't exist
        if [ -f "$file" ]; then
            organize_file "$file"
        fi
    done
    
    # Wait before next check
    sleep $WATCH_INTERVAL
done
