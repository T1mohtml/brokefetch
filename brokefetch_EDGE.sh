#!/bin/bash

# IMPORTANT NOTE: This script is called "brokefetch_EDGE.sh" because it is not fully functional yet.
# It is a work in progress. When completed, it will replace "brokefetch.sh".
# This script will display different ASCII for each OS and do many other usefull stuff which brokefetch.sh doesn't support yet.

GREEN="\e[32m"
RED="\e[31m"
BLUE="\e[34m"
CYAN="\e[36m"
WHITE="\e[37m"
YELLOW="\e[33m"
BOLD="\e[1m"
RESET="\e[0m"

#PKG_COUNT=$(pacman -Q | wc -l)

# Universal package count
if command -v pacman &>/dev/null; then
    PKG_COUNT=$(pacman -Q | wc -l)
elif command -v dpkg &>/dev/null; then
    PKG_COUNT=$(dpkg -l | grep '^ii' | wc -l)
elif command -v rpm &>/dev/null; then
    PKG_COUNT=$(rpm -qa | wc -l)
elif command -v apk &>/dev/null; then
    PKG_COUNT=$(apk info | wc -l)
elif command -v pkg &>/dev/null; then
    PKG_COUNT=$(pkg info | wc -l)
else
    PKG_COUNT="-1" # Unknown package manager
fi

# CONFIG
CONFIG_FILE="$HOME/.config/brokefetch/config"

# If there is no config – create a default one.
if [[ ! -f "$CONFIG_FILE" ]]; then
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo -e "# Available COLOR_NAME options: RED, GREEN, BLUE, CYAN, WHITE" > "$CONFIG_FILE"
	echo -e "# Set RAM_MB to your desired memory size in MB" >> "$CONFIG_FILE"
	echo -e "# Set UPTIME_OVERRIDE to your desired uptime in hours" >> "$CONFIG_FILE"
	echo -e "RAM_MB=128\nUPTIME_OVERRIDE=16h\nCOLOR_NAME=CYAN" >> "$CONFIG_FILE"
fi

# Load values from the config
source "$CONFIG_FILE"

# OS
if [ -f /etc/os-release ]; then
    # linux
    OS_NAME="$(awk -F= '/^NAME=/{print $2}' /etc/os-release | tr -d '"')"
elif grep -q Microsoft /proc/version 2>/dev/null; then
    # windows subsystem for linux
    OS_NAME="WSL"
elif [[ "$(uname -o)" == "Android" ]]; then
    # Termux on Android
    OS_NAME="Android"
else
    # Mac, Windows, Fallback (such as freeBSD)
    case "$(uname -s)" in
        Darwin)
            OS_NAME="macOS"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            OS_NAME="Windows"
            ;;
        *)
            OS_NAME="$(uname -s)"
            ;;
    esac
fi


case "$OS_NAME" in
    "Arch Linux")          OS="Arch Linux (Unpaid Edition)";;           # ASCII DONE - Szerwigi1410
    "Alpine Linux")        OS="Alpine (because I can't afford a mountain)";; # 
    "Ubuntu")              OS="Ubunstu (Activate Windows Survivor)";;   # ASCII DONE - Szerwigi1410
    "Linux Mint")          OS="Linux Mint (but no teeth left)";;        # ASCII DONE - Szerwigi1410
    "Fedora Linux")        OS="Fedora (tips hat in poverty)";;          # ASCII DONE - Szerwigi1410
    "Debian GNU/Linux")    OS="Plebian 12 (brokeworm)";;                # ASCII DONE - Szerwigi1410
    "Manjaro Linux")       OS="ManjarNO (Oh Please God No)";;           # ASCII DONE - Szerwigi1410
    "EndeavourOS")         OS="EndeavourOS (Arch for fetuses)";;        #
    "openSUSE Tumbleweed") OS="openSUSE (tumbling into debt)";;         #
    "openSUSE Leap")       OS="openSUSE Leap (into the void)";;         #
    "Garuda Linux")        OS="Garuda (because RGB broke my wallet)";;  #
    "elementary OS")       OS="elementaryOS (baby's first macbook)";;   #
    "Pop!_OS")             OS="Pop!_OS (But cant afford System76)";;    # ASCII DONE - Szerwigi1410
    "Kali Linux")          OS="Kali Linux (Dollar Store hacker addition)";; #
    "Zorin OS")            OS="Zorin (Because I cant afford Windows)";; #
    "Gentoo")              OS="Gentoo (Because I cant even afford time)";; #
    "NixOS")               OS="NixOS (broke and broken by design)";;    #
    "Slackware")           OS="Slackware (no updates, no rent)";;       # ASCII IN PROGRESS - Szerwigi1410
    "Void Linux")          OS="Void (bank account matches the name)";;  #
    "Nobara Linux")        OS="Nobara (Has 500 viruses from torrents)";; #
    "Windows")             OS="Windows (Rebooting my patience)";;      # ASCII DONE - Szerwigi1410
    "macOS")               OS="macOS (Broke but still bragging)";;     # ASCII DONE - Szerwigi1410
    "WSL")                 OS="WSL (Linux for those who sold a kidney)";; #
    "Android")             OS="Android (my phone is smarter than me)";; # New satirical OS name for Android
    "FreeBSD")             OS="FreeBSD (Free software, broke user)";;   # ASCII DONE - Szerwigi1410
    *) OS="$OS_NAME (??)";;
