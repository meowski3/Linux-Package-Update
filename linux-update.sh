#!/bin/bash
# A simple script that takes the version of linux that its running on and uses the appropriate package manager to update the repos

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function usage(){
    cat <<EOF
        example: Usage [-d] [-r] [-A] [-a] [-p] [-o] [-h] []
        
        -r       Update Redhat based systems
        -d       Update Debian based systems
        -A       Update Arch based systems
        -a       Update Alma based systems
        -p       Update Alpine based systems
        -o       Update Opensuse based systems
        -h       Display script usage

        Leave blank if you would like the script to determine what package manager to use.
EOF
}

alma_linux=0
alpine_linux=0
opensuse_linux=0
arch_linux=0
redhat_linux=0
debian_linux=0
while getopts "drhoAap" opt; do
  case $opt in
    d)
      #Updating debian based linux systems
      debian_linux=1
      ;;
    r)
      #Updating redhat based linux systems
      redhat_linux=1
      ;;
    A)
      #Updating arch based linux systems
      arch_linux=1
      ;;
    a)
      #Updating alma based linux systems
      alma_linux=1
      ;;
    p)
      #Updating alpine based linux systems
      alpine_linux=1
      ;;
    o)
      #Updating debian based linux systems
      opensuse_linux=1
      ;;
    h)
      # Display script usage
      usage
      exit
      ;;
    \?)
      # Handle invalid options (getopts sets $opt to ?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
  esac
done

# Shift positional parameters past the options
shift $((OPTIND - 1))

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

function log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

function log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}


function package_manager_detection(){

    if command -v apt-get &> /dev/null; then
        package_manager="apt"
    elif command -v yum &> /dev/null; then
        package_manager="yum"
    elif command -v dnf &> /dev/null; then
        package_manager="dnf"
    elif command -v pacman &> /dev/null; then
        package_manager="pacman"
    elif command -v zypper &> /dev/null; then
        package_manager="zypper"
    elif command -v apk &> /dev/null; then
        package_manager="apk"
    else
        echo "unknown"
    fi
}

function update_system() {
    pm=$1
    
    case "$pm" in
        apt)
            log_info "Detected APT package manager (Debian/Ubuntu)"
            log_info "Running: sudo apt update && sudo apt upgrade -y"
            sudo apt update;sudo apt upgrade -y;sudo apt autoremove
            ;;
        yum)
            log_info "Detected YUM package manager (CentOS/RHEL)"
            log_info "Running: sudo yum update -y"
            sudo yum update -y
            ;;
        dnf)
            log_info "Detected DNF package manager (Fedora/RHEL 8+)"
            log_info "Running: sudo dnf upgrade -y"
            sudo dnf upgrade -y
            ;;
        pacman)
            log_info "Detected Pacman package manager (Arch Linux)"
            log_info "Running: sudo pacman -Syu"
            sudo pacman -Syu
            ;;
        zypper)
            log_info "Detected Zypper package manager (openSUSE)"
            log_info "Running: sudo zypper update"
            sudo zypper update
            ;;
        apk)
            log_info "Detected APK package manager (Alpine Linux)"
            log_info "Running: sudo apk update && sudo apk upgrade"
            sudo apk update
            sudo apk upgrade
            ;;
        *)
            log_error "Unknown or unsupported package manager"
            exit 1
            ;;
    esac
}

#This function is just meant to be ran in case of a failure to notify the user on the console
function update_fail(){
    log_error "No luck updating the system using $1, please try again or check logs to see what the issue might be."
    exit 1
}

if (( redhat_linux )); then
    echo "Updating redhat based linux system using yum"
    update_system "yum" 2>/dev/null || update_fail "yum"
elif (( debian_linux )); then
    echo "Updating debian based linux system using apt"
    update_system "apt" 2>/dev/null || update_fail "apt"
elif (( arch_linux )); then
    echo "Updating debian based linux system using pacman"
    update_system "pacman" 2>/dev/null || update_fail "pacman"
elif (( alma_linux )); then
    echo "Updating debian based linux system using yum"
    update_system "yum" 2>/dev/null || update_fail "yum"
elif (( alpine_linux )); then
    echo "Updating debian based linux system using apk"
    update_system "apk" 2>/dev/null || update_fail "apk"
elif (( opensuse_linux )); then
    echo "Updating debian based linux system using zypper"
    update_system "zypper" 2>/dev/null || update_fail "zypper"
else
    echo "No version was specified, looking at the /etc/os-release and checking what package manager is available on the OS to determine how to update the system."
    package_manager_detection || log_error "Package detection failed"
    update_system ${package_manager} 2>/dev/null || update_fail ${package_manager}
fi