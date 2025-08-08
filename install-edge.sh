#!/bin/bash

# This script looks for 'brokefetch_EDGE.sh' in the current directory,
# and if found, installs it to /usr/bin as 'brokefetch' with sudo.

# Check if the source file exists in the current directory.
if [ ! -f "brokefetch_EDGE.sh" ]; then
    echo "Error: 'brokefetch_EDGE.sh' not found in the current directory."
    exit 1
fi

echo "Found 'brokefetch_EDGE.sh'. Installing to /usr/bin/brokefetch..."

# The script requires sudo for the following commands.
# Using 'sudo' on individual commands is a common practice to avoid running
# the entire script as root, which is a security risk.

# Check if an old version of brokefetch exists and remove it.
if [ -f "/usr/bin/brokefetch" ]; then
    echo "Existing 'brokefetch' found. Removing the old version."
    sudo rm /usr/bin/brokefetch
fi

# Copy the file to /usr/bin and rename it.
sudo cp brokefetch_EDGE.sh /usr/bin/brokefetch

# Make the new file executable.
sudo chmod +x /usr/bin/brokefetch

# Verify the installation and provide a success message.
if [ -f "/usr/bin/brokefetch" ]; then
    echo "Success! 'brokefetch' is now installed and ready to use."
    echo "You can run it from any directory by typing 'brokefetch'."
else
    echo "An error occurred during installation."
fi
