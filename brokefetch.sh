#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
BLUE="\e[34m"
BOLD="\e[1m"
RESET="\e[0m"

PKG_COUNT=$(pacman -Q | wc -l)

# CONFIG
CONFIG_FILE="$HOME/.config/brokefetch/config"

# If there is no config – create a default one.
if [[ ! -f "$CONFIG_FILE" ]]; then
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo -e "# Available COLOR_NAME options: RED, GREEN, BLUE" > "$CONFIG_FILE"
	echo -e "# Set RAM_MB to your desired memory size in MB" >> "$CONFIG_FILE"
	echo -e "# Set UPTIME_OVERRIDE to your desired uptime in hours" >> "$CONFIG_FILE"
	echo -e "RAM_MB=128\nUPTIME_OVERRIDE=16\nCOLOR_NAME=BLUE" > "$CONFIG_FILE"
fi

# Load values from the config
source "$CONFIG_FILE"

# OS 
OS_NAME="$(awk -F= '/^NAME=/{print $2}' /etc/os-release | tr -d '"')"

case "$OS_NAME" in
    "Arch Linux")          OS="Arch Linux (Unpaid Edition)";;
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
    *) OS="$OS_NAME (??)";;
esac

# Uptime

UPTIME=$UPTIME_OVERRIDE

# RAM
MEMORY_MB=$RAM_MB

# Value of the color
COLOR=${!COLOR_NAME}

#CPU

rand=$(($RANDOM%6))

case $rand in
	0)CPU="Imaginary (thinking hard...)";;
	1)CPU="Hopes and dreams";;
	2)CPU="Two sticks rubbing together";;
	3)CPU="(Less powerful than) Atom";;
	4)CPU="Celery Acceleron";;
	5)CPU="Fentium";;
	6)CPU="Corei14billon (I wish)";;
esac


echo -e "${COLOR}                -\`                   ${RESET}$(whoami)@brokelaptop"
echo -e "${COLOR}               .o+\`                  ${RESET} ---------------------"
echo -e "${COLOR}              \`ooo/                  ${BOLD}OS:${RESET} $OS"
echo -e "${COLOR}             \`+oooo:                 ${BOLD}Host:${RESET} Bedroom Floor"
echo -e "${COLOR}            \`+oooooo:                ${BOLD}Kernel:${RESET} 0.00/hr"
echo -e "${COLOR}            -+oooooo+:               ${BOLD}Uptime:${RESET} $UPTIME (sleep not included)"
echo -e "${COLOR}          \`/:-:++oooo+:              ${BOLD}Packages:${RESET} $PKG_COUNT (none legal)"
echo -e "${COLOR}         \`/++++/+++++++:             ${BOLD}Shell:${RESET} brokeBash 0.01"
echo -e "${COLOR}        \`/++++++++++++++:            ${BOLD}Resolution:${RESET} CRT 640x480"
echo -e "${COLOR}       \`/+++ooooooooooooo/\`          ${BOLD}DE:${RESET} Crying"
echo -e "${COLOR}      ./ooosssso++osssssso+\`         ${BOLD}WM:${RESET} HopiumWM"
echo -e "${COLOR}     .oossssso-\`\`\`\`/ossssss+\`        ${BOLD}Terminal:${RESET} Terminal of Regret"
echo -e "${COLOR}    -osssssso.      :ssssssso.       ${BOLD}CPU:${RESET} $CPU"
echo -e "${COLOR}   :osssssss/        osssso+++.\     ${BOLD}GPU:${RESET} Integrated Depression"
echo -e "${COLOR}  /ossssssss/        +ssssooo/-      ${BOLD}Memory:${RESET} ${MEMORY_MB}MB (user-defined-sadness)"
echo -e "${COLOR} \`/ossssso+/:-        -:/+osssso+-"
echo -e "${COLOR}\`+sso+:-\`                 \`.-/+oso:"
echo -e "${COLOR}\`++:.                           \`-/+/"
echo -e "${COLOR}\`.\`                                \`"

echo -e "${BOLD}BROKEFETCH 🥀 1.7 ${RESET}"

