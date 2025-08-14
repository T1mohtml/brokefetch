#!/bin/bash

# IMPORTANT NOTE: This script is called "brokefetch.sh" because it is ther most stable/recomended.
# and brokefetch_beta.sh will replcae this script 

GREEN="\033[32m"
RED="\033[31m"
BLUE="\033[34m"
CYAN="\033[36m"
WHITE="\033[37m"
YELLOW="\033[33m"
PURPLE="\033[35m"
BOLD="\033[1m"
RESET="\033[0m"
BLACK="\033[30m"
GRAY="\033[90m"

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
elif command -v brew &>/dev/null; then
    PKG_COUNT=$(brew list)
else
    PKG_COUNT="1 000 000" # Unknown package manager
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
            # A new fallback case for unknown OS
            OS_NAME="Generic Linux"
            ;;
    esac
fi


case "$OS_NAME" in
    "Adelie Linux")        OS="Adelie Linux (Are you a Action Retro?)";; #
    "Aeon")                OS="Aeon (Bro wth is that, just use something normal)";; #
    "AlmaLinux")           OS="AlmaLinux (I can't believe it's not CentOS)";; #
    "Alpine Linux")        OS="Alpine (because I can't afford a mountain)";; #
    "Amazon Linux")        OS="Amazon (sold my data to afford this)";; #
    "Arch Linux")          OS="Arch Linux (Unpaid Edition)";; #
    "Artix Linux")         OS="Artix (SystemD-broke-my-wallet-too)";; #
    "Aserdev")             OS="Aserdev (because I can't type properly)";; #
    "CentOS Linux")        OS="CentOS (no support, no money)";; #
    "Debian GNU/Linux")    OS="Plebian 12 (brokeworm)";; #
    "EndeavourOS")         OS="EndeavourOS (Arch for fetuses)";; #
    "elementary OS")       OS="elementaryOS (baby's first macbook)";; #
    "Fedora Linux")        OS="Fedora (tips hat in poverty)";; #
    "Garuda Linux")        OS="Garuda (because RGB broke my wallet)";; #
    "Gentoo")              OS="Gentoo (Because I can't even afford time)";; #
    "Linexin")             OS="Linexin (You watch Linexy too?)";; #
    "Linux Mint")          OS="Linux Mint (but no teeth left)";; #
    "Linux Lite")          OS="Linux Lite (my distro is as light as my wallet)";; #
    "Manjaro Linux")       OS="ManjarNO (Oh Please God No)";; #
    "NixOS")               OS="NixOS (broke and broken by design)";; #
    "Nobara Linux")        OS="Nobara (Has 500 viruses from torrents)";; #
    "openSUSE Tumbleweed") OS="openSUSE (tumbling into debt)";; #
    "openSUSE Leap")       OS="openSUSE Leap (into the void)";; #
    "Pop!_OS")             OS="Pop!_OS (But cant afford System76)";; #
    "Kali Linux")          OS="Kali Linux (Dollar Store hacker addition)";; #
    "Red Hat Enterprise Linux") OS="RHEL (Red Hat Enterprise Loans)";; #
    "Rocky Linux")         OS="Rocky Linux (bouncing checks)";; #
    "Slackware")           OS="Slackware (no updates, no rent)";; #
    "Solus")               OS="Solus (solo, broke and alone)";; #
    "Ubuntu")              OS="Ubunstu (Activate Windows Survivor)";; #
    "Void Linux")          OS="Void (bank account matches the name)";; #
    "Zorin OS")            OS="Zorin (Because I cant afford Windows)";; #
    "Windows")             OS="Windows (Rebooting my patience)";; #
    "macOS")               OS="macOS (Broke but still bragging)";; #
    "WSL")                 OS="WSL (Linux for those who sold a kidney)";; #
    "Android")             OS="Android (my phone is smarter than me)";; #
    "FreeBSD")             OS="FreeBSD (Free software, broke user)";; #
    *) OS="$OS_NAME (??)";;
esac

# Kernel
if [ -f /etc/os-release ]; then
    # linux
    KERNEL_NAME="$(uname -r | grep -Eio 'zen|lts|rt|realtime' | head -1)"
    case $KERNEL_NAME in
        zen)KERNEL="Zen (But no peace in life)";;
        lts)KERNEL="LTS (But no stability in life)";;
        rt)KERNEL="Realtime (But lagging in life)";;
        realtime)KERNEL="Realtime (But lagging in life)";;
        *)KERNEL="$ 0.00/hour"
    esac
elif grep -q Microsoft /proc/version 2>/dev/null; then
    # windows subsystem for linux
    KERNEL_NAME="Costs 129 dollars plus electricity."
elif [[ "$(uname -o)" == "Android" ]]; then
    # Termux on Android
    KERNEL_NAME="Android (Fake Linux ripoff)"
else
    # Mac, Windows, Fallback (such as freeBSD)
    case "$(uname -s)" in
        Darwin)
            KERNEL_NAME="Darwin (Ate my wallet)"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            KERNEL_NAME="NT (Like a tricycle the price of a Porsche)"
            ;;
        *)
            KERNEL_NAME="Generic (Synonym: Your life)"
            ;;
    esac
fi

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
if [ -f /etc/os-release ]; then
    # linux
    GPU_NAME="$(lspci | grep -Eio 'nvidia|intel|amd' | head -1)"
elif grep -q Microsoft /proc/version 2>/dev/null; then
    # windows subsystem for linux
    GPU_NAME="WSL"
elif [[ "$(uname -o)" == "Android" ]]; then
    # Termux on Android
    GPU_NAME="Android"
else
    # Mac, Windows, Fallback (such as freeBSD)
    case "$(uname -s)" in
        Darwin)
            GPU_NAME="ARM"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            GPU_NAME="Windows"
            ;;
        *)
            GPU_NAME="IDK"
            ;;
    esac
fi
case "$GPU_NAME" in
    0)GPU="Integrated Depression";;
    Nvidia)GPU="Nvidia (but no drivers)";;
    AMD)
    if [ $((RANDOM % 2)) -eq 0 ]; then
        GPU="AMD (Ain't My Dollar)"
    else
        GPU="Radeon 7000 (from 2001)"
    fi
    ;;
    Intel)GPU="Inetl (I can't afford a real one)";;
    IDK)GPU="Voodoo 3Dfx (I wish)";;
    WSL)GPU="Emulated (Like my life)";;
    Android)GPU="Adreno (from 2010)";;
    ARM)GPU="SoC (Soldered forever)";;
    Windows)GPU="Please purchase and activate to detect.";;
    *)
	if [ $((RANDOM % 2)) -eq 0 ]; then
        GPU="Go outside for better grapchisc"
    else
	    GPU="Integrated depression"
    fi
	;;
esac

#HOSTNAME

host_rand=$(($RANDOM%6))

case $host_rand in
    0)HOST="Bedroom Floor (Carpet extra)";;
    1)HOST="Creaky Desk (Chair not included)";;
    2)HOST="Atari 2600 (with 128MB RAM)";;
    3)HOST="IBM 5100 (55 pounds and counting)";;
    4)HOST="iPhone -10";;
    5)HOST="Side Closet";;
    6)HOST="Thinkpad 700T (From 1992)";;

esac

#Shell
if [ -f /etc/os-release ]; then
    # linux
    SHELL_NAME="$(echo $SHELL | grep -Ei "/bin" | awk -F "bin/" '{print $2}')"
elif grep -q Microsoft /proc/version 2>/dev/null; then
    # windows subsystem for linux
    SHELL_NAME="WSL"
elif [[ "$(uname -o)" == "Android" ]]; then
    # Termux on Android
    SHELL_NAME="Termux"
else
    # Mac, Windows, Fallback (such as freeBSD)
    case "$(uname -s)" in
        Darwin)
            SHELL_NAME="$(echo $SHELL | grep -Ei "/bin" | awk -F "bin/" '{print $2}')"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            SHELL_NAME="pwsh"
            ;;
        *)
            SHELL_NAME="idksh"
            ;;
    esac
