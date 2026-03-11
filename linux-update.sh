#!/bin/bash
# A simple script that takes the version of linux that its running on and uses the appropriate package manager to update the repos

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function usage(){
    cat <<EOF
        example: Usage [-d] [-y] [-A] [-a] [-p] [-z] [-h] []
        
        -z       Update using zypper package manager
        -d       Update using dnf package manager
        -A       Update using apk package manager
        -a       Update using apt package manager
        -p       Update using pacman package manager
        -y       Update using yum package manager
        -h       Display script usage

        Leave blank if you would like the script to determine what package manager to use.
EOF
}

while getopts "aydApzh" opt; do
  case $opt in
    a)
      #Update using apt package manager
      package_manager="apt"
      ;;
    y)
      #Update using yum package manager
      package_manager="yum"
      ;;
    d)
      #Update using dnf package manager
      package_manager="dnf"
      ;;
    A)
      #Update using apk package manager
      package_manager="apk"
      ;;
    p)
      #Update using pacman package manager
      package_manager="pacman"
      ;;
    z)
      #Update using zypper package manager
      package_manager="zypper"
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


package_manager_list=(apt apk yum dnf pacman zypper)

function package_manager_detection(){
    for pm in ${package_manager_list[@]}; do
        if command -v "$pm" &>/dev/null; then
            package_manager="${pm}"
            return 0
        fi
    done
    log_error "No supported package manager found"
    return 1
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

if [[ -z ${package_manager} ]]; then
    log_info "No flag given — detecting package manager from OS"
    package_manager_detection || exit 1
fi

update_system ${package_manager} || {
    log_error "Failed to update using $package_manager. Check output above for details."
    exit 1
}