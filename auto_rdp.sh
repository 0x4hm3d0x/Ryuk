#auto_rdp.sh:

# Replace ngrok token
ngrok_token="2Gj3VivIdqUtInWjlsCEjPwimYZ_5R966PqF2FSWvWprGRBZL"

# Replace Google auth command
auth_cmd="DISPLAY= /opt/google/chrome-remote-desktop/start-host --code=\"4/0AfJohXkXg9XNvq0xBRFJ8WqAJ1GI8n_JWqFnuDTh8Ub-m3zR-mLMzCL2QnNNmhhRxptuDQ\" --redirect-url=\"https://remotedesktop.google.com/_/oauthredirect\" --name=\$(hostname)"

setup_gui() {
    #TODO: DE Selection
    apt-get install xfce4-session xfce4-panel xfce4-goodies xinit -y
}

download_chrome_rdp() {
    wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    dpkg -i chrome-remote-desktop_current_amd64.deb
    sudo apt --fix-broken install -y
}

setup_chrome_rdp() {
    clear
    if [[ -z "$auth_cmd" ]]; then
        echo "Go to https://remotedesktop.google.com/headless and copy auth command:"
        read auth_cmd
    else
        echo ""
    fi
    echo "[!] Authenticating chrome remote desktop "
    su datalore -c "$auth_cmd" #TODO: create a new user
}

setup_gui
download_chrome_rdp
