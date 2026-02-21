#!/bin/bash
# A simple script that takes the version of linux that its running on and uses the appropriate package manager to update the repos

function usage(){
    cat <<EOF
        example: Usage [-d] [-r]
        
        -r       Update redhat based systems
        -d       Update Debian based systems
        -u       Display usage
EOF
}

redhat_linux=0
debian_linux=0
while getopts "dru" opt; do
  case $opt in
    d)
      #Updating debian based linux systems
      debian_linux=1
      ;;
    r)
      #Updating redhat based linux systems
      redhat_linux=1
      ;;
    u)
      # Display script usage
      usage
      exit
      ;;
    \?)
      # Handle invalid options (getopts sets $opt to ?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
    :)
      # Handle missing arguments (if a required arg is missing)
      echo "Option -$OPTARG requires an argument." >&2
      ;;
  esac
done

# Shift positional parameters past the options
shift $((OPTIND - 1))

#This function will be ran on the system to actually update it
function update(){
    sudo $1 update;sudo $1 upgrade;sudo $1 autoremove
}

#This function is just meant to be ran in case of a failure to notify the user on the console
function update_fail(){
    echo "No luck updating the system using $1, please try again."
}

if (( redhat_linux )); then
    echo "Updating redhat based linux system using yum"
    update "yum" 2>/dev/null || update_fail "yum"
elif (( debian_linux )); then
    echo "Updating debian based linux system using apt"
    update "apt" 2>/dev/null || update_fail "apt"
else
    echo "No version was specified, looking at the /etc/os-release info to determine what package manager to use."
    linux_version=$(cat /etc/os-release | head -1)

    if [[ ${linux_version} =~ "Fedora" || ${linux_version} =~ "Alma" || ${linux_version} =~ "CentOS" ]]; then
        echo "Updating redhat based linux system using yum"
        update "yum" 2>/dev/null || update_fail "yum"
    elif [[ ${linux_version} =~ "Debian" || ${linux_version} =~ "Ubuntu" ]]; then
        echo "Updating debian based linux system using apt"
        update "apt" 2>/dev/null || update_fail "apt"
    else
        echo "Unkown linux distro"
    fi
fi