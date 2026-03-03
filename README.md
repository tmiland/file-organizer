# File Organizer - Auto-Start Setup

This package includes everything you need to automatically organize your downloads on startup.

## Quick Installation

1. Download all three files to the same folder
2. Open terminal in that folder
3. Run the installation script:
   ```bash
   chmod +x install.sh file-organizer.sh
   ./install.sh
   ```

That's it! The file organizer will now run automatically every time you start your computer.

## What Gets Installed

- **file-organizer.sh** - The main script (copied to ~/file-organizer.sh)
- **file-organizer.service** - Systemd service file (copied to ~/.config/systemd/user/)

## Manual Installation (if you prefer)

If you want to install manually:

1. Copy the script and make it executable:
   ```bash
   cp file-organizer.sh ~/file-organizer.sh
   chmod +x ~/file-organizer.sh
   ```

2. Install the service:
   ```bash
   mkdir -p ~/.config/systemd/user
   cp file-organizer.service ~/.config/systemd/user/
   chmod 644 ~/.config/systemd/user/file-organizer.service
   ```

3. Enable and start:
   ```bash
   systemctl --user daemon-reload
   systemctl --user enable file-organizer.service
   loginctl enable-linger $USER
   systemctl --user start file-organizer.service
   ```

## Management Commands

**Check if it's running:**
```bash
systemctl --user status file-organizer.service
```

**Stop the service:**
```bash
systemctl --user stop file-organizer.service
```

**Start the service:**
```bash
systemctl --user start file-organizer.service
```

**Restart the service:**
```bash
systemctl --user restart file-organizer.service
```

**Disable auto-start:**
```bash
systemctl --user disable file-organizer.service
```

**View live logs:**
```bash
journalctl --user -u file-organizer.service -f
```

## How It Works

The script monitors your ~/Downloads folder every 5 seconds and automatically moves files to:

- **Video/** - mp4, mkv, avi, mov, etc.
- **Audio/** - mp3, wav, flac, aac, etc.
- **Images/** - jpg, png, gif, svg, etc.
- **Documents/** - pdf, docx, txt, xlsx, etc.
- **Archives/** - zip, rar, 7z, tar, etc.
- **Programs/** - exe, deb, apk, dmg, etc.

## Troubleshooting

**Permission denied error?**
Make sure the scripts are executable:
```bash
chmod +x ~/file-organizer.sh
chmod +x install.sh file-organizer.sh
```

**Service won't start on boot?**
Enable lingering for your user:
```bash
loginctl enable-linger $USER
```

**Service fails to start?**
Check the logs for errors:
```bash
journalctl --user -u file-organizer.service -n 50
```

**Want to test the script manually first?**
Run it directly:
```bash
bash ~/file-organizer.sh
```
Press Ctrl+C to stop it.

**Want to change the monitored folder?**
Edit ~/file-organizer.sh and change the DOWNLOAD_DIR variable, then restart:
```bash
systemctl --user restart file-organizer.service
```

**Want to add more file types?**
Edit ~/file-organizer.sh and add extensions to the appropriate case statement, then restart the service.

## Uninstallation

To completely remove the file organizer:
```bash
systemctl --user stop file-organizer.service
systemctl --user disable file-organizer.service
rm ~/.config/systemd/user/file-organizer.service
rm ~/file-organizer.sh
systemctl --user daemon-reload
```
