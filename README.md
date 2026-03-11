# linux-update.sh

A portable Bash script that detects or accepts a Linux distribution's package manager and runs the appropriate system update commands. Supports the most common package managers across major distros.

---

## Supported Package Managers

| Flag | Package Manager | Distros |
|------|----------------|---------|
| `-a` | `apt` | Debian, Ubuntu, Linux Mint |
| `-y` | `yum` | CentOS, RHEL 7 and earlier |
| `-d` | `dnf` | Fedora, RHEL 8+, AlmaLinux |
| `-p` | `pacman` | Arch Linux, Manjaro |
| `-z` | `zypper` | openSUSE |
| `-A` | `apk` | Alpine Linux |

---

## Usage

```bash
./linux-update.sh [OPTIONS]
```

### Options

```
-a       Update using apt package manager
-y       Update using yum package manager
-d       Update using dnf package manager
-A       Update using apk package manager
-p       Update using pacman package manager
-z       Update using zypper package manager
-h       Display this help message
```

Leave all flags blank to let the script **auto-detect** the package manager.

### Examples

```bash
# Auto-detect package manager and update
./linux-update.sh

# Explicitly use apt (Debian/Ubuntu)
./linux-update.sh -a

# Explicitly use dnf (Fedora/RHEL 8+)
./linux-update.sh -d
```

---

## How It Works

1. If a flag is provided, the script maps it directly to the corresponding package manager and runs the update.
2. If no flag is provided, the script iterates through a list of known package managers (`apt`, `apk`, `yum`, `dnf`, `pacman`, `zypper`) and uses the first one found on the system via `command -v`.
3. If no supported package manager is found, the script exits with an error.

---

## Requirements

- Bash 4.0+
- `sudo` privileges (required to run package manager commands)

---

## Installation

```bash
# Clone the repo
git clone https://github.com/your-username/linux-update.git
cd linux-update

# Make the script executable
chmod +x linux-update.sh

# Run it
./linux-update.sh
```

---

## Notes

- The script uses `set -e`, so it will exit immediately if any command fails.
- On **Alma Linux** and **RHEL 8+** systems, prefer `-d` (dnf) over `-y` (yum), as dnf is the modern replacement.
- The auto-detection checks for `apt` before `yum`/`dnf`, so on systems with multiple package managers present, `apt` will take precedence.

---

## License

Please refer to the repository for license information.

## Contributing

Contributions are welcome! Feel free to submit pull requests or open issues for bugs and feature requests.

---

**Last Updated:** 2026-03-11