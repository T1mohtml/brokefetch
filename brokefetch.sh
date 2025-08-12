#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
BLUE="\033[34m"
CYAN="\033[36m"
WHITE="\033[37m"
BOLD="\033[1m"
RESET="\033[0m"

# Detect OS more robustly
if [ -f /etc/os-release ]; then
    OS_NAME="$(awk -F= '/^NAME=/{print $2}' /etc/os-release | tr -d '"')"
elif [[ "$(uname)" == "Darwin" ]]; then
    OS_NAME="macOS"
else
    OS_NAME="Unknown"
fi

# Packages count for macOS or Linux
if [[ "$OS_NAME" == "macOS" ]]; then
    PKG_COUNT=$(brew list --formula | wc -l)
elif command -v pacman &>/dev/null; then
    PKG_COUNT=$(pacman -Q | wc -l)
else
    PKG_COUNT="N/A"
fi

# CONFIG
CONFIG_FILE="$HOME/.config/brokefetch/config"

# If there is no config – create a default one.
if [[ ! -f "$CONFIG_FILE" ]]; then
    mkdir -p "$(dirname "$CONFIG_FILE")"
    {
      printf "# Available COLOR_NAME options: RED, GREEN, BLUE, CYAN, WHITE\n"
      printf "# Set RAM_MB to your desired memory size in MB\n"
      printf "# If you have any issues with brokefetch, try to remove this config and run brokefetch again\n"
      printf "RAM_MB=128\nUPTIME_OVERRIDE=16\nCOLOR_NAME=CYAN\n"
    } > "$CONFIG_FILE"
fi

# Load values from the config
source "$CONFIG_FILE"

# Map Linux OS names to funny strings; macOS gets a simple name
case "$OS_NAME" in
    "Arch Linux")          OS="Arch Linux (Unpaid Edition)";;
    "Alpine Linux")        OS="Alpine (because I can't afford a mountain)";;    
    "Ubuntu")              OS="Ubunstu (Activate Windows Survivor)";;
    "Linux Mint")          OS="Linux Mint (but no teeth left)";;
    "Fedora Linux")        OS="Fedora (tips hat in poverty)";;
    "Debian GNU/Linux")    OS="Plebian 12 (brokeworm)";;
    "Manjaro Linux")       OS="ManjarNO (Oh Please God No)";;
    "EndeavourOS")         OS="EndeavourOS (Arch for fetuses)";;
    "openSUSE Tumbleweed") OS="openSUSE (tumbling into debt)";;
    "openSUSE Leap")       OS="openSUSE Leap (into the void)";;
    "Garuda Linux")        OS="Garuda (because RGB broke my wallet)";;
    "elementary OS")       OS="elementaryOS (baby's first macbook)";;
    "Pop!_OS")             OS="Pop!_OS (But cant afford System76)";;
    "Kali Linux")          OS="Kali Linux (Dollar Store hacker addition)";;
    "Zorin OS")            OS="Zorin (Because I cant afford Windows)";;
    "Gentoo")              OS="Gentoo (Because I cant even afford time)";;
    "NixOS")               OS="NixOS (broke and broken by design)";;
    "Slackware")           OS="Slackware (no updates, no rent)";;
    "Void Linux")          OS="Void (bank account matches the name)";;
    "Nobara Linux")        OS="Nobara (Has 500 viruses from torrents)";;
    "macOS")               OS="macOS (too expensive)";;
    *) OS="$OS_NAME (??)";;
esac

# Uptime and RAM from config
UPTIME=$UPTIME_OVERRIDE
MEMORY_MB=$RAM_MB

# Color value from config variable name
COLOR=${!COLOR_NAME}

# CPU funny names
cpu_rand=$(($RANDOM%7))
case $cpu_rand in
    0)CPU="Imaginary (thinking hard...)";;
    1)CPU="Hopes and dreams";;
    2)CPU="Two sticks rubbing together";;
    3)CPU="(Less powerful than) Atom";;
    4)CPU="Celery Acceleron";;
    5)CPU="Fentium";;
    6)CPU="Corei14billon (I wish)";;
esac

# GPU funny names
gpu_rand=$(($RANDOM%8))
case $gpu_rand in
    0)GPU="Integrated Depression";;
    1)GPU="Nvidia (but no drivers)";;
    2)GPU="AMD (Ain't My Dollar)";;
    3)GPU="Inetl (I can't afford a real one)";;
    4)GPU="Voodoo 3Dfx (I wish)";;
    5)GPU="Radeon 7000 (from 2001)";;
    6)GPU="GeForce 256 (the first one ever made)";;
    7)GPU="Go outside for better graphics";;
esac

# Now print the output using printf and colors
printf "${COLOR}                -\`                   ${RESET}%s@brokelaptop\n" "$(whoami)"
printf "${COLOR}               .o+\`                  ${RESET} ---------------------\n"
printf "${COLOR}              \`ooo/                  ${BOLD}OS:${RESET} %s\n" "$OS"
printf "${COLOR}             \`+oooo:                 ${BOLD}Host:${RESET} Bedroom Floor\n"
printf "${COLOR}            \`+oooooo:                ${BOLD}Kernel:${RESET} 0.00/hr\n"
printf "${COLOR}            -+oooooo+:               ${BOLD}Uptime:${RESET} %s (sleep not included)\n" "$UPTIME"
printf "${COLOR}          \`/:-:++oooo+:              ${BOLD}Packages:${RESET} %s (none legal)\n" "$PKG_COUNT"
printf "${COLOR}         \`/++++/+++++++:             ${BOLD}Shell:${RESET} brokeBash 0.01\n"
printf "${COLOR}        \`/++++++++++++++:            ${BOLD}Resolution:${RESET} CRT 640x480\n"
printf "${COLOR}       \`/+++ooooooooooooo/\`          ${BOLD}DE:${RESET} Crying\n"
printf "${COLOR}      ./ooosssso++osssssso+\`         ${BOLD}WM:${RESET} HopiumWM\n"
printf "${COLOR}     .oossssso-\`\`\`\`/ossssss+\`        ${BOLD}Terminal:${RESET} Terminal of Regret\n"
printf "${COLOR}    -osssssso.      :ssssssso.       ${BOLD}CPU:${RESET} %s\n" "$CPU"
printf "${COLOR}   :osssssss/        osssso+++.\     ${BOLD}GPU:${RESET} %s\n" "$GPU"
printf "${COLOR}  /ossssssss/        +ssssooo/-      ${BOLD}Memory:${RESET} %dMB (user-defined-sadness)\n" "$MEMORY_MB"
printf "${COLOR} \`/ossssso+/:-        -:/+osssso+-\n"
printf "${COLOR}\`+sso+:-\`                 \`.-/+oso:\n"
printf "${COLOR}\`++:.                           \`-/+/\n"
printf "${COLOR}\`.\`                                \`\n"
printf "${BOLD}BROKEFETCH 🥀 1.7 ${RESET}\n"

echo -e "yoooo"