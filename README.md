# Scum Music Formatter (SMF)

**SMF** is a simple utility to format audio files for Apple Music upload. It supports batch conversion for directories and single files, with customizable output formats and naming conventions.

## Features

- Convert files to `.mp3` or `.wav`.
- Choose between `artist-name` or `name-artist` naming conventions.
- Batch process directories or convert individual files.

## Installation

1. Install **Lua** and **FFmpeg**:
   - `sudo apt install lua5.1 ffmpeg` (Ubuntu)
   - `brew install lua ffmpeg` (macOS)

2. Run the script:
   ```bash
   lua scum_music_formatter.lua --path /path/to/files

# Run lua SMF.lua -h for usage
