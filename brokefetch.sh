#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
BLUE="\e[34m"
BOLD="\e[1m"
RESET="\e[0m"

PKG_COUNT=$(pacman -Q | wc -l)

# CONFIG
CONFIG_FILE="$HOME/.config/brokefetch/config"

# Jeśli nie ma configu – utwórz domyślny
if [[ ! -f "$CONFIG_FILE" ]]; then
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo -e "# Available COLOR_NAME options: RED, GREEN, BLUE"
	echo -e "RAM_MB=128\nUPTIME_OVERRIDE=16\nCOLOR_NAME(BLUE, RED, GREEN)=BLUE" > "$CONFIG_FILE"
fi

# Wczytaj wartości z configu
source "$CONFIG_FILE"

# Uptime

UPTIME=$UPTIME_OVERRIDE

# RAM
MEMORY_MB=$RAM_MB

# Wartość koloru
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
echo -e "${COLOR}              \`ooo/                  ${BOLD}OS:${RESET} Arch Linux (Unpaid Edition)"
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

echo -e "${BOLD}BROKEFETCH 🥀 1.6 ${RESET}"