esac

# Uptime - Linux, WSL & Android
if [ -r /proc/uptime ]; then
  UPTIME_S=$(cut -d ' ' -f1 < /proc/uptime)
  UPTIME_S=${UPTIME_S%.*}  # drop decimal part
  UPTIME_H=$(( UPTIME_S / 3600 ))
  UPTIME_M=$(( (UPTIME_S % 3600) / 60 ))
  UPTIME="${UPTIME_H} hours, ${UPTIME_M} minutes"
fi

# Uptime - macOS
if [ "$OS" = "macOS" ]; then
  BOOT_TIME=$(sysctl -n kern.boottime | awk -F'[ ,}]+' '{print $4}')
  NOW=$(date +%s)
  UPTIME_S=$((NOW - BOOT_TIME))
  UPTIME_H=$(( UPTIME_S / 3600 ))
  UPTIME_M=$(( (UPTIME_S % 3600) / 60 ))
  UPTIME="${UPTIME_H} hours, ${UPTIME_M} minutes"
fi

# Uptime - Windows
if [ "$OS_NAME" = "Windows" ]; then
  STATS=$(net stats srv 2>/dev/null | grep -i "Statistics since")
  if [ -n "$STATS" ]; then
    BOOT_TIME=$(echo "$STATS" | sed 's/.*since //')
    BOOT_TS=$(date -d "$BOOT_TIME" +%s 2>/dev/null)

    # Fallback
    if [ -z "$BOOT_TS" ]; then
      BOOT_TS=$(date -j -f "%m/%d/%Y %H:%M:%S" "$BOOT_TIME" +%s 2>/dev/null)
    fi

    if [ -n "$BOOT_TS" ]; then
      NOW=$(date +%s)
      UPTIME_S=$((NOW - BOOT_TS))
      UPTIME_H=$(( UPTIME_S / 3600 ))
      UPTIME_M=$(( (UPTIME_S % 3600) / 60 ))
      UPTIME="${UPTIME_H} hours, ${UPTIME_M} minutes"
    else
      UPTIME="The brokest"
    fi
  else
    UPTIME="Can't afford admin privilages"
  fi
fi


# RAM
MEMORY_MB=$RAM_MB

# Value of the color
COLOR=${!COLOR_NAME}

#CPU

cpu_rand=$(($RANDOM%6))

case $cpu_rand in
	0)CPU="Imaginary (thinking hard...)";;
	1)CPU="Hopes and dreams";;
	2)CPU="Two sticks rubbing together";;
	3)CPU="(Less powerful than) Atom";;
	4)CPU="Celery Acceleron";;
	5)CPU="Fentium";;
	6)CPU="Corei14billon (I wish)";;
esac

#GPU

gpu_rand=$(($RANDOM%7))

