#!/bin/bash

# This script interactively installs either 'brokefetch.sh' or 'brokefetch_EDGE.sh'
# from the current directory, or downloads it if not found. It gives the user a choice
# to install to /usr/bin (system-wide) or ~/.local/bin (user-specific).

# --- Best practice for robust scripts: Exit immediately on errors ---
set -e

# --- Function to check for curl ---
check_curl() {
    if ! command -v curl &> /dev/null; then
        echo "Error: 'curl' is not installed. Please install it to download the script."
        echo "On Debian/Ubuntu: sudo apt-get install curl"
        echo "On Fedora/CentOS: sudo yum install curl"
        echo "On Arch Linux: sudo pacman -S curl"
        exit 1
    fi
}

# --- Define download URLs ---
# These URLs should point to the raw files in your GitHub repository.
NORMAL_URL="https://raw.githubusercontent.com/Szerwigi1410/brokefetch/refs/heads/main/brokefetch.sh"
EDGE_URL="https://raw.githubusercontent.com/Szerwigi1410/brokefetch/refs/heads/main/brokefetch_EDGE.sh"

# --- Main script execution starts here ---

# Check for necessary tools first
check_curl

# --- Step 1: Identify and/or download the source file ---
source_file=""
downloaded=0
temp_dir=$(mktemp -d)

# Check for existing local files
available_scripts=()
if [ -f "brokefetch.sh" ]; then
    available_scripts+=("brokefetch.sh")
fi
if [ -f "brokefetch_EDGE.sh" ]; then
    available_scripts+=("brokefetch_EDGE.sh")
fi

# If no local files found, prompt to download
if [ ${#available_scripts[@]} -eq 0 ]; then
    echo "No brokefetch scripts found in the current directory."
    echo "Please choose a version to download and install:"
    
    select choice in "Normal" "Edge" "Quit"; do
        case $choice in
            Normal )
                echo "Downloading the normal version..."
                # Download to a temporary directory for safety
                if curl -sSL "$NORMAL_URL" -o "$temp_dir/brokefetch.sh"; then
                    source_file="$temp_dir/brokefetch.sh"
                    downloaded=1
                    break
                else
                    echo "Error: Failed to download the normal version. Exiting."
                    rm -r "$temp_dir"
                    exit 1
                fi
                ;;
            Edge )
                echo "Downloading the EDGE version..."
                if curl -sSL "$EDGE_URL" -o "$temp_dir/brokefetch_EDGE.sh"; then
                    source_file="$temp_dir/brokefetch_EDGE.sh"
                    downloaded=1
                    break
                else
                    echo "Error: Failed to download the EDGE version. Exiting."
                    rm -r "$temp_dir"
                    exit 1
                fi
                ;;
            Quit )
                echo "Exiting installation."
                rm -r "$temp_dir"
                exit 0
                ;;
            * )
                echo "Invalid choice. Please select a number from the list."
                ;;
        esac
    done
# If local files were found, prompt the user to choose
elif [ ${#available_scripts[@]} -eq 1 ]; then
    source_file="${available_scripts[0]}"
    echo "Found '${source_file}'. This script will be installed."
else
    echo "Multiple brokefetch scripts found. Please choose one to install:"
    select choice in "${available_scripts[@]}"; do
        if [ -n "$choice" ]; then
            source_file="$choice"
            break
        else
            echo "Invalid choice. Please select a number from the list."
        fi
    done
fi

# Exit if no source file was determined (e.g., download failed or user quit)
if [ -z "$source_file" ]; then
    echo "Error: Could not determine a source file for installation."
    rm -r "$temp_dir"
    exit 1
fi

# --- Step 2: Ask the user for the installation path ---
echo "Where would you like to install the 'brokefetch' script?"

install_path=""
use_sudo="false"

select install_choice in "/usr/bin" "$HOME/.local/bin" "Quit"; do
    case $install_choice in
        "/usr/bin" )
            install_path="/usr/bin/brokefetch"
            use_sudo="true"
            echo "Installing to /usr/bin. You will be prompted for your password."
            break
            ;;
        "$HOME/.local/bin" )
            install_path="$HOME/.local/bin/brokefetch"
            echo "Installing to ~/.local/bin."
            break
            ;;
        "Quit" )
            echo "Installation canceled."
            if [ $downloaded -eq 1 ]; then rm -r "$temp_dir"; fi
            exit 0
            ;;
        * )
            echo "Invalid choice. Please select 1 or 2."
            ;;
    esac
done

install_dir=$(dirname "$install_path")

# --- Step 3: Check for existing installation and prompt for overwrite/remove ---
if [ -f "$install_path" ]; then
    echo "An existing 'brokefetch' script was found at $install_path."
    read -p "Do you want to overwrite it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation canceled by user."
        if [ $downloaded -eq 1 ]; then rm -r "$temp_dir"; fi
        exit 0
    fi
fi

# --- Step 4: Perform the installation ---
echo "Installing '$source_file' to '$install_path'..."

# Create the directory if it doesn't exist
if [ "$use_sudo" = "true" ]; then
    sudo mkdir -p "$install_dir"
else
    mkdir -p "$install_dir"
fi

# Copy the chosen file
if [ "$use_sudo" = "true" ]; then
    sudo cp "$source_file" "$install_path"
else
    cp "$source_file" "$install_path"
fi

# Make the new file executable
if [ "$use_sudo" = "true" ]; then
    sudo chmod +x "$install_path"
else
    chmod +x "$install_path"
fi

# --- Step 5: Final success message and cleanup ---
echo "Success! '$source_file' is now installed as 'brokefetch'."

if [ "$use_sudo" != "true" ]; then
    echo "You may need to add '$HOME/.local/bin' to your PATH to run it from any directory."
fi

# Clean up temporary downloaded file if necessary
if [ $downloaded -eq 1 ]; then
    echo "Cleaning up temporary files..."
    rm -r "$temp_dir"
fi

exit 0