fi

case $SHELL_NAME in
    bash)SHELLOUT="$SHELL_NAME - The standard (for failure)";;
    zsh)SHELLOUT="$SHELL_NAME - Powerful (Unlike me)";;
    fish)SHELLOUT="$SHELL_NAME - Tab key ASMR";;
#    tcsh)SHELLOUT="";;
#    csh)SHELLOUT="";;
    pwsh)SHELLOUT="$SHELL_NAME - Commands for noobs (on Windoze)";;
    sh)SHELLOUT="$SHELL_NAME - Old is gold (which I need)";;
    dash)SHELLOUT="$SHELL_NAME - Speeeeed (for debian only)";;
#    ksh)SHELLOUT="";;
    idksh)SHELLOUT="idksh - What is this? (My future)";;
    *)SHELLOUT="Your shell is so niche that we don't care about it.";;
esac

#Desktop Environment
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    DESKTOP_ENV="TTY"
elif [ -n "$XDG_CURRENT_DESKTOP" ]; then
    DESKTOP_ENV="$XDG_CURRENT_DESKTOP"
else
    DESKTOP_ENV="$(echo "$DESKTOP_SESSION" | tr '[:upper:]' '[:lower:]')"
fi

#Macos and windows and phone
case "$OS_NAME" in
    "macOS")
        DESKTOP_ENV="Aqua (because I can't afford a real desktop)";;
    "Windows")
        DESKTOP_ENV="Windows Desktop (but no money for a real OS)";;
    "WSL")
        DESKTOP_ENV="WSL Desktop (because I can't afford a real Linux)";;
    "Android")
        DESKTOP_ENV="Android Desktop (because I can't afford a real phone)";;
esac        

case "$DESKTOP_ENV" in
    "gnome") DESKTOP_ENV="Gnome (but no extensions)";;
    "kde") DESKTOP_ENV="KDE (but no Plasma)";;
    "xfce") DESKTOP_ENV="XFCE (because I can't afford KDE)";;
    "lxde") DESKTOP_ENV="LXDE (Lightweight, like my wallet)";;
    "mate") DESKTOP_ENV="MATE (because I can't afford Cinnamon)";;
    "cinnamon") DESKTOP_ENV="Cinnamon (but no money for a real desktop)";;
    "Hyprland") DESKTOP_ENV="Hyprland (Yeah Hyprland is a DE lil bro)";;
    "TTY") DESKTOP_ENV="TTY (go touch grass bro)";;
    *) DESKTOP_ENV="Unknown DE (probably broke like you)";;
esac

# Window Managers

# WM DETECION IN PROGRESS
if [ -n "$XDG_CURRENT_WM" ]; then
    WINDOW_MANAGER="$XDG_CURRENT_WM"
else
    WINDOW_MANAGER="$(echo "$XDG_SESSION_TYPE" | tr '[:upper:]' '[:lower:]')"
fi

case "$OS_NAME" in
    "macOS")
        WINDOW_MANAGER="Quartz Compositor";;
    "Windows")
        WINDOW_MANAGER="Desktop Window Manager (DWM)";;
    "WSL")
        WINDOW_MANAGER="WSL Window Manager";;
    "Android")
        WINDOW_MANAGER="Android Window Manager";;
esac

# --- Funny WM names ---
case "$WINDOW_MANAGER" in
    "Andoir Window Manager") WINDOW_MANAGER="Andoir Window Manager (Termux ig)";;
    "KWin"|"kwin"|"kwin_wayland") WINDOW_MANAGER="KWin (the KDE janitor)";;
    "Mutter"|"mutter") WINDOW_MANAGER="Mutter (the GNOME babysitter)";;
    "Sway"|"sway") WINDOW_MANAGER="Sway (i3 but woke)";;
    "i3") WINDOW_MANAGER="i3 (tiled like my bathroom)";;
    "Openbox"|"openbox") WINDOW_MANAGER="Openbox (because closed boxes cost money)";;
    "Fluxbox"|"fluxbox") WINDOW_MANAGER="Fluxbox (because stability is overrated)";;
    "XFWM4"|"xfwm4") WINDOW_MANAGER="XFWM4 (four times more broke)";;
    "Metacity"|"metacity") WINDOW_MANAGER="Metacity (meta broke)";;
    "IceWM"|"icewm") WINDOW_MANAGER="IceWM (cold and minimal, like my bank account)";;
    "FVWM"|"fvwm") WINDOW_MANAGER="FVWM (Feels Very Wallet Miserable)";;
    "awesome") WINDOW_MANAGER="awesome (self-proclaimed)";;
    "herbstluftwm") WINDOW_MANAGER="herbstluftwm (gesundheit)";;
    "wayfire") WINDOW_MANAGER="Wayfire (burning your GPU for fun)";;
    "Hyprland"|"hyprland") WINDOW_MANAGER="Aquamarine (To drown myself in)";;
    "Quartz Compositor") WINDOW_MANAGER="Quartz Compositor (shiny but overpriced)";;
    "Desktop Window Manager (DWM)") WINDOW_MANAGER="Desktop Window Manager (Windows’ least exciting acronym)";;
    "tty") WINDOW_MANAGER="tty (Idk what to say here tbh)";;
    "Wayland"|"wayland") WINDOW_MANAGER="Wayland (X11 is old and scary)";;
    "X11"|"x11") WINDOW_MANAGER="X11 (Wayland is good for toddlers)";;
    *) WINDOW_MANAGER="$WINDOW_MANAGER (probably broke like you)";;
esac

# Initialize
ASCII_DISTRO=""

# Terminal

if [ -n "$TERM" ]; then
    TERMINAL="$TERM"
else
    TERMINAL="$(echo "$TERM" | tr '[:upper:]' '[:lower:]')"
fi

case "$TERM" in
    "xterm") TERMINAL="XTerm (the original terminal, but no money for a newer one)";;
    "gnome-terminal") TERMINAL="Gnome Terminal (because I dislike gnome console)";;
    "konsole") TERMINAL="Konsole (KDE's terminal, but no money for a real one)";;
    "terminator") TERMINAL="Terminator (you are NOT Arnold Schwarzenegger)";;
    "alacritty") TERMINAL="Alacritty (because I can't afford a real terminal)";;
    "xterm-kitty" | "kitty") TERMINAL="Kitty (good terminal tbh)";;
    "rxvt-unicode") TERMINAL="Rxvt-Unicode (because I can't afford a real terminal)";;
    *) TERMINAL="Terminal of regret";;
