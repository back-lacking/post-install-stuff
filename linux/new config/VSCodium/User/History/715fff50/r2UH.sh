#! /bin/bash
# adding copr and other repos
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf copr enable g3tchoo/prismlauncher
sudo dnf copr enable observeroftime/betterdiscordctl
sudo dnf copr enable dsommers/openvpn3
sudo dnf copr enable phracek/PyCharm 
sudo tee -a /etc/yum.repos.d/vscodium.repo << 'EOF' # vscodium repo
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF

# install apps from repos
sudo dnf install audacity prismlauncher goverylay codium mangohud gamemode cpu-x betterdiscordctl flameshot gimp steam strawberry gnome-tweaks virt-manager xournalpp https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.noarch.rpm ffmpeg ffmpeg-devel

# codecs
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install gstreamer1-plugins-{bad-*,good-*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install lame* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia
# flatpak installs
flatpak install com.bitwarden.desktop com.discordapp.Discord com.github.Eloston.UngoogledChromium com.github.tchx84.Flatseal com.mattjakeman.ExtensionManager com.usebottles.bottles com.spotify.Client fr.handbrake.ghb md.obsidian.Obsidian org.linux_hardware.hw-probe org.onlyoffice.desktopeditors
flatpak install com.obsproject.Studio com.obsproject.Studio.Plugin.GStreamerVaapi com.obsproject.Studio.Plugin.GStreamerVaapi com.obsproject.Studio.Plugin.ScaleToSound #obs and obs deps

# installs for programs not in repos

#gnome extensions 
i