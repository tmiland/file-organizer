#!/bin/bash

# Installation script for File Organizer auto-start

echo "Installing File Organizer auto-start..."
echo ""

# Check if files exist
if [ ! -f "file-organizer.sh" ]; then
    echo "Error: file-organizer.sh not found in current directory"
    exit 1
fi

if [ ! -f "file-organizer.service" ]; then
    echo "Error: file-organizer.service not found in current directory"
    exit 1
fi

# Create install directory
mkdir -p "$HOME"/.file-organizer
INSTALL_DIR="$HOME"/.file-organizer

# Copy the main script to install directory
echo "Copying script to $INSTALL_DIR..."
cp file-organizer.sh "$INSTALL_DIR"/file-organizer.sh
chmod +x "$INSTALL_DIR"/file-organizer.sh

# Verify the script is executable
if [ ! -x "$INSTALL_DIR"/file-organizer.sh ]; then
    echo "Error: Could not make script executable"
    exit 1
fi

# Create systemd user directory if it doesn't exist
echo "Setting up systemd service..."
mkdir -p ~/.config/systemd/user

# Copy service file to systemd user directory
cp file-organizer.service ~/.config/systemd/user/
chmod 644 ~/.config/systemd/user/file-organizer.service

# Reload systemd user daemon
systemctl --user daemon-reload

# Enable the service to start on boot
systemctl --user enable file-organizer.service

# Enable lingering (allows services to run without active login session)
echo "Enabling user lingering..."
loginctl enable-linger "$USER" 2>/dev/null || echo "Note: Could not enable lingering (may require sudo)"

# Start the service now
systemctl --user start file-organizer.service

# Wait a moment and check status
sleep 2

echo ""
echo "========================================"
echo "Installation complete!"
echo "========================================"
echo ""

# Check if service is running
if systemctl --user is-active --quiet file-organizer.service; then
    echo "✓ Service is running successfully!"
else
    echo "⚠ Service may not be running. Check status with:"
    echo "  systemctl --user status file-organizer.service"
fi

echo ""
echo "The file organizer will now run automatically on startup."
echo ""
echo "Useful commands:"
echo "  Check status:       systemctl --user status file-organizer.service"
echo "  Stop service:       systemctl --user stop file-organizer.service"
echo "  Start service:      systemctl --user start file-organizer.service"
echo "  Restart service:    systemctl --user restart file-organizer.service"
echo "  Disable auto-start: systemctl --user disable file-organizer.service"
echo "  View logs:          journalctl --user -u file-organizer.service -f"
echo ""