case $gpu_rand in
    0)GPU="Integrated Depression";;
    1)GPU="Nvidia (but no drivers)";;
    2)GPU="AMD (Ain't My Dollar)";;
    3)GPU="Inetl (I can't afford a real one)";;
    4)GPU="Voodoo 3Dfx (I wish)";;
    5)GPU="Radeon 7000 (from 2001)";;
    6)GPU="GeForce 256 (the first one ever made)";;
    7)GPU="Go outside for better grapchisc";;
esac

# Initialize
ASCII_DISTRO=""

# Get options
while getopts ":hva:l" option; do
   case $option in
      h) # display Help
         echo "Only the therapist can help you at this point."
         echo "Oh and btw the -v option displays the version of brokefetch EDGE."
         echo " -a lets you override ASCII art distro name"
         echo " -l lists all available ASCII arts"
         
         exit;;
      v) # display Version
         echo "brokefetch EDGE version 1.7"
         echo "Make sure to star the repository on GitHub :)"
         exit;;
      a) # Set ASCII override to what the user typed
         ASCII_DISTRO="$OPTARG"
         ;;
      l) # List available ASCII arts
         echo "Recognized Operating Systems:"
         echo "Arch Linux, Alpine Linux, Ubuntu, Linux Mint, Fedora Linux, Debian GNU/Linux, Manjaro Linux, EndeavourOS, openSUSE Tumbleweed, openSUSE Leap, Garuda Linux, elementary OS, Pop!_OS, Kali Linux, Zorin OS, Gentoo, NixOS, Slackware, Void Linux, Nobara Linux, Windows, macOS, WSL, Android and FreeBSD."
         exit;;   
     \?) # Invalid option
         echo "We don't type that here."
         exit;;   
   esac
done

# Normalize override (lowercase); fallback to OS name
if [[ -n "$ASCII_DISTRO" ]]; then
    DISTRO_TO_DISPLAY=$(echo "$ASCII_DISTRO" | tr '[:upper:]' '[:lower:]')
else
    DISTRO_TO_DISPLAY=$(echo "$OS_NAME" | tr '[:upper:]' '[:lower:]')
fi

# Reset ASCII variables before assigning
unset ascii00 ascii01 ascii02 ascii03 ascii04 ascii05 ascii06 ascii07 ascii08 ascii09 ascii10 ascii11 ascii12 ascii13 ascii14 ascii15 ascii16 ascii17 ascii18 ascii19

