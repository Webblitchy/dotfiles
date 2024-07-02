#!/bin/bash

function asUser {
	if [[ $# -lt 1 ]]; then
		echo "Enter a parameter !"
		return
	fi

	sudo -u $SUDO_USER $@
}

if (($EUID != 0)); then
	echo "Please run as root"
	exit 1
fi

cd /home/$SUDO_USER/.dotfiles

# Get the best mirror before installing packages
# EOS
eos-rankmirrors
# Arch
reflector --sort rate --protocol https --latest 5 --save /etc/pacman.d/mirrorlist

# Install packages
asUser yay -Syu --needed --noconfirm --sudoloop $(cat packages.lst | grep -o '^[^#]*') # yay cannot be run as root

# to copy dolphin layout files
asUser mkdir /home/$SUDO_USER/.local/share/kxmlgui5 2>/dev/null

# remove useless dirs
rm -r /home/$SUDO_USER/Templates 2>/dev/null
rm -r /home/$SUDO_USER/Public 2>/dev/null

# Copy config files (add links)
cd home
for file in .*; do
	if [[ "$file" == "." ]] || [[ "$file" == ".." ]]; then
		continue
	fi
	asUser ln -sf /home/$SUDO_USER/.dotfiles/home/$file /home/$SUDO_USER/$file
done
cd ..

for dotDir in */; do
	if [[ $dotDir != dot* ]]; then
		continue
	fi
	for dir in $dotDir*; do
		unescapedDir=$(echo $dir | sed "s/dot/./g" | sed "s/_/\//g")
		rm -rf /home/$SUDO_USER/$unescapedDir 2>/dev/null
		asUser ln -sf /home/$SUDO_USER/.dotfiles/$dir /home/$SUDO_USER/$unescapedDir 2>/dev/null ||
			echo "$dir cannot be transfered" # message when error
	done
done

# Copy specifc settings


### Install Lightly
rm -rf /tmp/lightly 2> /dev/null
asUser mkdir /tmp/lightly
cd /tmp/lightly

# Download aur PKGBuild and Patch
asUser git clone https://aur.archlinux.org/lightly-git.git .

# Disable qt5
sed -i -E "/_build_kf5/s/true/false/" PKGBUILD

# Run makepkg
asUser makepkg -si




# Change defaults
#asUser cp /home/$SUDO_USER/.dotfiles/manual/mimeapps.list /home/$SUDO_USER/.config/mimeapps.list

# virtualbox
usermod -aG vboxusers $SUDO_USER

# vscode settings
asUser mkdir -p /home/$SUDO_USER/.config/Code/User 2>/dev/null
asUser ln -sf /home/$SUDO_USER/.dotfiles/vscode/settings.json /home/$SUDO_USER/.config/Code/User/settings.json


# install rust
asUser curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | asUser sh -s -- -y
asUser mkdir /home/$SUDO_USER/.cargo 2>/dev/null
asUser ln -sf /home/$SUDO_USER/.dotfiles/manual/cargo-config.toml /home/$SUDO_USER/.cargo/config.toml

# install ddcci-plasmoid (to set external display brightness)
cp /usr/share/ddcutil/data/*-ddcutil-i2c.rules /etc/udev/rules.d
#groupadd --system i2c
usermod -aG i2c $SUDO_USER
echo i2c_dev | tee /etc/modules-load.d/i2c_dev.conf
asUser pipx install ddcci-plasmoid-backend

# transfer wallpapers
asUser ln -sfT /home/$SUDO_USER/.dotfiles/wallpapers /home/$SUDO_USER/Pictures/wallpapers # -T because a directory
asUser ln -sf /home/$SUDO_USER/.dotfiles/media/abstergo-transparent-small.png /home/$SUDO_USER/Pictures/abstergo-transparent-small.png
# TODO
#asUser plasma-apply-wallpaperimage /home/$SUDO_USER/Pictures/wallpapers/wallhaven-136m9w.png

# transfer sddm background
# (doesn't work with ln)
#cp /home/$SUDO_USER/.dotfiles/sddm/theme.conf /usr/share/sddm/themes/breeze/
#cp /home/$SUDO_USER/.dotfiles/sddm/theme.conf.user /usr/share/sddm/themes/breeze/
#cp /home/$SUDO_USER/.dotfiles/wallpapers/sunset-in-the-mountains-illustration_3840x2160_xtrafondos.com.jpg /usr/share/sddm/themes/breeze/


# resolve XPS15 screen issues
#if [[ $(dmidecode | grep -A2 '^System Information' | xargs | cut -d " " --f 8,9,10) = "XPS 15 9570" ]]; then
#	echo "options i915 enable_fbc=1 disable_power_well=0 fastboot=1 enable_psr=0" >/etc/modprobe.d/i915.conf
#fi

# Fix Wezterm focus window bug
#sed -i -E "/^Exec=/s/--cwd ./--cwd . --always-new-process/" /usr/share/applications/org.wezfurlong.wezterm.desktop

# To define terminal used by EOS Welcome app
echo 'EOS_YAD_TERMINAL="wezterm"' >>/etc/eos-script-lib-yad.conf

# Apply icon theme
# asUser /usr/lib/plasma-changeicons /home/$SUDO_USER/.local/share/icons/kora
# (already applied)

# Make fonts available on system (p.ex filename in Dolphin)
ln -sf /home/$SUDO_USER/.dotfiles/manual/fonts-local.conf /etc/fonts/local.conf

# save firefox settings
saveFirefoxData() {
	# if too big, clear cache before
	oldPath=$(pwd)
	cd /home/$SUDO_USER/
	asUser tar -jcvf dotmozilla.tar.bz2 .mozilla
	asUser mv dotmozilla.tar.bz2 /home/$SUDO_USER/.dotfiles/
	cd /home/$SUDO_USER/.dotfiles
	read -sp "You will have to enter the key to encrypt Firefox profile [Enter]"
	echo
	asUser gpg -c dotmozilla.tar.bz2
	rm dotmozilla.tar.bz2
	cd $oldPath
}

# transfer firefox options
restoreFirefoxData() {
	oldPath=$(pwd)
	cd /home/$SUDO_USER
	rm -rf /home/$SUDO_USER/.mozilla 2>/dev/null
	read -sp "You will have to enter the key to decrypt Firefox profile [Enter]"
	echo
	asUser gpg /home/$SUDO_USER/.dotfiles/dotmozilla.tar.bz2.gpg
	asUser mv /home/$SUDO_USER/.dotfiles/dotmozilla.tar.bz2 ./
	asUser tar -xvf /home/$SUDO_USER/dotmozilla.tar.bz2
	rm /home/$SUDO_USER/dotmozilla.tar.bz2
	cd $oldPath
}

# Smooth scroll firefox
#echo export MOZ_USE_XINPUT2=1 | tee /etc/profile.d/use-xinput2.sh
# maybe not with wayland ?

# Set zsh config file path
echo export ZDOTDIR='$HOME/.config/zsh' >>/etc/zsh/zshenv

# Set too many errors (3) password time to 30s
#sed -i -E '/# unlock_time = /s/.+/unlock_time = 60/' /etc/security/faillock.conf

# set grub chose time to 0 seconds
#sed -i -E "/GRUB_TIMEOUT/s/[0-9]+/0/" /etc/default/grub
#grub-mkconfig -o /boot/grub/grub.cfg

# Configure wireshark
chmod +x /usr/bin/dumpcap


# docker
gpasswd -a $SUDO_USER docker
systemctl enable docker.service

# Enable bluetooth
systemctl enable --now bluetooth.service

# Generate and set locale
#cp /home/$SUDO_USER/.dotfiles/manual/locale.gen /etc/locale.gen
#locale-gen
#cp /home/$SUDO_USER/.dotfiles/manual/locale.conf /etc/locale.conf

# change shell for zsh
chsh -s /bin/zsh $SUDO_USER

# restoreFirefoxData

echo Everything is done !
read -p "Do you want to reboot to apply config ?[y/N]: " shouldRestart
if [[ "$shouldRestart" == "y" ]]; then
	shutdown -r now
fi
