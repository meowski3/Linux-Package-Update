# Linux Repository Update Script

A simple and powerful Bash script that automatically detects your Linux distribution and uses the appropriate package manager to update system repositories and packages.

## Overview

`linux-update.sh` simplifies the process of updating Linux systems by automatically detecting the operating system and using the correct package manager. No need to remember different commands for different distributions!

## Supported Package Managers

- **APT** (Debian/Ubuntu)
- **YUM** (CentOS/RHEL)
- **DNF** (Fedora/RHEL 8+)
- **Pacman** (Arch Linux)
- **Zypper** (openSUSE)
- **APK** (Alpine Linux)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/meowski3/linux-repo-update.git
cd linux-repo-update
```

2. Make the script executable:
```bash
chmod +x linux-update.sh
```

## Usage

### Automatic Detection
Run the script without any arguments to let it automatically detect your package manager:
```bash
./linux-update.sh
```

### Manual Package Manager Selection

Update a Red Hat-based system (using yum):
```bash
./linux-update.sh -r
```

Update a Debian-based system (using apt):
```bash
./linux-update.sh -d
```

### Display Help
Show usage information:
```bash
./linux-update.sh -u
```

## Options

| Option | Description |
|--------|-------------|
| `-r` | Force update using Red Hat package manager (yum) |
| `-d` | Force update using Debian package manager (apt) |
| `-u` | Display usage information |
| (none) | Auto-detect and use the appropriate package manager |

## Features

✅ **Automatic Detection** - Detects your Linux distribution and package manager automatically
✅ **Color-Coded Output** - Clear visual feedback with color-coded log messages:
  - 🟢 Green: Information messages
  - 🟡 Yellow: Warning messages
  - 🔴 Red: Error messages

✅ **Multiple Package Managers** - Supports 6 different package managers
✅ **Error Handling** - Provides clear error messages if something goes wrong
✅ **Sudo Support** - Automatically uses `sudo` for privileged operations

## How It Works

1. **Option Parsing** - The script parses command-line arguments to determine if you want a specific package manager or auto-detection
2. **Package Manager Detection** - Checks which package managers are available on the system by looking for common commands
3. **System Update** - Runs the appropriate update commands for the detected/specified package manager
4. **Logging** - Provides clear feedback about what's happening with color-coded messages

## Update Commands by Package Manager

### APT (Debian/Ubuntu)
```bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove
```

### YUM (CentOS/RHEL)
```bash
sudo yum update -y
```

### DNF (Fedora/RHEL 8+)
```bash
sudo dnf upgrade -y
```

### Pacman (Arch Linux)
```bash
sudo pacman -Syu
```

### Zypper (openSUSE)
```bash
sudo zypper update
```

### APK (Alpine Linux)
```bash
sudo apk update
sudo apk upgrade
```

## Requirements

- Bash shell
- `sudo` privileges (required for system updates)
- One of the supported package managers installed

## Examples

### Example 1: Auto-detect and update
```bash
$ ./linux-update.sh
No version was specified, looking at the /etc/os-release and checking what package manager is available on the OS to determine what package manager to use.
[INFO] Detected APT package manager (Debian/Ubuntu)
[INFO] Running: sudo apt update && sudo apt upgrade -y
...
```

### Example 2: Force Red Hat update
```bash
$ ./linux-update.sh -r
Updating redhat based linux system using yum
[INFO] Detected YUM package manager (CentOS/RHEL)
[INFO] Running: sudo yum update -y
...
```

### Example 3: Display usage
```bash
$ ./linux-update.sh -u
    example: Usage [-d] [-r] []
    
    -r       Update redhat based systems
    -d       Update Debian based systems
    -u       Display usage

    Leave blank if you would like the script to determine what package manager to use.
```

## Error Handling

If the script encounters an error during the update process, it will:
1. Display an error message in red
2. Provide information about which package manager failed
3. Exit with a status code of 1
4. Suggest checking logs for more details

## Notes

- The script requires superuser privileges to execute package manager commands
- Running updates may take some time depending on the number of available updates
- For APT-based systems, the script also runs `autoremove` to clean up unused packages
- Errors are redirected to suppress unnecessary output, but the script will notify you if something fails

## License

Please refer to the repository for license information.

## Contributing

Contributions are welcome! Feel free to submit pull requests or open issues for bugs and feature requests.

---

**Last Updated:** 2026-02-22