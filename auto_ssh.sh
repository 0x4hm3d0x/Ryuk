#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

ssh_config="/etc/ssh/sshd_config"
#ngrok_token="2W0UDZkh20lndxJ2RuvwOY5kLwp_4UTHWm1Ccog9ks2dLkF6W"

update_system() {
    echo "[+] Updating repos"
    apt-get update -y
    echo "[+] Upgrading system"
    apt-get upgrade -y
}

install_ssh_server() {
    echo "[+] Installing ssh-server"
    apt install openssh-server -y
}

change_password(){
    echo "[!] Change current password? this password will be used to login to ssh [Y/n]:"
    read pwd

    case "$pwd" in
        "y"|"Y")
            passwd
            ;;
        "n"|"N") echo "[!] keeping the current password"
            ;;
        *) echo "[!] keeping the current password"
            ;;
    esac
}
mk_ssh_backup() {
    echo "[!] Backup current ssh configuration"
    cp "$ssh_config" "$ssh_config-$(date).bak"
}


install_ngrok() {
    echo "[+] Downloading ngrok"
    wget "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz"
    tar xzf ngrok-v*.tgz
    mv ngrok /usr/local/bin/ngrok
    echo "[!] ngrok installed"
    if [[ -z "$ngrok_token" ]]; then
        echo -n "Enter ngrok token: "
        read ngrok_token
    else
        echo "" # ignore
    fi

    ngrok config add-authtoken $ngrok_token
}

allow_root_login() {
    sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' "$ssh_config"
}

start_ssh_daemon() {
    service ssh start
}

start_ngrok() {
    ngrok tcp 22
}

update_system
install_ssh_server
change_password
mk_ssh_backup
allow_root_login
start_ssh_daemon
install_ngrok
start_ngrok
