#!/bin/bash

if (($EUID != 0)); then
	echo "Please run as root"
	exit 1
fi

cd ~/.dotfiles

# Get the best mirror before installing packages
# EOS
eos-rankmirrors
# Arch
reflector --country Switzerland --sort rate --protocol https --latest 5 --save /etc/pacman.d/mirrorlist

# Install packages
cat packages.lst |
	grep -o '^[^#]*' |                                                # select only non-comments
	xargs sudo -u $SUDO_USER yay -Syu --needed --noconfirm --sudoloop # yay cannot be run as root

# to copy dolphin layout files
sudo -u $SUDO_USER mkdir ~/.local/share/kxmlgui5 2>/dev/null

# remove useless dirs
rm -r ~/Templates 2>/dev/null
rm -r ~/Public 2>/dev/null

# Copy config files (add links)
cd home
for file in .*; do
	if [[ "$file" == "." ]] || [[ "$file" == ".." ]]; then
		continue
	fi
	sudo -u $SUDO_USER ln -sf ~/.dotfiles/home/$file ~/$file
done
cd ..

for dotDir in */; do
	if [[ $dotDir != dot* ]]; then
		continue
	fi
	for dir in $dotDir*; do
		unescapedDir=$(echo $dir | sed "s/dot/./g" | sed "s/_/\//g")
		rm -rf ~/$unescapedDir 2>/dev/null
		sudo -u $SUDO_USER ln -sf ~/.dotfiles/$dir ~/$unescapedDir 2>/dev/null ||
			echo "$dir cannot be transfered" # message when error
	done
done

for file in $(ls myscripts); do
	ln -sf ~/.dotfiles/myscripts/$file /usr/local/bin/$file
done

# Copy specifc settings

# libinput gestures
gpasswd -a $SUDO_USER input
sudo -u $SUDO_USER libinput-gestures-setup autostart

# virtualbox
usermod -aG vboxusers $SUDO_USER

# vscode settings
sudo -u $SUDO_USER mkdir -p ~/.config/Code/User 2>/dev/null
sudo -u $SUDO_USER ln -sf ~/.dotfiles/vscode/settings.json ~/.config/Code/User/settings.json

# jetbrains settings
programs=("clion" "intellij" "pycharm")
for nickname in ${programs[@]}; do
	timeout 1s /bin/$nickname* # open the app to create the config folder
	program=$(ls ~/.config/JetBrains | grep -i $nickname)
	sudo -u $SUDO_USER mkdir -p ~/.config/JetBrains/$program/options 2>/dev/null
	for file in $(ls ~/.dotfiles/jetbrains/); do
		sudo -u $SUDO_USER ln -sf ~/.dotfiles/jetbrains/$file ~/.config/JetBrains/$program/options/$file
	done
done

# install rust
sudo -u $SUDO_USER curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sudo -u $SUDO_USER sh -s -- -y

# add zsh plugins
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/zsh/plugins/zsh-syntax-highlighting/
# git clone https://github.com/zsh-users/zsh-history-substring-search.git /usr/share/zsh/plugins/zsh-history-substring-search/
# git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh/plugins/zsh-autosuggestions/

# transfer wallpapers
sudo -u $SUDO_USER ln -sf ~/.dotfiles/wallpapers ~/Pictures/wallpapers
sudo -u $SUDO_USER ln -sf ~/.dotfiles/media/abstergo-transparent-small.png ~/Pictures/abstergo-transparent-small.png
sudo -u $SUDO_USER plasma-apply-wallpaperimage ~/Pictures/wallpapers/wallhaven-136m9w.png

# transfer sddm background
# (doesn't work with ln)
cp ~/.dotfiles/sddm/theme.conf /usr/share/sddm/themes/breeze/
cp ~/.dotfiles/sddm/theme.conf.user /usr/share/sddm/themes/breeze/
cp ~/.dotfiles/wallpapers/sunset-in-the-mountains-illustration_3840x2160_xtrafondos.com.jpg /usr/share/sddm/themes/breeze/

# transfer optimus-manager settings
mkdir /etc/optimus-manager
cp ~/.dotfiles/optimus-manager.conf /etc/optimus-manager/

# resolve XPS15 screen issues
if [[ $(sudo -u $SUDO_USER dmidecode | grep -A2 '^System Information' | xargs | cut -d " " --f 8,9,10) = "XPS 15 9570" ]]; then
	sudo -u $SUDO_USER echo "options i915 enable_fbc=1 disable_power_well=0 fastboot=1 enable_psr=0" >/etc/modprobe.d/i915.conf
fi

# Fix Wezterm focus window bug
echo "StartupNotify=true" >>/usr/share/applications/org.wezfurlong.wezterm.desktop

# To define terminal used by EOS Welcome app
echo 'EOS_YAD_TERMINAL="wezterm"' >>/etc/eos-script-lib-yad.conf

# Apply icon theme
sudo -u $SUDO_USER /usr/lib/plasma-changeicons ~/.local/share/icons/kora

# Make fonts available on system (p.ex filename in Dolphin)
ln -sf ~/.dotfiles/local.conf /etc/fonts/local.conf

# save firefox settings
saveFirefoxData() {
	# if too big, clear cache before
	oldPath=$(pwd)
	cd ~/
	sudo -u $SUDO_USER tar -jcvf dotmozilla.tar.bz2 .mozilla
	sudo -u $SUDO_USER mv dotmozilla.tar.bz2 ~/.dotfiles/
	cd ~/.dotfiles
	read -sp "You will have to enter the key to encrypt Firefox profile [Enter]"
	echo
	sudo -u $SUDO_USER gpg -c dotmozilla.tar.bz2
	rm dotmozilla.tar.bz2
	cd $oldPath
}

# transfer firefox options
restoreFirefoxData() {
	oldPath=$(pwd)
	cd ~
	rm -rf ~/.mozilla 2>/dev/null
	read -sp "You will have to enter the key to decrypt Firefox profile [Enter]"
	echo
	sudo -u $SUDO_USER gpg ~/.dotfiles/dotmozilla.tar.bz2.gpg
	sudo -u $SUDO_USER mv ~/.dotfiles/dotmozilla.tar.bz2 ./
	sudo -u $SUDO_USER tar -xvf ~/dotmozilla.tar.bz2
	rm ~/dotmozilla.tar.bz2
	cd $oldPath
}

# Smooth scroll firefox
sudo -u $SUDO_USER echo export MOZ_USE_XINPUT2=1 | sudo tee /etc/profile.d/use-xinput2.sh

# Set too many errors password time to 10s
sed -i '45 a\unlock_time = 10' /etc/security/faillock.conf

# set grub chose time to 0 seconds
vim /etc/default/grub -u NONE -c "/GRUB_TIMEOUT" -c "s/[0-9]\+/0" -c "wq"
grub-mkconfig -o /boot/grub/grub.cfg

# Configure wireshark
chmod +x /usr/bin/dumpcap

# optimus manager settings
systemctl enable optimus-manager.service

# docker
gpasswd -a $user docker
systemctl enable docker.service

# Enable bluetooth
systemctl enable bluetooth.service

# Set locale
cp ~/.dotfiles/locale.conf /etc/locale.conf
# localectl set-locale LANG=en_US.UTF-8 # if error with locale defaults

# change shell for zsh
chsh -s /bin/zsh $SUDO_USER

# restoreFirefoxData

echo Everything is done !
read -p "Do you want to reboot to apply config ?[y/n]: " userEntry
if [[ "$userEntry" == "y" ]]; then
	shutdown -r now
fi
