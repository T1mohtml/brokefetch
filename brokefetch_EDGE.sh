#!/bin/bash

# IMPORTANT NOTE: This script is called "brokefetch_edge.sh" because it is not fully functional yet.
# It is a work in progress. When completed, it will replace "brokefetch.sh".
# This script will display different ASCII for each OS which brokefetch.sh doesn't support yet.

GREEN="\e[32m"
RED="\e[31m"
BLUE="\e[34m"
WHITE="\e[37m"
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

# ARCH ASCII =========================================
if [[ "$OS_NAME" == "Arch Linux" ]]; then
ascii00="                   -\`                     "
ascii01="                  .o+\`                    "
ascii02="                 \`ooo/                    "
ascii03="                \`+oooo:                   "
ascii04="               \`+oooooo:                  "
ascii05="               -+oooooo+:                 "
ascii06="             \`/:-:++oooo+:                "
ascii07="            \`/++++/+++++++:               "
ascii08="           \`/++++++++++++++:              "
ascii09="          \`/+++ooooooooooooo/\`            "
ascii10="         ./ooosssso++osssssso+\`           "
ascii11="        .oossssso-\`\`\`\`/ossssss+\`          "
ascii12="       -osssssso.      :ssssssso.         "
ascii13="      :osssssss/        osssso+++.        "
ascii14="     /ossssssss/        +ssssooo/-        "
ascii15="   \`/ossssso+/:-        -:/+osssso+-     "
ascii16="  \`+sso+:-\`                 \`.-/+oso:    "
ascii17=" \`++:.                           \`-/+/   "
ascii18=" .\`                                 \`/   "
fi

# UBUNTU ASCII =========================================
if [[ "$OS_NAME" == "Ubuntu" ]]; then
ascii00="            .-/+oossssoo+/-.               "
ascii01="        \`:+ssssssssssssssssss+:\`           "
ascii02="      -+ssssssssssssssssssyyssss+-         "
ascii03="    .ossssssssssssssssss${WHITE}dMMMNy${COLOR}sssso.       "
ascii04="   /sssssssssss${WHITE}hdmmNNmmyNMMMMh${COLOR}ssssss/      "
ascii05="  +sssssssss${WHITE}hm${COLOR}yd${WHITE}MMMMMMMNddddy${COLOR}ssssssss+     "
ascii06=" /ssssssss${WHITE}hNMMM${COLOR}yh${WHITE}hyyyyhmNMMMNh${COLOR}ssssssss/    "
ascii07=".ssssssss${WHITE}dMMMNh${COLOR}ssssssssss${WHITE}hNMMMd${COLOR}ssssssss.   "
ascii08="+ssss${WHITE}hhhyNMMNy${COLOR}ssssssssssss${WHITE}yNMMMy${COLOR}sssssss+   "
ascii09="oss${WHITE}yNMMMNyMMh${COLOR}ssssssssssssss${WHITE}hmmmh${COLOR}ssssssso   "
ascii10="oss${WHITE}yNMMMNyMMh${COLOR}sssssssssssssshmmmhssssssso   "
ascii11="+ssss${WHITE}hhhyNMMNy${COLOR}ssssssssssss${WHITE}yNMMMy${WHITE}sssssss+   "
ascii12=""
ascii13=""
ascii14=""
ascii15=""
ascii16=""
ascii17=""
ascii18=""
fi



# === OUTPUT ===
echo -e "${COLOR}${ascii00} ${RESET} $(whoami)@brokelaptop"
echo -e "${COLOR}${ascii01}${RESET} ---------------------"
echo -e "${COLOR}${ascii02}${BOLD}OS:${RESET} $OS"
echo -e "${COLOR}${ascii03}${BOLD}Host:${RESET} Bedroom Floor"
echo -e "${COLOR}${ascii04}${BOLD}Kernel:${RESET} 0.00/hr"
echo -e "${COLOR}${ascii05}${BOLD}Uptime:${RESET} $UPTIME (sleep not included)"
echo -e "${COLOR}${ascii06}${BOLD}Packages:${RESET} $PKG_COUNT (none legal)"
echo -e "${COLOR}${ascii07}${BOLD}Shell:${RESET} brokeBash 0.01"
echo -e "${COLOR}${ascii08}${BOLD}Resolution:${RESET} CRT 640x480"
echo -e "${COLOR}${ascii09}${BOLD}DE:${RESET} Crying"
echo -e "${COLOR}${ascii10}${BOLD}WM:${RESET} HopiumWM"
echo -e "${COLOR}${ascii11}${BOLD}Terminal:${RESET} Terminal of Regret"
echo -e "${COLOR}${ascii12}${BOLD}CPU:${RESET} $CPU"
echo -e "${COLOR}${ascii13}${BOLD}GPU:${RESET} Integrated Depression"
echo -e "${COLOR}${ascii14}${BOLD}Memory:${RESET} ${MEMORY_MB}MB (user-defined-sadness)"
echo -e "${COLOR}${ascii15}"
echo -e "${COLOR}${ascii16}"
echo -e "${COLOR}${ascii17}"
echo -e "${COLOR}${ascii18}"
echo -e "${BOLD}BROKEFETCH 🥀 1.7${RESET}"