# Select ASCII art based on the distro name
case "$DISTRO_TO_DISPLAY" in
    "android")
        ascii00="                  .   . "
        ascii01="                   \`-.=.-' "
        ascii02="                 ,   .   .   , "
        ascii03="                 \`-._-.-._-' "
        ascii04="                  ,     .     , "
        ascii05="                   .   . .   . "
        ascii06="                 ,          , "
        ascii07="                  \`-..._...-' "
        ascii08="                /\\   _   _  /\\ "
        ascii09="               /  \\ (o) (o) /  \\ "
        ascii10="              |   |  _ . _  |   | "
        ascii11="              |   |  /   \\  |   | "
        ascii12="               \\  / .-----.. \\  / "
        ascii13="                \\/ |  ...  | \\/ "
        ascii14="                   |  ...  | "
        ascii15="                   |__...__| "
        ascii16="                   |_______| "
        ascii17="                      / "
        ascii18="                    / "
        ascii19="                                "
        ;;

    "arch" | "arch linux")
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
        ascii19="                                        "
        ;;
    "ubuntu" | "kubuntu")
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
        ascii11="+ssss${WHITE}hhhyNMMNy${COLOR}ssssssssssss${WHITE}yNMMMy${COLOR}sssssss+   "
        ascii12=".ssssssss${WHITE}dMMMNh${COLOR}ssssssssss${WHITE}hNMMMd${COLOR}ssssssss.   "
        ascii13=" /ssssssss${WHITE}hNMMM${COLOR}yh${WHITE}hyyyyhdNMMMNh${COLOR}ssssssss/    "
        ascii14="  +sssssssss${WHITE}dm${COLOR}yd${WHITE}MMMMMMMMddddy${COLOR}ssssssss+     "
        ascii15="   /sssssssssss${WHITE}hdmNNNNmyNMMMMh${COLOR}ssssss/      "
        ascii16="    .ossssssssssssssssss${WHITE}dMMMNy${COLOR}sssso.       "
        ascii17="      -+sssssssssssssssss${WHITE}yyy${COLOR}ssss+-         "
        ascii18="        \`:+ssssssssssssssssss+:\`           "
        ascii19="            .-/+oossssoo+/-.               "
        ;;
    "mint" | "linux mint")
        ascii00="${GREEN}⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⢛⣛⣛⣛⣛⣛⠻⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿   "
        ascii01="${GREEN}⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠉⠁⠀⣘⣋⣭⣭⣭⣭⣭⣭⣍⣓⠀⠈⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿   "
        ascii02="${GREEN}⣿⣿⣿⣿⣿⣿⠟⠁⠀⣀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⠀⠈⠻⣿⣿⣿⣿⣿⣿   "
        ascii03="${GREEN}⣿⣿⣿⣿⠏⠀⢀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠹⣿⣿⣿⣿   "
        ascii04="${GREEN}⣿⣿⡟⠁⠀⣰⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠈⢻⣿⣿   "
        ascii05="${GREEN}⣿⡟⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⢻⣿   "
        ascii06="${GREEN}⡿⠀⠀⣼⣿⣿⣿⣿⣿⣿⡿⠋⠉⠙⢿⣿⣿⣿⣿⣿⣿⡿⠋⠉⠻⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⢿   "
        ascii07="${GREEN}⠃⢠⣼⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣧⠀⠘   "
        ascii08="${GREEN}⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣆⡀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣾⡄   "
        ascii09="${GREEN}⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇   "
        ascii10="${GREEN}⢸⣿⣿⣿⣿⣿⣿⠿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠿⣿⣿⣿⣿⣿⣿⡇   "
        ascii11="${GREEN}⡜⣿⣿⣿⣿⣿⠃⣠⣾⢨⣿⣿⣿⡇⣿⣿⣿⣧⢸⣿⣿⣿⠀⣿⣿⣿⡇⣷⣆⠘⣿⣿⣿⣿⣿⢁   "
        ascii12="${GREEN}⣧⢹⣿⣿⣿⡇⠀⣋⣙⢈⣉⣛⣉⡁⣉⣙⣛⣉⢈⣛⣛⣛⡀⣙⣛⣉⡃⣙⣙⠀⢹⣿⣿⣿⡟⣼   "
        ascii13="${GREEN}⣿⣇⢻⣿⣿⣿⡀⠻⣿⣠⣿⣿⣿⡇⣿⣿⣿⣏⢸⣿⣿⣿⠀⣿⣿⣿⡇⣿⠟⢀⣿⣿⣿⡿⣱⣿   "
        ascii14="${GREEN}⣿⣿⡆⠙⣿⣿⣿⡆⠖⢰⣶⣶⢊⣅⢭⣭⣭⣅⡨⢭⣭⡤⣴⣴⣶⡦⡰⣶⢢⣿⣿⣿⠟⣵⣿⣿   "
        ascii15="${GREEN}⣿⣿⣿⠀⠌⢻⣿⣿⣾⠸⣿⡇⣿⣿⣾⣿⣿⣿⣿⣆⢻⡇⣨⣉⠸⡿⣠⠏⣿⣿⡿⡋⣼⣿⣿⣿   "
        ascii16="${GREEN}⣿⣿⣿⡇⡟⣠⡙⠻⣿⡌⣿⢣⣿⣿⣿⣿⣿⣿⣿⣿⡸⢼⣿⣿⡐⡇⣿⣤⠿⠋⢴⢰⣿⣿⣿⣿   "
        ascii17="${GREEN}⣿⣿⣿⡇⡇⣿⡇⠇⣬⣅⠻⠸⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⠇⠇⣫⣵⣾⣦⢸⢸⣿⣿⣿⣿   "
        ascii18="${GREEN}⣿⣿⣿⣷⠁⣿⣧⣸⣿⣿⠉⣿⣶⣯⡉⣩⣟⣛⣛⣛⠉⡉⢍⣴⣆⠀⣿⣿⣿⣿⠀⢸⣿⣿⣿⣿   "
        ascii19="${GREEN}⣿⣿⣿⣿⢼⣿⣿⣿⣿⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣾⣿⣿⣶⣿⣿⣿⣿⣤⣾⣿⣿⣿⣿   "
        ;;
    "fedora" | "fedora linux")
        ascii00="          /:-------------:\          "
        ascii01="       :-------------------::        "
        ascii02="     :-----------${WHITE}/shhOHbmp${COLOR}---:\      "
        ascii03="   /-----------${WHITE}omMMMNNNMMD${COLOR}  ---:     "
        ascii04="  :-----------${WHITE}sMMMMNMNMP${COLOR}.    ---:    "
        ascii05=" :-----------${WHITE}:MMMdP${COLOR}-------    ---\   "
        ascii06=",------------${WHITE}:MMMd${COLOR}--------    ---:   "
        ascii07=":------------${WHITE}:MMMd${COLOR}-------    .---:   "
        ascii08=":----    ${WHITE}oNMMMMMMMMMNho${COLOR}     .----:   "
        ascii09=":--     .${WHITE}+shhhMMMmhhy++${COLOR}   .------/   "
        ascii10=":-    -------${WHITE}:MMMd${COLOR}--------------:    "
        ascii11=":-   --------${WHITE}/MMMd${COLOR}-------------;     "
        ascii12=":-    ------${WHITE}/hMMMy${COLOR}------------:      "
        ascii13=":-- ${WHITE}:dMNdhhdNMMNo${COLOR}------------;       "
        ascii14=":---${WHITE}:sdNMMMMNds:${COLOR}------------:        "
        ascii15=":------${WHITE}:://:${COLOR}-------------::          "
        ascii16=":---------------------://            "
        ascii17=""
        ascii18=""
        ascii19=""
        ;;
    "debian" | "debian gnu/linux")
        ascii00="⣿⣿⡛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
        ascii01="⣿⣿⠉⠿⣛⣻⣯⣭⣇⣙⠋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
        ascii02="⢯⢋⣵⣾⣿⡿⣫⣭⣽⣿⣿⣎⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
        ascii03="⢣⣿⣿⣶⣶⣿⠿⣫⣭⣝⢿⣿⡀⢹⣿⣿⣿⣿⣿⣿⣿⣿ "
        ascii04="⢨⢒⣮⢻⡿⣯⢸⣿⣋⣹⠁⡿⠅⣸⣿⣿⣿⣿⣿⣿⣿⣿ "
        ascii05="⡈⣛⣁⣬⡤⣬⣄⠙⢟⣁⠼⠋⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿ "
        ascii06="⣿⣭⣄⠶⠀⠂⠀⠉⣿⡟⢁⠰⢀⡙⢿⣿⣿⣿⣿⣿⣿⣿ "
        ascii07="⣿⣿⡏⠌⣤⣬⣬⠠⠛⠁⠠⠀⣿⣋⢠⠙⣿⣿⣿⣿⣿⣿ "
        ascii08="⣿⣿⣿⣷⣾⣭⣭⡾⠀⡀⠂⣸⢷⣿⠀⣇⡘⣿⣿⣿⣿⣿ "
        ascii09="⣿⣿⣿⣿⣿⣿⣿⡇⠀⢕⠁⠟⠃⠈⢤⡿⢷⡈⢿⣿⣿⣿ "
        ascii10="⣿⣿⣿⣿⣿⣿⣿⡀⡁⢂⠄⠀⣶⡎⢈⡻⡈⠩⠈⢛⣿⣿ "
        ascii11="⣿⣿⣿⣿⣿⣿⡿⠐⡄⢁⠐⢸⣿⠇⢸⠀⠀⠀⢐⣿⣿⣿ "
        ascii12="⣿⣿⣿⣿⣿⣿⠇⠀⠐⠈⡃⠷⡶⠀⠘⣤⣷⣶⢹⣿⣿⣿ "
        ascii13="⣿⣿⣿⣿⡟⠋⣾⠿⠧⠠⣸⣷⣶⠀⠀⠙⢿⡿⡸⣿⣿⣿ "
        ascii14="⣿⣿⣿⣿⣷⢠⠅⡌⢎⡓⡼⢫⠣⠁⠀⣐⡀⢤⣁⣿⣿⣿ "
        ascii15="How it feels having outdated packages?"
        ascii16=""
        ascii17=""
        ascii18=""
        ascii19=""
        ;;
    "manjaro" | "manjaro linux")
        ascii00="██████████████████  ████████   "
        ascii01="██████████████████  ████████   "
        ascii02="██████████████████  ████████   "
        ascii03="██████████████████  ████████   "
        ascii04="████████            ████████   "
        ascii05="████████  ████████  ████████   "
        ascii06="████████  ████████  ████████   "
        ascii07="████████  ████████  ████████   "
        ascii08="████████  ████████  ████████   "
        ascii09="████████  ████████  ████████   "
        ascii10="████████  ████████  ████████   "
        ascii11="████████  ████████  ████████   "
        ascii12="████████  ████████  ████████   "
        ascii13="████████  ████████  ████████   "
        ascii14="You cant say you use Arch btw  "
        ascii15=""
        ascii16=""
        ascii17=""
        ascii18=""
        ascii19=""
        ;;
    "pop!_os" | "popos")
        ascii00="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii01="⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii02="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣥⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣬⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii03="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii04="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii05="⣿⣿⣿⣿⣿⣿⣿⣿⣿                                ⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii06="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii07="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii08="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii09="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii10="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii11="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii12="⣿⣿⣿⣿⣿⣿⣿⣿⣿⡛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⢛⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii13="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii14="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii15=""
        ascii16=""
        ascii17=""
        ascii18=""
        ascii19=""
        ;;
    "windows")
        win_rand=$(($RANDOM%3))
        case $win_rand in
            0)WIN="You are not getting the newer logo";;
            1)WIN="Still using Windows in $(date +%Y)? Lowkey crazy";;
            2)WIN="Check your ram and cpu usage HAHAHAHAHAHA";;
        esac
        ascii00="        ,.=:!!t3Z3z.,                  "
        ascii01="       :tt:::tt333EE3                  "
        ascii02="       Et:::ztt33EEEL @Ee.,      ..,   "
        ascii03="      ;tt:::tt333EE7 ;EEEEEEttttt33#   "
        ascii04="     :Et:::zt333EEQ. \$EEEEEttttt33QL   "
        ascii05="     it::::tt333EEF @LINUXEttttt33F    "
        ascii06="    ;3=*^\`\`\`\"*4EEV :EEEEEEttttt33@.    "
        ascii07="    ,.=::::!t=., \` @EEEEEEtttz33QF     "
        ascii08="   ;::::::::zt33)   \"4EEEtttji3P* "
        ascii09="  :t::::::::tt33.:Z3z..  `` ,..g.        "
        ascii10="  i::::::::zt33F AEEEtttt::::ztF       "
        ascii11=" ;:::::::::t33V ;EEEttttt::::t3        "
        ascii12=" E::::::::zt33L @EEEtttt::::z3F        "
        ascii13="{3=*^\`\`\`\"*4E3) ;EEEtttt:::::tZ\`        "
        ascii14="             \` :EEEEtttt::::z7         "
        ascii15=""
        ascii16=""
        ascii17="${WIN}"
        ascii18=""
        ascii19=""
        ;;
    "slackware" | "old ahh linux")
        ascii00="                    ::::::::::                   "
        ascii01="                 :::::::::::::::::::             "
        ascii02="               ::::::::::::::::::::::::::        "
        ascii03="             ::::::::${COLOR}cllcccccllllllll${COLOR}::::::      "
        ascii04="          :::::::::${WHITE}lc               dc${COLOR}:::::::   "
        ascii05="         ::::::::${WHITE}cl   clllccllll    oc${COLOR}:::::::: "
        ascii06="        :::::::::${WHITE}o   lc${COLOR}::::::::${WHITE}co   oc${COLOR}::::::::::"
        ascii07="      ::::::::::${WHITE}o    cccclc${COLOR}:::::${WHITE}clcc${COLOR}::::::::::::"
        ascii08="    :::::::::::${WHITE}lc        cclccclc${COLOR}:::::::::::::"
        ascii09="  ::::::::::::::${WHITE}lcclcc          lc${COLOR}::::::::::::"
        ascii10=""
        ascii11=""
        ascii12=""
        ascii13=""
        ascii14=""
        ascii15=""
        ascii16=""
        ascii17=""
        ascii18=""
        ascii19=""
        ;;
    "macos")
        ascii00="                    'c.          "
        ascii01="                 ,xNMM.          "
        ascii02="               .OMMMMo           "
        ascii03="               OMMM0,            "
        ascii04="     .;loddo:' loolloddol;.      "
        ascii05="   cKMMMMMMMMMMNWMMMMMMMMMM0:    "
        ascii06=" .KMMMMMMMMMMMMMMMMMMMMMMMWd.    "
        ascii07=" XMMMMLMMMMMMMMMMMMMMMMMMX.      "
        ascii08=";MMMMMMIMMMMMMMMMMMMMMMMM:       "
        ascii09=":MMMMMMMNMMMMMMMMMMMMMMMM:       "
        ascii10=".MMMMMMMMUMMMMMMMMMMMMMMMX.      "
        ascii11=" kMMMMMMMMXMMMMMMMMMMMMMMMWd.    "
        ascii12=" .XMMMMMMMMMMMMMMMMMMMMMMMMMMk   "
        ascii13="  .XMMMMMMMMMMMMMMMMMMMMMMMMK.   "
        ascii14="    kMMMMMMMMMMMMMMMMMMMMMMd     "
        ascii15="How are your kidneys doing?"
        ascii16="You still have both of them, right?"
        ascii17=""
        ascii18=""
        ascii19=""
        ;;
    "freebsd" | "paidbsd")
        ascii00="${WHITE}\`\`\`                        ${COLOR}\`       "
        ascii01="  ${WHITE}\` \`.....---...${COLOR}....--.\`\`\`   -/    "
        ascii02="  ${WHITE}+o   .--\`         ${COLOR}/y:\`      +.   "
        ascii03="   ${WHITE}yo\`:.            ${COLOR}:o      \`+-    "
        ascii04="    ${WHITE}y/               ${COLOR}-/\`   -o/     "
        ascii05="   ${WHITE}.-                  ${COLOR}::/sy+:.    "
        ascii06="   ${WHITE}/                     ${COLOR}\`--  /    "
        ascii07="  ${WHITE}\`:                          ${COLOR}:\`   "
        ascii08="  ${WHITE}\`:                          ${COLOR}:\`   "
        ascii09="   ${WHITE}/                          ${COLOR}/    "
        ascii10="   ${WHITE}.-                        ${COLOR}-.    "
        ascii11="    ${WHITE}--                      ${COLOR}-.     "
        ascii12="     ${WHITE}\`:\`                  ${COLOR}\`:\`      "
        ascii13="       ${COLOR}.--             ${COLOR}\`--.        "
        ascii14="          ${COLOR}.---.....----.           "
        ascii15="Just tell me why not linux?"
        ascii16="I'm not hating, just asking"
        ascii17=""
        ascii18=""
        ascii19=""
        ;;
esac

# === OUTPUT ===
echo -e "${COLOR}${ascii00}${RESET}$(whoami)@brokelaptop"
echo -e "${COLOR}${ascii01}${RESET}-----------------------"
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
echo -e "${COLOR}${ascii13}${BOLD}GPU:${RESET} $GPU"
echo -e "${COLOR}${ascii14}${BOLD}Memory:${RESET} ${MEMORY_MB}MB (user-defined-sadness)"
echo -e "${COLOR}${ascii15}"
echo -e "${COLOR}${ascii16}"
echo -e "${COLOR}${ascii17}"
echo -e "${COLOR}${ascii18}"
echo -e "${COLOR}${ascii19}"
echo -e "${BOLD}BROKEFETCH 🥀 1.7${RESET}"
