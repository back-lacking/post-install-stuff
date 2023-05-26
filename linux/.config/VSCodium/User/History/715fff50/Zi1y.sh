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
sudo dnf install audacity prismlauncher goverylay codium mangohud gamemode cpu-x betterdiscordctl flameshot gimp steam strawberry gnome-tweaks virt-manager xournalpp https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.noarch.rpm ffmpeg ffmpeg-devel hardinfo -y 

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
extensions_array=( user-theme@gnome-shell-extensions.gcampax.github.com extension-list@tu.berry drive-menu@gnome-shell-extensions.gcampax.github.com instantworkspaceswitcher@amalantony.net advanced-alt-tab@G-dH.github.com dash-to-dock@micxgx.gmail.com noannoyance@daase.net trayIconsReloaded@selfmade.pl just-perfection-desktop@just-perfection quick-settings-tweaks@qwreey pip-on-top@rafostar.github.com bluetooth-quick-connect@bjarosze.gmail.com reboottouefi@ubaygd.com batterytime@typeof.pw order-extensions@wa4557.github.com PrivacyMenu@stuarthayhurst arcmenu@arcmenu.com pano@elhan.io gsconnect@andyholmes.github.io wifiqrcode@glerro.pm.me tiling-assistant@leleat-on-github gamemode@christian.kellner.me Vitals@CoreCoding.com )

for i in "${extensions_array[@]}"
do
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=${i}" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O ${i}.zip "https://extensions.gnome.org/download-extension/${i}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${i}; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${i}
    fi
    gnome-extensions enable ${i}
    rm ${EXTENSION_ID}.zip
done

