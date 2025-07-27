#!/bin/bash

BLUE="\e[34m"
BOLD="\e[1m"
RESET="\e[0m"
PKG_COUNT=$(pacman -Q | wc -l)

# CONFIG
CONFIG_FILE="$HOME/.config/brokefetch/config"

# Jeśli nie ma configu – utwórz domyślny
if [[ ! -f "$CONFIG_FILE" ]]; then
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo -e "RAM_MB=128\nUPTIME_OVERRIDE=16" > "$CONFIG_FILE"
fi

# Wczytaj wartości z configu
source "$CONFIG_FILE"

# Uptime

UPTIME=$UPTIME_OVERRIDE

# RAM
MEMORY_MB=$RAM_MB

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


echo -e "${BLUE}                -\`                   ${RESET}$(whoami)@brokelaptop"
echo -e "${BLUE}               .o+\`                  ${RESET} ---------------------"
echo -e "${BLUE}              \`ooo/                  ${BOLD}OS:${RESET} Arch Linux (Unpaid Edition)"
echo -e "${BLUE}             \`+oooo:                 ${BOLD}Host:${RESET} Bedroom Floor"
echo -e "${BLUE}            \`+oooooo:                ${BOLD}Kernel:${RESET} 0.00/hr"
echo -e "${BLUE}            -+oooooo+:               ${BOLD}Uptime:${RESET} $UPTIME (sleep not included)"
echo -e "${BLUE}          \`/:-:++oooo+:              ${BOLD}Packages:${RESET} $PKG_COUNT (none legal)"
echo -e "${BLUE}         \`/++++/+++++++:             ${BOLD}Shell:${RESET} brokeBash 0.01"
echo -e "${BLUE}        \`/++++++++++++++:            ${BOLD}Resolution:${RESET} CRT 640x480"
echo -e "${BLUE}       \`/+++ooooooooooooo/\`          ${BOLD}DE:${RESET} Crying"
echo -e "${BLUE}      ./ooosssso++osssssso+\`         ${BOLD}WM:${RESET} HopiumWM"
echo -e "${BLUE}     .oossssso-\`\`\`\`/ossssss+\`        ${BOLD}Terminal:${RESET} Terminal of Regret"
echo -e "${BLUE}    -osssssso.      :ssssssso.       ${BOLD}CPU:${RESET} $CPU"
echo -e "${BLUE}   :osssssss/        osssso+++.\     ${BOLD}GPU:${RESET} Integrated Depression"
echo -e "${BLUE}  /ossssssss/        +ssssooo/-      ${BOLD}Memory:${RESET} ${MEMORY_MB}MB (user-defined-sadness)"
echo -e "${BLUE} \`/ossssso+/:-        -:/+osssso+-"
echo -e "${BLUE}\`+sso+:-\`                 \`.-/+oso:"
echo -e "${BLUE}\`++:.                           \`-/+/"
echo -e "${BLUE}\`.\`                                \`"

echo -e "${BOLD}BROKEFETCH 🥀 1.6 ${RESET}"

