#!/bin/bash
# adding copr and other repos
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf copr enable g3tchoo/prismlauncher -y
sudo dnf copr enable observeroftime/betterdiscordctl -y
sudo dnf copr enable dsommers/openvpn3 -y
sudo dnf copr enable phracek/PyCharm -y
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

sudo dnf update -y

# install apps from repos
sudo dnf install glib-devel gtk+-devel zlib-devel libsoup-devel json-glib-devel gtk2-devel cmake pciutils-devel gcc gcc-c++ make wxGTK3 wxGTK3-devel -y # install build deps 
sudo dnf https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.noarch.rpm -y # virtio drivers 
sudo dnf install lm_sensors btop powertop audacity prismlauncher mangohud goverlay codium gamemode cpu-x betterdiscordctl flameshot gimp steam strawberry gnome-tweaks virt-manager xournalpp ffmpeg ffmpeg-devel dconf-editor -y --allowerasing

# codecs
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install gstreamer1-plugins-{bad-*,good-*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y
sudo dnf upgrade -y
# flatpak installs
flatpak install com.bitwarden.desktop com.discordapp.Discord com.github.Eloston.UngoogledChromium com.github.tchx84.Flatseal com.mattjakeman.ExtensionManager com.usebottles.bottles com.spotify.Client fr.handbrake.ghb md.obsidian.Obsidian org.linux_hardware.hw-probe org.onlyoffice.desktopeditors -y
flatpak install com.obsproject.Studio com.obsproject.Studio.Plugin.GStreamerVaapi  com.obsproject.Studio.Plugin.ScaleToSound com.obsproject.Studio.Plugin.OBSVkCapture -y #obs and obs deps

# downloads for programs not in repos
curl -LOJ https://github.com/syncthing/syncthing/releases/download/v1.23.5/syncthing-linux-amd64-v1.23.5.tar.gz
git clone https://github.com/FlyGoat/RyzenAdj.git
git clone https://github.com/alberthdev/wxwabbitemu.git
git clone https://github.com/lpereira/hardinfo.git
git clone https://github.com/AdnanHodzic/auto-cpufreq.git

# make dirs for user systemd service files and bins
mkdir ~/.config/systemd/
mkdir ~/.config/systemd/user
mkdir ~/.local/bin/

#icon folder move 
mv ./post-install-stuff/linux/icons ~/Pictures
#install auto-cpufreq
cd auto-cpufreq && sudo ./auto-cpufreq-installer 

# building and installing hardinfo
mkdir ./hardinfo/build && cd ./hardinfo/build 
cmake .. 
make 
sudo make install 
cd .. && cd .. 
rm -rf hardinfo 

# building and installing wxwabbitemu
cd wxwabbitemu  
make 
sudo make install 
cd ..
rm -rf wxwabbitemu

#building and installing ryzenadj
mkdir ./RyzenAdj/build && cd ./RyzenAdj/build 
cmake -DCMAKE_BUILD_TYPE=Release ..
make
cd .. && cd ..
sudo mv ./RyzenAdj/build/ryzenadj /usr/bin/
rm -rf RyzenAdj
sudo mv ./post-install-stuff/linux/service-files/ryzenAdj.service /usr/lib/systemd/system/
systemctl enable ryzenAdj.service

#install syncthing
tar -xvzf syncthing-linux-amd64-v1.23.5.tar.gz   
sudo mv ./syncthing-linux-amd64-v1.23.5/syncthing ~/.local/bin/
sudo mv ./post-install-stuff/linux/service-files/syncthing.service ~/.config/systemd/user/
rm -rf syncthing*

sudo mv ./post-install-stuff/linux/desktop-files/*.desktop ~/.local/share/applications/ #move desktop files to approprate place

#gnome extensions 
extensions_array=( user-theme@gnome-shell-extensions.gcampax.github.com extension-list@tu.berry drive-menu@gnome-shell-extensions.gcampax.github.com instantworkspaceswitcher@amalantony.net advanced-alt-tab@G-dH.github.com dash-to-dock@micxgx.gmail.com noannoyance@daase.net trayIconsReloaded@selfmade.pl just-perfection-desktop@just-perfection quick-settings-tweaks@qwreey pip-on-top@rafostar.github.com bluetooth-quick-connect@bjarosze.gmail.com reboottouefi@ubaygd.com batterytime@typeof.pw order-extensions@wa4557.github.com PrivacyMenu@stuarthayhurst arcmenu@arcmenu.com pano@elhan.io gsconnect@andyholmes.github.io wifiqrcode@glerro.pm.me tiling-assistant@leleat-on-github gamemode@christian.kellner.me Vitals@CoreCoding.com )

for i in "${extensions_array[@]}"
do
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=${i}" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O ${i}.zip "https://extensions.gnome.org/download-extension/${i}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${i}; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtensions ${i}
    fi
    gnome-extensions enable ${i}
    rm ${EXTENSION_ID}.zip
done

sudo mv -f "./post-install-stuff/linux/.config" ~/.config
mv ./post-install-stuff/linux/icons ./post-install-stuff/Wallpapers/ ~/Pictures

#loading settings 
dconf load /org/gnome/ < ./post-install-stuff/linux/gnome-setttings.ini
mv "./post-install-stuff/linux/.bashrc" ~/