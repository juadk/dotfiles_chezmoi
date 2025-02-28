#!/usr/bin/bash

# SSH keys

# Username for chezmoi
GITHUB_USERNAME=juadk

# Add vscode repo
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" |sudo tee /etc/zypp/repos.d/vscode.repo > /dev/null

# Install packages
sudo zypper in -y -n chezmoi fish fzf docker libvirt jetbrains-mono-fonts wofi waybar alacritty wlogout hyprpaper hyprland-qtutils hyprland code
sudo zypper in -y -n -t pattern kvm_tools kvm_server

# Init chezmoi to deploy dotfiles
chezmoi init git@github.com:$GITHUB_USERNAME/dotfiles_chezmoi.git
chezmoi apply

# Install software from Flatpak
flatpak install -y --noninteractive flathub app.zen_browser.zen com.slack.Slack com.spotify.Client com.brave.Browser

# Add user to some groups
sudo usermod -a -G libvirt juadk
sudo usermod -a -G docker juadk

# Enable and start services
sudo systemctl enable --now libvirtd docker sshd
