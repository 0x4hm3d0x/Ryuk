#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exit 1
fi

ssh_config="/etc/ssh/sshd_config"
ngrok_token="Gj3VivIdqUtInWjlsCEjPwimYZ_5R966PqF2FSWvWprGRBZL"

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
    echo "[!] Change current password? This password will be used to login to SSH [Y/n]:"
    read pwd

    case "$pwd" in
        "y"|"Y")
            passwd
            ;;
        "n"|"N") echo "[!] Keeping the current password"
            ;;
        *) echo "[!] Keeping the current password"
            ;;
    esac
}
mk_ssh_backup() {
    echo "[!] Backup current SSH configuration"
    cp "$ssh_config" "$ssh_config-$(date).bak"
}

install_ngrok() {
    echo "[+] Downloading ngrok"
    wget "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz"
    tar xzf ngrok-v*.tgz
    mv ngrok /usr/local/bin/ngrok
    echo "[!] ngrok installed"
    ngrok config --authtoken $ngrok_token
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

chrome_rdp() {
    echo -n "Install x11, xfce [y/N]" #TODO: other Desktop Environments or window managers
    read install_x11_xfce4
    case "$install_x11_xfce4" in
        "y"|"Y")
            source auto_rdp.sh
        ;;
        "n"|"N") echo ""
        ;;
        *) echo ""
        ;;
    esac
}

update_system
install_ssh_server
change_password
mk_ssh_backup
allow_root_login
start_ssh_daemon
chrome_rdp
install_ngrok
start_ngrok
