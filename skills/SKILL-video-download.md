---
name: video-download
description: >
  Download YouTube videos and split them into fixed-size parts (default 14 MB).
  Use when: user provides a YouTube URL and wants to download, split, or partition a video.
  Handles download via yt-dlp.exe and splitting via ffmpeg.exe.
  Save outputs to C:\YT\particion\ folder.
compatibility: opencode
metadata:
  tools: "yt-dlp.exe, ffmpeg.exe"
  output: "C:\\YT\\particion\\"
---

## Description

Downloads a YouTube video using yt-dlp.exe and splits it into ~N MB segments using ffmpeg.exe.

## Prerequisites

- `C:\YT\yt-dlp.exe` — YouTube downloader
- `C:\YT\ffmpeg.exe` — multimedia frame

Both must exist before running. If missing, guide the user to download them.

## Script

The automation script lives at `C:\YT\download-video.ps1`.

### Usage

```powershell
.\download-video.ps1 -Url "https://youtu.be/VIDEO_ID"
.\download-video.ps1 -Url "https://youtu.be/VIDEO_ID" -PartSizeMB 20
.\download-video.ps1 -Url "https://youtu.be/VIDEO_ID" -KeepVideo
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `-Url` | string | (required) | YouTube video URL |
| `-PartSizeMB` | int | 14 | Target size per part in MB |
| `-OutputDir` | string | C:\YT | Working directory |
| `-KeepVideo` | switch | $false | Keep the full video after splitting |

## What it does

1. Downloads best available mp4 format (video+audio merged)
2. Reads video duration via ffprobe
3. Calculates `segment_time` so each part is ~N MB:
   `segment_time = (targetBytes * totalSeconds) / fileSize`
4. Runs ffmpeg segment muxer with `-c copy` (no re-encode)
5. Reports parts in `C:\YT\particion\`
6. Cleans up the full video (unless `-KeepVideo`)

## When to use

- User says: "download this YouTube video and split it"
- User says: "partition this video into 14 MB files"
- User says: "download video for Telegram/share"
- User provides a `youtu.be` or `youtube.com` link

## Notes

- Uses stream copy (`-c copy`), no re-encoding — fast and lossless
- Segment boundaries are on keyframes; exact size may vary ±2 MB
- Last part is typically smaller than the target size
- If yt-dlp warns about a JavaScript runtime, the download still works