esac

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
         echo "amazon, zorin, elementary, Arch Linux, Alpine Linux, Ubuntu, Linux Mint, Linexin, Fedora Linux, Debian GNU/Linux, Manjaro Linux, EndeavourOS, openSUSE Tumbleweed, openSUSE Leap, Garuda Linux, elementary OS, Pop!_OS, Kali Linux, Zorin OS, Gentoo, NixOS, Slackware, Void Linux, Artix Linux, Aserdev, Nobara Linux, Windows, macOS, WSL, Android and FreeBSD."
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
    "adelie linux" | "adelie")
        ascii00="                                   "
        ascii01="                                   "
        ascii02="                                   " 
        ascii03="                                   "
        ascii04="                                   "
        ascii05="${BOLD}I had issues with the adelie ascii "
        ascii06="                                   "
        ascii07="                                   "
        ascii08="                                   "
        ascii09="                                   "
        ascii10="                                   "
        ascii11="                                   "
        ascii12="                                   "
        ascii13="                                   "
        ascii14="                                   "
        ascii15=""
        ascii16="that's it"
        ascii17=""
        ascii18=""
        ascii19=""
    ;;
    "aeon")
        ascii00="⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷   "
        ascii01="⣿⡇              ⢸⣿      "
        ascii02="⣿⡇   ⢀⣀    ⣀⡀   ⢸⣿     "
        ascii03="⣿⣇   ⠸⣿⣄  ⣠⣿⠇   ⣸⣿     "
        ascii04="⢹⣿⡄   ⠙⠻⠿⠿⠟⠋   ⢠⣿⡏     "
        ascii05="⠹⣿⣦⡀          ⢀⣴⣿⠏     "
        ascii06="  ⠈⠛⢿⣶⣤⣄  ⣠⣤⣶⡿⠛⠁       "
        ascii07="     ⣠⣴⡿⠿⠛⠛⠿⢿⣦⣄        "
        ascii08="  ⣠⣾⠟⠉        ⠉⠻⣷⣄     "
        ascii09="⢰⣿⠏   ⢀⣤⣶⣶⣤⡀    ⠹⣿⡆    "
        ascii10="⣿⡟   ⢰⣿⠏⠁⠈⠹⣿⡆    ⢿⣿    "
        ascii11="⣿⡇   ⠈⠋    ⠙⠁    ⢸⣿    "
        ascii12="⣿⡇               ⢸⣿    "
        ascii13="⣿⣷⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣾⣿     "
        ascii14="                       "
        ascii15=""
        ascii16=""
        ascii17=""
        ascii18=""
        ascii19=""
        ;;
    "alpine linux" | "alpine")
        ascii00="       .hddddddddddddddddddddddh.          "
        ascii01="      :dddddddddddddddddddddddddd:         "
        ascii02="     /dddddddddddddddddddddddddddd/        "
        ascii03="    +dddddddddddddddddddddddddddddd+       "
        ascii04="  \`sdddddddddddddddddddddddddddddddds\`     "
        ascii05=" \`ydddddddddddd++hdddddddddddddddddddy\`    "
        ascii06=".hddddddddddd+\`  \`+ddddh:-sdddddddddddh.   "
        ascii07="hdddddddddd+\`      \`+y:    .sddddddddddh   "
        ascii08="ddddddddh+\`   \`//\`   \`.\`     -sddddddddd   "
        ascii09="ddddddh+\`   \`/hddh/\`   \`:s-    -sddddddd   "
        ascii10="ddddh+\`   \`/+/dddddh/\`   \`+s-    -sddddd   "
        ascii11="ddd+\`   \`/o\` :dddddddh/\`   \`oy-    .yddd   "
        ascii12="hdddyo+ohddyosdddddddddho+oydddy++ohdddh   "
        ascii13=".hddddddddddddddddddddddddddddddddddddh.   "
        ascii14=" \`yddddddddddddddddddddddddddddddddddy\`    "
        ascii15="  \`sdddddddddddddddddddddddddddddddds\`     "
        ascii16="    +dddddddddddddddddddddddddddddd+       "
        ascii17="     /dddddddddddddddddddddddddddd/        "
        ascii18="      :dddddddddddddddddddddddddd:         "
        ascii19="       .hddddddddddddddddddddddh.          "
        ;;    
    "almalinux")
        ascii00="           ${RED}ooooooooooooooooooooooooooooo                 "
        ascii01="         ${RED}oo${WHITE}...........................${RED}oo   "
        ascii02="        ${RED}o${WHITE}.                         .${RED}o      "
        ascii03="       ${RED}o${WHITE}.   .                     .   .${RED}o   "
        ascii04="      ${RED}o${WHITE}.  .                        .  .${RED}o   "
        ascii05="     ${RED}o${WHITE}. .           .    .          . .${RED}o   "
        ascii06="    ${RED}o${WHITE}. .           ..   ..         . .${RED}o    "
        ascii07="   ${RED}o${WHITE}. .          ...   ...        . .${RED}o     "
        ascii08="   ${RED}o${WHITE}. .         ....   ....       . .${RED}o     "
        ascii09="   ${RED}o${WHITE}. .        .    .    .       . .${RED}o      "
        ascii10="    ${RED}o${WHITE}. .      .    .    .        . .${RED}o      "
        ascii11="     ${RED}o${WHITE}. .    .    .    .         . .${RED}o      "
        ascii12="      ${RED}o${WHITE}. .  .    .    .          . .${RED}o      "
        ascii13="       ${RED}o${WHITE}.  .   .    .           .  .${RED}o      " 
        ascii14="        ${RED}o${WHITE}.   .                   .   .${RED}o    "
        ascii15="         ${RED}oo${WHITE}...........................${RED}oo   " 
        ascii16="          ${RED}ooooooooooooooooooooooooooooo                  "
        ascii17="         I still don't know what this is.                      "
        ascii18=""
        ascii19=""
        ;;
    "amazon")
        ascii00="  ,     S2#_S1         "
        ascii01="  ~\_  S2####_S1       "
        ascii02=" ~~  \_S2#####_S1      "
        ascii03=" ~~     _S2###|S1      "
        ascii04=" ~~       _S2#/S1 ___  "
        ascii05="  ~~       V~' '->     "
        ascii06="   ~~~         /       "
        ascii07="     ~~._.   _/        "
        ascii08="        _/ _/          "
        ascii09="      _/m/'            "
        ascii10="                       "
        ascii11=" what is this?         "
        ascii12="                       "
        ascii13="                       "
        ascii14="                       "
        ascii15="                       "
        ascii16="                       "
        ascii17="                       "
        ascii18="                       "
        ascii19="                       "
        ;;
    "android")
        ascii00="${GREEN} ⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⣀⡀       "
        ascii01="${GREEN}⠀⠀⠀⠀⠀⠙⢷⣤⣤⣴⣶⣶⣦⣤⣤⡾⠋       "
        ascii02="${GREEN}⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦       "
        ascii03="${GREEN}⠀⠀⠀⠀⣼⣿⣿⣉⣹⣿⣿⣿⣿⣏⣉⣿⣿⣧      "
        ascii04="${GREEN}⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇     "
        ascii05="${GREEN}⣠⣄⠀⢠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⡄⠀⣠⣄  "
        ascii06="${GREEN}⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿  "
        ascii07="${GREEN}⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿  "
        ascii08="${GREEN}⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿  "
        ascii09="${GREEN}⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿  "
        ascii10="${GREEN}⠻⠟⠁⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠈⠻⠟  "
        ascii11="${GREEN}⠀⠀⠀⠀⠉⠉⣿⣿⣿⡏⠉⠉⢹⣿⣿⣿⠉⠉      "
        ascii12="${GREEN}⠀⠀⠀⠀⠀⠀⣿⣿⣿⡇⠀⠀⢸⣿⣿⣿        "
        ascii13="${GREEN}⠀⠀⠀⠀⠀⠀⣿⣿⣿⡇⠀⠀⢸⣿⣿⣿        "
        ascii14="${GREEN}⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠉⠉⠁        "
        ascii15=""
        ascii16=""
        ascii17=""
        ascii18=""
        ascii19=""
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
    "artix" | "artix linux")
        ascii00="                   '                           "
        ascii01="                  'o'                          "
        ascii02="                 'ooo'                         "
        ascii03="                'ooxoo'                        "
        ascii04="               'ooxxxoo'                       "
        ascii05="              'oookkxxoo'                      "
        ascii06="             'oiioxkkxxoo'                     "
        ascii07="            ':;:iiiioxxxoo'                    "
        ascii08="               ''.;::ioxxoo'                   "
        ascii09="          '-.      '':;jiooo'                  "
        ascii10="         'oooio-..     ''i:io'                 "
        ascii11="        'ooooxxxxoio:,.   ''-;'                "
        ascii12="       'ooooxxxxxkkxoooIi:-.  ''               "
        ascii13="      'ooooxxxxxkkkkxoiiiiiji'                 "
        ascii14="     'ooooxxxxxkxxoiiii:''     .i'             "
        ascii15="    'ooooxxxxxoi:::'a       ''ioxo'            "
        ascii16="   aooooxooi::aa         .:iiixkxxo'           "
        ascii17="  aooooi:'a                a'';ioxxo'          "
        ascii18=" ai:'a                          '':io'         "
        ascii19="systemd isn't that bad bruh replace your heart "
        ;;
    "aserdev")
        ascii00="    _    ____  _____ ____       "
        ascii01="   / \  / ___|| ____|  _ \\     "
        ascii02="  / _ \ \___ \|  _| | |_) |     "
        ascii03=" / ___ \ ___) | |___|  _ <      "
        ascii04="/_/   \_\____/|_____|_| \_\\    "
        ascii05="                                "
        ascii06=" ____  _______     __           "
        ascii07="|  _ \| ____\ \   / /           "
        ascii08="| | | |  _|  \ \ / /            "
        ascii09="| |_| | |___  \ V /             "
        ascii10="|____/|_____|  \_/              "
        ascii11="                                "
        ascii12="                                "
        ascii13=" this distro doesn't even exist "
        ascii14="                                "
        ascii15="                                "
        ascii16="                                "
        ascii17="                                "
        ascii18="                                "
        ascii19="                                "
        ;;
    "centos" | "centos linux")
        ascii00="           ${BLUE}c${RED}c${YELLOW}c${GREEN}c${CYAN}c${BLUE}o${RED}o${YELLOW}o${GREEN}o${CYAN}o${BLUE}s${RED}s${YELLOW}s${GREEN}s${CYAN}s${BLUE}o${RED}o${YELLOW}o${GREEN}o${CYAN}o${WHITE}o ${COLOR}                "
        ascii01="          ${BLUE}cl${RED}cc${YELLOW}cc${GREEN}coo${CYAN}oss${BLUE}os${RED}oo${YELLOW}sss${GREEN}oo${CYAN}l.. ${COLOR}               "
        ascii02="         ${BLUE}co${RED}cc${YELLOW}oc${GREEN}co${CYAN}s${BLUE}l.${RED}c${YELLOW}oss${GREEN}o${CYAN}ls${BLUE}s${RED}s${YELLOW}s.l ${COLOR}                "
        ascii03="        ${BLUE}cosc${RED}co${YELLOW}s${GREEN}lo${CYAN}s${BLUE}s.${RED}ol${YELLOW}..${GREEN}c${CYAN}so. ${COLOR}                  "
        ascii04="        ${BLUE}co${RED}co${YELLOW}s${GREEN}s${CYAN}os.${BLUE}l${RED}..${YELLOW}o${GREEN}s.${CYAN}l.${BLUE}..${RED}o${YELLOW}s ${COLOR}                   "
        ascii05="        ${BLUE}cos${RED}so${YELLOW}sl.${GREEN}ls${CYAN}ol${BLUE}..${RED}s${YELLOW}l..${GREEN}sl${CYAN}ol ${COLOR}                "
        ascii06="        ${BLUE}co${RED}s${YELLOW}so${GREEN}s${CYAN}l.o${BLUE}l..s${RED}o.${YELLOW}l.${GREEN}ol..o${CYAN}l..${BLUE}o ${COLOR}               "
        ascii07="       ${BLUE}coc${RED}o${YELLOW}s${GREEN}s${CYAN}ol.l${BLUE}s..l${RED}s.${YELLOW}l${GREEN}o. ${CYAN}s${BLUE}l.${RED}l${YELLOW}s${GREEN}s${CYAN}o..s${BLUE}l${RED}c.s${YELLOW}o ${COLOR}           "
        ascii08="       ${BLUE}coc${RED}o${YELLOW}s${GREEN}os${CYAN}o..s${BLUE}o.o${RED}l.o${YELLOW}s.l${GREEN}c.s${CYAN}o..s${BLUE}ol.l${RED}o..${YELLOW}s${GREEN}l ${COLOR}             "
        ascii09="       ${BLUE}co${RED}s${YELLOW}so${GREEN}s${CYAN}l.o${BLUE}s.o${RED}l.o${YELLOW}s.o${GREEN}l..o${CYAN}s.o${BLUE}l..o${RED}l.o${YELLOW}s${GREEN}..${CYAN}l ${COLOR}             "
        ascii10="       ${BLUE}co${RED}s${YELLOW}o${GREEN}osl${CYAN}s${BLUE}l.${RED}so${YELLOW}l.${GREEN}so${CYAN}l..${BLUE}os.${RED}os.${YELLOW}ol..${GREEN}sl ${COLOR}              "
        ascii11="       ${BLUE}co${RED}so${YELLOW}sl${GREEN}s${CYAN}o.${BLUE}s${RED}l.l${YELLOW}s.${GREEN}o${CYAN}s..l${BLUE}s.${RED}os.${YELLOW}ol..${GREEN}os ${COLOR}              "
        ascii12="      ${BLUE}co${RED}so${YELLOW}o${GREEN}so${CYAN}osl${BLUE}s.s${RED}o${YELLOW}l..${GREEN}so${CYAN}l.${BLUE}os.${RED}ol.s${YELLOW}l.l${GREEN}s.l${CYAN}s..${BLUE}ol..s${RED}o ${COLOR}        "
        ascii13="     ${BLUE}cos${RED}o${YELLOW}ol.${GREEN}os${CYAN}ol..${BLUE}s${RED}o.${YELLOW}os${GREEN}o.${CYAN}l..${BLUE}ol..${RED}s${YELLOW}l..${GREEN}sl.osl..${CYAN}os..s${BLUE}o ${COLOR}       "
        ascii14="    ${BLUE}co${RED}so${YELLOW}o${GREEN}sl.s${CYAN}osl.l${BLUE}os.${RED}o${YELLOW}o.o${GREEN}s${CYAN}o..s${BLUE}o.${RED}s${YELLOW}o.s${GREEN}o..l${CYAN}s.${BLUE}osl.o${RED}s${YELLOW}osl..${GREEN}osl ${COLOR}   "
        ascii15="     ${COLOR}We were promised stability, not this...        "
        ascii16=""
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
    "elementary")
        ascii00="         eeeeeeeeeeeeeeeee             "
        ascii01="      eeeeeeeeeeeeeeeeeeeeeee          "
        ascii02="    eeeee  eeeeeeeeeeee   eeeee        "
        ascii03="  eeee   eeeee       eee     eeee      "
        ascii04=" eeee   eeee          eee     eeee     "
        ascii05="eee    eee            eee       eee    "
        ascii06="eee   eee            eee        eee    "
        ascii07="ee    eee         eeeee      eeeeee    "
        ascii08="ee    eee       eeeee      eeeee ee    "
        ascii09="eee   eeee   eeeeee      eeeee  eee    "
        ascii10="eee    eeeeeeeeee     eeeeee    eee    "
        ascii11=" eeeeeeeeeeeeeeeeeeeeeeee    eeeee     "
        ascii12="  eeeeeeee eeeeeeeeeeee      eeee      "
        ascii13="    eeeee                 eeeee        "
        ascii14="      eeeeeee         eeeeeee          "
        ascii15="         eeeeeeeeeeeeeeeee             "
        ascii16="                                       "
        ascii17="                                       "
        ascii18="   can you even afford a macbook?      "
        ascii19="                                       "
        ;;
    "endeavouros")
        ascii00="                     a2./a1oa3.                    "
        ascii01="                   a2./a1ssssoa3-                  "
        ascii02="                 a2asa1osssssss+a3-                "
        ascii03="               a2a:+a1ssssssssssoa3/.              "
        ascii04="             a2a-/oa1sssssssssssssoa3/.            "
        ascii05="           a2a-/+a1ssssssssssssssssoa3+:a          "
        ascii06="         a2a-:/+s1ssssssssssssssssssoa3+/.         "
        ascii07="       a2a.://oa1ssssssssssssssssssssoa3++-        "
        ascii08="      a2.://+a1sssssssssssssssssssssssoa3++:       "
        ascii09="    a2.:///oa1sssssssssssssssssssssssssoa3++:      "
        ascii10="  a2a:////a1sssssssssssssssssssssssssssoa3+++.     "
        ascii11="a2a-////+a1sssssssssssssssssssssssssssoa3++++-     "
        ascii12=" a2a..-+a1oossssssssssssssssssssssssoa3+++++/a     "
        ascii13="   a3./++++++++++++++++++++++++++++++/:.           "
        ascii14="  a:::::::::::::::::::::::::------aa               "
        ascii15="       go use arch bro,ru broke to see arch wiki   "
        ascii16=""
        ascii17=""
        ascii18=""
        ascii19=""
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
    	ascii15=""
    	ascii16="Just tell me why not linux?"
    	ascii17="I'm not hating, just asking"
    	ascii18=""
    	ascii19=""
        ;;
    "garuda linux" | "garuda")
        ascii00="                   .%;888:8898898:            "
        ascii01="                 x;XxXB%89b8:b8%b88:           "
        ascii02="              .8Xxd                8X:.        "
        ascii03="            .8Xx;                    8x:.      "
        ascii04="          .tt8x          .d            x88;    "
        ascii05="       .@8x8;          .db:              xx@;  "
        ascii06="     ,tSXX°          .bbbbbbbbbbbbbbbbbbbB8x@; "
        ascii07="   .SXxx            bBBBBBBBBBBBBBBBBBBBbSBX8; "
        ascii08=" ,888S                                     pd! "
        ascii09="8X88/                                       q  "
        ascii10="8X88/                                          "
        ascii11="GBB.                                           "  
        ascii12=" x%88        d888@8@X@X@X88X@@XX@@X@8@X.       "
        ascii13="   dxXd    dB8b8b8B8B08bB88b998888b88x.        "
        ascii14="    dxx8o                      .@@;.           "
        ascii15="      dx88                   .t@x.             "
        ascii16="        d:SS@8ba89aa67a853Sxxad.               "
        ascii17="          .d988999889889899dd.                 "
        ascii18="Indian scammer who uses an arch-based disrto?"
        ascii19="damn"
        ;; 
    "gentoo")
        ascii00="         ${PURPLE}-/oyddmdhs+:.                         "
        ascii01="     ${PURPLE}-oo2dN${COLOR}MMMMMMMMN${PURPLE}Nmhy+h1-s                  "
        ascii02="   -${PURPLE}ys2${COLOR}NMMMMMMMMMMMNNNmmdhy${PURPLE}s1+-                "
        ascii03=" ${PURPLE}dos2${COLOR}mMMMMMMMMMMMM${PURPLE}NmdmmmmdD${COLOR}hhy${PURPLE}s1/s             "
        ascii04=" ${PURPLE}oms2${COLOR}MMMMMMMMMMM${PURPLE}Ns1hhyyyos2h${COLOR}mddd${PURPLE}hhhds1oc       "
        ascii05="${PURPLE}.ys2d${COLOR}MMMMMMMMMM${PURPLE}ds1hs++so/ss2${COLOR}mdddhh${PURPLE}hhdms1+d     "
        ascii06=" ${PURPLE}oys2hdm${COLOR}NMMMMMMMN${COLOR}s1dyooys2${COLOR}dmddddhh${PURPLE}hhyhNs1d.    "
        ascii07="  ${PURPLE}:os2yhhd${COLOR}NNMMMMMMMNNNmmdddhhhhhyyms${PURPLE}1Mh        "
        ascii08="    ${PURPLE}.:s2+syd${COLOR}NMMMMMNNNmmmdddhhhhhhm${PURPLE}Ms1my        "
        ascii09="       ${PURPLE}/ms2${COLOR}MMMMMMNNNmmmdddhhhhhmM${PURPLE}Nhs1s:        "
        ascii10="    ${PURPLE}sos2N${COLOR}MMMMMMMNNNmmmddddhhdmM${PURPLE}Nhss1+s         "
        ascii11="  ${PURPLE}sss2${COLOR}NMMMMMMMMNNNmmmdddddmNM${PURPLE}mhss1/.           "
        ascii12=" ${PURPLE}/Ns2${COLOR}MMMMMMMMNNNNmmmdddmNM${PURPLE}Ndsos1:s             "
        ascii13="${PURPLE}+Ms2${COLOR}MMMMMMNNNNNmmmmdmNM${PURPLE}Ndsos1/-                "
        ascii14="${PURPLE}yMs2${COLOR}MNNNNNNNmmmmmNNM${PURPLE}mhs+/s1-s                  "
        ascii15="${PURPLE}/hs2${COLOR}MMNNNNNNNNMNdh${PURPLE}s++/s1-s                     "
        ascii16="${PURPLE}d/s2o${COLOR}hdmmdd${PURPLE}hys+++/:s1.s                        "
        ascii17="  ${PURPLE}s-//////:--.                                 "
        ascii18="see your power bill HAHAHAHAHAHA              "
        ascii19=""
        ;;
    "linuxlite")
        ascii00="          ,xXc             "
        ascii01="      .l0MMMMMO            "
        ascii02="   .kNMMMMMS2WS1MMMN,      "
        ascii03="   KMMMMMMS2KS1MMMMMMo     "
        ascii04="  'MMMMMMNS2KS1MMMMMM:     "
        ascii05="  kMMMMMMS2OS1MMMMMMO      "
        ascii06="  MMMMMMS20S1XMMMMMW.      "
        ascii07=" oMMMMMS2xS1MMMMMMM:       "
        ascii08=" WMMMMMS2xS1MMMMMMO        "
        ascii09=":MMMMMMS2OS1XMMMMW         "   
        ascii10=".0MMMMMS2xS1MMMMM;         "
        ascii11=":;cKMMWS2xS1MMMMO          "
        ascii12="'MMWMMXS2OS1MMMMl          "
        ascii13=" kMMMMKS2OS1MMMMMX:        "
        ascii14=" .WMMMMKS2OS1WMMM0c        "
        ascii15="  lMMMMMWS2OS1WMNd:'       "
        ascii16="   oollXMKS2o1Xxl;.       "
        ascii17="                           "
        ascii18="isn't 'linux' lite enough? "
        ascii19="                           "
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
        ascii15="     ;KMMMMMMMWXXWMMMMMMMk.      "
        ascii16="       .cooc,.    .,coo:.        "
        ascii17=""
        ascii18="How are your kidneys doing?"
        ascii19="You still have both of them, right?"
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
    "linexin")
        ascii00=" ⢀⣴⠿⠛⠛⠷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡾⠟⠛⠻⣦⡀"
        ascii01="⣼⠏⠀⠀⠀⠀⠈⠻⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⠟⠁⠀⠀⠀⠀⠘⣧ "
        ascii02="⣿⠀⠀⠀⠀⠀⠀⠀⠈⠙⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀⣿ "
        ascii03="⣿⠀⠀⢀⡿⠛⠷⣦⡀⠀⠀⠙⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠏⠁⠀⠀⣠⠾⠛⢻⡄⠀⠀⣿ "
        ascii04="⣿⡀⠀⢸⡇⠀⠀⠘⢿⣄⠀⠀⠀⠙⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠋⠀⠀⠀⣠⡾⠃⠀⠀⢸⡇⠀⠀⣿ "
        ascii05="⢸⡇⠀⠈⣧⠀⠀⠀⠀⠹⣧⡀⠀⠀⠀⠙⢷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⡾⠋⠀⠀⠀⠀⣴⠏⠀⠀⠀⠀⣼⠇⠀⢰⡇ "
        ascii06="⠈⣿⠀⠀⢻⡄⠀⠀⠀⠀⠘⣷⡀⠀⠀⠀⠀⠉⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡿⠋⠀⠀⠀⠀⢀⣾⠋⠀⠀⠀⠀⢠⡿⠀⠀⣾⠁ "
        ascii07="⠀⢹⣇⠀⠈⣷⠀⠀⠀⠀⠀⠘⢿⡄⠀⠀⠀⠀⠀⠈⠻⣦⡀⠀⠀⠀⠀⢀⣴⠟⠋⠀⠀⠀⠀⠀⢀⡾⠃⠀⠀⠀⠀⠀⣾⠃⠀⢰⡏⠀ "
        ascii08="⠀⠀⢿⡄⠀⠸⣧⠀⠀⠀⠀⠀⠈⢿⡄⠀⠀⠀⠀⠀⠀⠈⠻⣦⡀⢀⣴⠟⠁⠀⠀⠀⠀⠀⠀⢀⡾⠁⠀⠀⠀⠀⠀⣼⠏⠀⢀⡿⠀⠀ "
        ascii09="⠀⠀⠘⣷⡀⠀⠹⣧⠀⠀⠀⠀⠀⠈⢿⡄⠀⠀⠀⠀⠀⠀⠀⠘⣧⣼⠇⠀⠀⠀⠀⠀⠀⠀⢀⡾⠁⠀⠀⠀⠀⠀⣼⠏⠀⠀⣼⠃⠀⠀ "
        ascii10="⠀⠀⠀⠘⣷⠀⠀⠹⣧⠀⠀⠀⠀⠀⠈⢿⣄⠀⠀⠀⠀⠀⠀⠀⣿⣿⠇⠀⠀⠀⠀⠀⠀⢠⡾⠁⠀⠀⠀⠀⠀⣼⠏⠀⠀⣼⠇⠀⠀⠀ "
        ascii11="⠀⠀⠀⠀⠙⣧⡀⠀⠘⢷⡀⠀⠀⠀⠀⠀⠻⣧⡀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⢀⣴⠟⠀⠀⠀⠀⠀⢀⣾⠋⠀⠀⣼⠏⠀⠀⠀⠀ "
        ascii12="⠀⠀⠀⠀⠀⠘⢷⡄⠀⠈⢻⣄⠀⠀⠀⠀⠀⠈⠻⣦⡀⠀⠀⢰⡏⢹⣇⠀⠀⢀⣤⠟⠁⠀⠀⠀⠀⠀⣠⡿⠁⠀⢀⡾⠃⠀⠀⠀⠀⠀ "
        ascii13="⠀⠀⠀⠀⠀⠀⠈⠻⣦⡀⠀⠙⣷⡀⠀⠀⠀⢀⣀⠈⠛⠷⠶⠛⠀⠀⠛⠷⠶⠛⠁⣀⡀⠀⠀⠀⢀⣾⠟⠀⢀⣴⠟⠁⠀⠀⠀⠀⠀⠀ "
        ascii14="⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⠷⣤⣬⣿⡆⠀⠀⢾⡟⠷⠶⣦⣄⠀⠀⠀⠀⣠⣴⠶⠾⠟⣿⠀⠀⢰⣿⣥⣤⡶⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀ "
        ascii15="⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⢸⣇⠀⠀⠀⢻⣆⠀⠀⣰⡟⠁⠀⠀⣰⡇⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ "
        ascii16="⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣻⣿⣿⣿⡶⢶⣽⣷⣤⣤⡾⣫⣶⢶⣝⢷⣤⣤⣶⣯⣶⢶⣟⣿⣿⣟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ "
        ascii17="⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⣿⣿⣿⣿⣍⣸⣧⣤⡶⠟⠋⠀⠀⠙⠻⢶⣤⣸⣇⣻⡿⣿⣿⣿⠿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ "
        ascii18="⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡿⠿⠛⠛⢹⣿⣭⠥⠤⠤⠤⠤⠤⠤⠤⠤⠬⣭⣿⡏⠛⠛⠿⢿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ "
        ascii19="⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠻⠶⢦⣤⣤⡴⠶⠟⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ "
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
    "nixos")
        ascii00="$1  ▗▄   $2▗▄ ▄▖           "
        ascii01="$1 ▄▄🬸█▄▄▄$2🬸█▛ $1▃        "
        ascii02="$2   ▟▛    ▜$1▃▟🬕          "
        ascii03="$2🬋🬋🬫█      $1█🬛🬋🬋         "
        ascii04="$2 🬷▛🮃$1▙    ▟▛            "
        ascii05="$2 🬷▛$1▙    ▟▛            "
        ascii06="$2 🮃 $1▟█�$2▀▀▀█🬴▀▀        "
        ascii07="$1  ▝▀ ▀▘   $2▀▘%          "
        ascii08="                           "
        ascii09="                           "
        ascii10="keep waisting your time    "
        ascii11="                           "
        ascii12="                           "
        ascii13="                           "
        ascii14="                           "
        ascii15="                           "
        ascii16="                           "
        ascii17="                           "
        ascii18="                           "
        ascii19="                           "
        ;;
    "nobara")
        ascii00="⢀⣤⣴⣶⣶⣶⣦⣤⡀⠀⣀⣠⣤⣴⣶⣶⣶⣶⣶⣶⣶⣶⣤⣤⣀⡀"
        ascii01="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀"
        ascii02="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄"
        ascii03="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄"
        ascii04="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧"
        ascii05="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠉⠁⠀⠀⠉⠉⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧"
        ascii06="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⢀⣀⣀⡀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇"
        ascii07="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⢠⣾⣿⣿⣿⣿⣷⡄⠀⠀⠀⠻⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii08="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⣀⣀⣬⣽⣿⣿⣿⣿⣿⣿"
        ascii09="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠈⠻⢿⣿⣿⡿⠟⠁⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii10="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii11="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣤⣄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii12="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii13="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
        ascii14="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠉⠉⠛⠛⢿⣿⣿⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿"
        ascii15="⠘⢿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⠟⠁"
        ascii16="⠈⠙⠛⠛⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠛⠛⠛⠉⠁"
        ascii17=""
        ascii18="So ur a gamer huh?"
        ascii19=""
        ;;
    "opensuse tumbleweed" | "tumbleweed")
        ascii00="           ${WHITE}.;ldkO0000Okdl;.${COLOR}             "
        ascii01="       ${WHITE}.;d00xl:^''''''^:ok00d;.${COLOR}        "
        ascii02="     ${WHITE}.d00l'                'o00d.${COLOR}      "
        ascii03="   ${WHITE}.d0Kd'  ${COLOR}Okxol:;,${CYAN}.${COLOR}          ${WHITE}:O0d${COLOR}     "
        ascii04="  ${WHITE}.OK${COLOR}KKK0kOKKKKKKKKKKOxo:,      ${WHITE}lKO.${COLOR}   "
        ascii05=" ${WHITE},0K${COLOR}KKKKKKKKKKKKKKK0P^${WHITE},,,${COLOR}^dx:    ${WHITE};00,${COLOR}  "
        ascii06="${WHITE}.OK${COLOR}KKKKKKKKKKKKKKKk'${WHITE}.oOPPb.${COLOR}'0k.   ${WHITE}cKO.${COLOR} "
        ascii07="${WHITE}:KK${COLOR}KKKKKKKKKKKKKKK: ${WHITE}kKx..dd${COLOR} lKd   ${WHITE}'OK:${COLOR} "
        ascii08="${WHITE}dKK${COLOR}KKKKKKKKKOx0KKKd ${WHITE}^0KKKO'${COLOR} kKKc   ${WHITE}dKd${COLOR} "
        ascii09="${WHITE}dKK${COLOR}KKKKKKKKKK;.;oOKx,..${WHITE}^${COLOR}..;kKKK0.  ${WHITE}dKd${COLOR} "
        ascii10="${WHITE}:KK${COLOR}KKKKKKKKKK0o;...^cdxxOK0O/^^'  ${WHITE}.0K:${COLOR} "
        ascii11="${WHITE}kKK${COLOR}KKKKKKKKKKKKK0x;,,......,;od   ${WHITE}lKk${COLOR}   "
        ascii12="${WHITE}'0K${COLOR}KKKKKKKKKKKKKKKKKKKK00KKOo^   ${WHITE}c00'${COLOR}   "
        ascii13="  ${WHITE}'kK${COLOR}KKOxddxkOO00000Okxoc;''   ${WHITE}.dKk'${COLOR}   "
        ascii14="    ${WHITE}l0Ko.                    .c00l'${COLOR}    "
        ascii15="     ${WHITE}'l0Kk:.              .;xK0l'  "
        ascii16="        ${WHITE}'lkK0xl:;,,,,;:ldO0kl' "
        ascii17="            ${WHITE}'^:ldxkkkkxdl:^'    "
        ascii18=""
        ascii19=""
        ;;
    "opensuse leap" | "leap")
        ascii00="          ====             "
        ascii01="         ======            "
        ascii02="       ==== ====+          "
        ascii03="     +====    +====        "
        ascii04="   +===+        ====       "
        ascii05="  ====            ====     "
        ascii06="+===               +====   "
        ascii07="====               +====   "
        ascii08=" =====            ====     "
        ascii09="   +===+        =====      "
        ascii10="==+  =====    +===+  ===   "
        ascii11="====   ==== =====  =====   "
        ascii12="  ====  =======   ====     "
        ascii13="    ====  ===   ====       "
        ascii14="     ====+    ====         "
        ascii15="       ==== =====          "
        ascii16="         ======            "
        ascii17="           ==              "
        ascii18=""
        ascii19=""
        ;;            
    "pop!_os" | "popos")
        ascii00="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii01="⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii02="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣥⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣬⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii03="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii04="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii05="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀Coca-cola ⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii06="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii07="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii08="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii09="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii10="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii11="⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii12="⣿⣿⣿⣿⣿⣿⣿⣿⣿⡛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⢛⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii13="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii14="⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ "
	    ascii15=""
	    ascii16=""
	    ascii17=""
	    ascii18=""
	    ascii19=""
        ;;
    "kali linux" | "kali")
        ascii00="..............                                  "
        ascii01="            ..,;:ccc,.                          "
        ascii02="          ......''';lxO.                        "
        ascii03=".....''''..........,:ld;                        "
        ascii04="           .';;;:::;,,.x,                       "
        ascii05="      ..'''.            0Xxoc:,.  ...           "
        ascii06="  ....                ,ONkc;,;cokOdc',.         "
        ascii07=" .                   OMo           ':${GRAY}dd${COLOR}o.       "
        ascii08="                    dMc               :OO;      "
        ascii09="                    0M.                 .:o.    "
        ascii10="                    ;Wd                         "
        ascii11="                     ;XO,                       "
        ascii12="                       ,d0Odlc;,..              "
        ascii13="                           ..',;:cdOOd::,.      "
        ascii14="                                    .:d;.':;.   "
        ascii15="                                       'd,  .'  "
        ascii16="                                         ;l   .."
        ascii17="                                          .o    "
        ascii18="                                            c   "
        ascii19="                                            .'  " 
        ;;    
    "rhel")
        ascii00="           .MMM..:MMMMMMM                  "
        ascii01="          MMMMMMMMMMMMMMMMMM               "
        ascii02="          MMMMMMMMMMMMMMMMMMMM.            "
        ascii03="        MMMMMMMMMMMMMMMMMMMMMMMM           "
        ascii04="  .MMMM'  MMMMMMMMMMMMMMMMMMMMMM           "
        ascii05=" MMMMMM    'MMMMMMMMMMMMMMMMMMMM.          "
        ascii06="MMMMMMMM      MMMMMMMMMMMMMMMMMM .         "
        ascii07="MMMMMMMMM.       'MMMMMMMMMMMMM' MM.       "
        ascii08="MMMMMMMMMMM.                     MMMM      "
        ascii09="'MMMMMMMMMMMMM.                 ,MMMMM.    "
        ascii10=" 'MMMMMMMMMMMMMMMMM.          ,MMMMMMMM.   "
        ascii11="    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM   "
        ascii12="         MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    "
        ascii13="            'MMMMMMMMMMMMMMMMMMMMMMMM:     "
        ascii14="               ''MMMMMMMMMMMMMMMMM'        "
        ascii15="      this is a scam go buy a mac          "
        ascii16="                                           "
        ascii17="                                           "
        ascii18="                                           "
        ascii19="                                           "
        ;;
    "rockylinux")
        ascii00="       _     _       _         _    _             "
        ascii01="      | |   | |     | |       | |  | |            "
        ascii02="      | | __| | __ _| | __   _| |_ | |__  _   _   "
        ascii03="  _   | |/ _\` |/ _\` | |/ /  | '_ \| '_ \| | | | "
        ascii04=" | |__| | (_| | (_| |   <   | |_) | |_) | |_| |   "
        ascii05="  \____/ \__,_|\__,_|_|\_\   |_.__/|_.__/ \__, |  "
        ascii06="                                          __/ |   "
        ascii07="                                         |___/    "
        ascii08="                                                  "
        ascii09="           Rocky is my bank account.              "
        ascii10="                 Very rocky.                      "
        ascii11="                                                  "
        ascii12="                                                  "
        ascii13="                                                  "
        ascii14="                                                  "
        ascii15="                                                  "
        ascii16="                                                  "
        ascii17="                                                  "
        ascii18="                                                  "
        ascii19="                                                  "
        ;;
    "slackware" | "old ahh linux")
        ascii00="                  :::::::                      "
        ascii01="            :::::::::::::::::::                "
        ascii02="         ::::::::::::::::::::::::::            "
        ascii03="       ::::::::${WHITE}cllcccccllllllll${COLOR}::::::          "
        ascii04="    :::::::::${WHITE}lc               dc${COLOR}:::::::        "
        ascii05="   ::::::::${WHITE}cl   clllccllll    oc${COLOR}:::::::::      "
        ascii06="  :::::::::${WHITE}o   lc${COLOR}::::::::${WHITE}co   oc${COLOR}::::::::::     "
        ascii07=" ::::::::::${WHITE}o    cccclc${COLOR}:::::${WHITE}clcc${COLOR}::::::::::::    "
        ascii08=" :::::::::::${WHITE}lc        cclccclc${COLOR}:::::::::::::    "
        ascii09="::::::::::::::${WHITE}lcclcc          lc${COLOR}::::::::::::   "
        ascii10="::::::::::${WHITE}cclcc${COLOR}:::::${WHITE}lccclc     oc${COLOR}:::::::::::   "
        ascii11="::::::::::${WHITE}o    l${COLOR}::::::::::${WHITE}l    lc${COLOR}:::::::::::   "
        ascii12=" :::::${WHITE}cll${COLOR}:${WHITE}o     clcllcccll     o${COLOR}:::::::::::    "
        ascii13=" :::::${WHITE}occ${COLOR}:${WHITE}o                  clc${COLOR}:::::::::::    "
        ascii14="  ::::${WHITE}ocl${COLOR}:${WHITE}ccslclccclclccclclc${COLOR}:::::::::::::     "
        ascii15="   :::${WHITE}oclcccccccccccccllllllllllllll${COLOR}:::::      "
        ascii16="      ::::::::::::::::::::::::::::::::        "
        ascii17="         ::::::::::::::::::::::::::::  "
        ascii18="           ::::::::::::::::::::::       "
        ascii19="${BLUE}     BOOMER i bet your pc is from the 90s              "
        ;;
    "solus")
        ascii00="         ...........        "       
	    ascii01="⠀⠀⠀⠀⠀⠀⢀⣤⣾⡿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣀⠀⠀⠀⠀⠀ ⠀⠀"
	    ascii02="⠀⠀⠀⠀⣠⣾⣿⣿⣿⠃⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀ ⠀⠀"
	    ascii03="⠀⠀⢀⣾⣿⣿⣿⣿⠏⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀ ⠀"
	    ascii04="⠀⢠⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀ ⠀"
	    ascii05="⠀⣾⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⢸⣿⡙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀ "
	    ascii05="⢸⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣧⠀⠙⢿⣿⡻⠿⣿⣿⣿⣿⣿⣧⠀ "
	    ascii06="⣸⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⠀⠀⠀⠻⣿⣶⡄⠈⠙⠻⢿⣿⠀ "
	    ascii07="⢸⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠈⢿⣿⣆⠀⠀⢀⣿⠇ "
	    ascii08="⠘⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⢻⣿⢀⣴⠟⡇⠀ "
	    ascii09="⠘⠿⣿⣶⣶⣦⣤⣤⣤⣤⣀⣀⣀⣀⣀⣿⡟⠀⠀⣀⣀⣀⣤⣴⠿⢛⠡⡚⠁ ⠀"
	    ascii10="⠀⠀⠹⡿⠿⠿⠿⠿⠿⠿⣿⡿⠿⠿⠿⠿⠿⠿⠟⠛⣛⠉⠅⠐⠈⠀⡔⠀⠀ ⠀"
	    ascii11="⠀⠀⠀⠑⢄⠀⠀⠀⠐⠒⠒⠒⠒⠂⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⡠⠊⠀⠀⠀⠀ "
	    ascii12="⠀⠀⠀⠀⠀⠁⠠⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠄⠊⠀⠀⠀⠀⠀ ⠀"
	    ascii13="⠀⠀⠀⠀⠀⠀⠀⠀⠉⠒⠠⠤⢀⢀⣀⡀⠀⠤⠄⠒⠈⠀⠀⠀⠀⠀⠀⠀ ⠀⠀"
 	    ascii14="                               "
        ascii15="I'm all alone on this distro.    "
        ascii16=""
      	ascii17=""
    	ascii18=""
     	ascii19=""
        ;;
    "ubuntu" | "kubuntu" | "lubuntu" | "xubuntu" | "ubuntustudio" | "ubuntu mate" | "ubuntu budgie")
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
    "void linux" | "void")
        ascii00="${YELLOW}                __.;=====;.__                                  "
        ascii01="${YELLOW}            _.=+==++=++=+=+===;.                               "
        ascii02="${YELLOW}             -=+++=+===+=+=+++++=_                             "
        ascii03="${YELLOW}        .     -=:``     ##==+=++==.                              "
        ascii04="${YELLOW}       _vi,    #            --+=++++:                          "
        ascii05="${YELLOW}      .uvnvi.       _._       -==+==+.                         "
        ascii06="${YELLOW}     .vvnvnI%    ;==|==;.     :|=||=|.                         "
        ascii07="${YELLOW}32+QmQQm31pvvnv;32 _yYsyQQWUUQQQm #QmQ#31:32QQQWUV3QQm.        "
        ascii08="${YELLOW} 32-QQWQW31pvvo32wZ?.wQQQE31==<32QWWQ/QWQW.QQWW31(:32 jQWQE    "
        ascii09="${YELLOW}  32-3QQQQmmU'  jQQQ31@+=<32QWQQ)mQQQ.mQQQC31+;32jWQQ@'        "
        ascii10="${YELLOW}   32-3WQ8Y31nI:32   QWQQwgQQWV#1#32mWQQ.jWQQQgyyWW#m          "
        ascii11="${YELLOW}     31-1vvnvv.     #~+++##        ++|+++                      "
        ascii12="${YELLOW}      +vnvnnv,                 332==                           "
        ascii13="${YELLOW}       +vnvnvns.           .      :=-                          "
        ascii14="${YELLOW}        -Invnvvnsi..___..=sv=.     .                           "
        ascii15="${YELLOW}          +Invnvnvnnnnnnnnvvnn4.                               "
        ascii16="${YELLOW}            ~|Invnvnvvnvvvnnv}+4                               "
        ascii17="${YELLOW}               -~|{*l}*|~%                                     "
        ascii18="${YELLOW}                      what is that                             "
        ascii19=""
        ;;
    "windows" | wsl)
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
	    ascii08="   ;::::::::zt33)   \"4EEEtttji3P*      "
	    ascii09="  :t::::::::tt33.:Z3z..  `` ,..g.        "
	    ascii10="  i::::::::zt33F AEEEtttt::::ztF       "
	    ascii11=" ;:::::::::t33V ;EEEttttt::::t3        "
	    ascii12=" E::::::::zt33L @EEEtttt::::z3F        "
	    ascii13="{3=*^\`\`\`\"*4E3) ;EEEtttt:::::tZ\`        "
	    ascii14="             \` :EEEEtttt::::z7         "
	    ascii15="                 \"VEzjt:;;z>*\`         "
	    ascii16=""
	    ascii17="${WIN}"
	    ascii18=""
	    ascii19=""
        ;;
    "zorin")
        ascii00="        'osssssssssssssssssssso'           "
        ascii01="       .osssssssssssssssssssssso.          "
        ascii02="      .+oooooooooooooooooooooooo+.         "
        ascii03="                                           "
        ascii04="  '::::::::::::::::::::::.         .:'     "
        ascii05=" '+ssssssssssssssssss+:.'     '.:+ssso'    "
        ascii06="ssssssssssssso/-'      '-/osssssssssssss   "
        ascii07=" '+sss+:.      '.:+ssssssssssssssssss+'    "
        ascii08="  ':.         .::::::::::::::::::::::'     "
        ascii09="                                           "
        ascii10="      .+oooooooooooooooooooooooo+'         "
        ascii11="       'osssssssssssssssssssssso'          "
        ascii12="        'osssssssssssssssssssso'           "   
        ascii13="                                           "
        ascii14="                                           "
        ascii15="                                           "
        ascii16="    if linux replaced macbooks             "
        ascii17="                                           "
        ascii18="                                           "
        ascii19="                                           "
        ;;
    *)
        # Default ASCII art for unknown distros
        ascii00="${YELLOW}        S2#####                    "
        ascii01="${YELLOW}       S2#######                   "
        ascii02="${YELLOW}       S2###1O#2##1O#2##           "
        ascii03="${YELLOW}       S2##3#######2#              "
        ascii04="${YELLOW}     S2##S1##S3###S1##S2##         "
        ascii05="${YELLOW}    S2#S1##########S2##            "
        ascii06="${YELLOW}   S2#S1############S2##           "
        ascii07="${YELLOW}   S2#S1############S2###          "
        ascii08="${YELLOW}  S2##S2#S1###########S2##S3##     "
        ascii09="${YELLOW}S2######S2#S1#######S2#S3######    "
        ascii10="${YELLOW}S2#######S2#S1#####S2#S3#######    "
        ascii11="${YELLOW}  S2######2########3#####          "
        ascii12="${YELLOW}                                   "
        ascii13="${YELLOW}                                   "
        ascii14="${YELLOW}   wth are you using this for?     "
        ascii15="${YELLOW}                                   "
        ascii16="${YELLOW}                                   "
        ascii17="${YELLOW}                                   "
        ascii18="${YELLOW}                                   "
        ascii19="${YELLOW}                                   "
        ;;
