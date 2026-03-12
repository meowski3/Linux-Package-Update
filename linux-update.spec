Name:           linux-update
Version:        1.0.0
Release:        1%{?dist}
Summary:        A portable script to update Linux systems using the appropriate package manager
License:        FIXME
URL:            https://github.com/your-username/linux-update
Source0:        linux-update.sh
BuildArch:      noarch

# Bash is the only runtime requirement
Requires:       bash

%description
linux-update is a portable Bash script that detects or accepts a Linux
distribution's package manager and runs the appropriate system update commands.

Supported package managers:
  - apt     (Debian/Ubuntu)
  - yum     (CentOS/RHEL 7)
  - dnf     (Fedora, RHEL 8+, AlmaLinux, Rocky Linux)
  - pacman  (Arch Linux)
  - zypper  (openSUSE)
  - apk     (Alpine Linux)

%prep
# Nothing to unpack — Source0 is the raw script

%build
# Nothing to compile

%install
mkdir -p %{buildroot}%{_bindir}
install -m 0755 %{SOURCE0} %{buildroot}%{_bindir}/linux-update

%files
%{_bindir}/linux-update

%post
echo "linux-update installed. Run 'linux-update -h' to see usage."

%preun
# Nothing to clean up

%changelog
* %(date "+%a %b %d %Y")- 1.0.0-1
- Initial RPM release
- Supports apt, yum, dnf, pacman, zypper, and apk package managers
- Auto-detects package manager if no flag is provided