esac

# === OUTPUT ===
echo -e "${COLOR}${ascii00}${RESET}$(whoami)@brokelaptop"
echo -e "${COLOR}${ascii01}${RESET}-----------------------"
echo -e "${COLOR}${ascii02}${BOLD}OS:${RESET} $OS"
echo -e "${COLOR}${ascii03}${BOLD}Host:${RESET} $HOST"
echo -e "${COLOR}${ascii04}${BOLD}Kernel:${RESET} $KERNEL"
echo -e "${COLOR}${ascii05}${BOLD}Uptime:${RESET} $UPTIME (sleep not included)"
echo -e "${COLOR}${ascii06}${BOLD}Packages:${RESET} $PKG_COUNT (none legal)"
echo -e "${COLOR}${ascii07}${BOLD}Shell:${RESET} $SHELLOUT"
echo -e "${COLOR}${ascii08}${BOLD}Resolution:${RESET} CRT 640x480"
echo -e "${COLOR}${ascii09}${BOLD}DE:${RESET} $DESKTOP_ENV" #Crying
echo -e "${COLOR}${ascii10}${BOLD}WM:${RESET} $WINDOW_MANAGER"
echo -e "${COLOR}${ascii11}${BOLD}Terminal:${RESET} $TERMINAL"
echo -e "${COLOR}${ascii12}${BOLD}CPU:${RESET} $CPU"
echo -e "${COLOR}${ascii13}${BOLD}GPU:${RESET} $GPU"
echo -e "${COLOR}${ascii14}${BOLD}Memory:${RESET} ${MEMORY_MB}MB (user-defined-sadness)"
echo -e "${COLOR}${ascii15}"
echo -e "${COLOR}${ascii16}"
echo -e "${COLOR}${ascii17}"
echo -e "${COLOR}${ascii18}"
echo -e "${COLOR}${ascii19}"
echo -e "${BOLD}BROKEFETCH 🥀 1.7${RESET}"
