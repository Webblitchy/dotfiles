#!/bin/bash

cd ~/.dotfiles

# Install packages
sudo pacman -Syu --noconfirm paru
paru -Rns --noconfirm firefox
cat packages.lst | xargs paru -Syu --needed --noconfirm

# to copy dolphin layout files
mkdir ~/.local/share/kxmlgui5

# Copy config files (add links)
cd home
for file in .*; do 
    if [[ "$file" == "." ]] || [[ "$file" == ".." ]]; then
        continue
    fi
    ln -sf ~/.dotfiles/home/$file ~/$file
done
cd ..

for dotDir in */; do
    if [[ $dotDir != dot* ]]; then
        continue
    fi
    for dir in $dotDir*; do
        unescapedDir=$(echo $dir | sed "s/dot/./g" | sed "s/_/\//g")
        rm -rf ~/$unescapedDir 2>/dev/null
        ln -sf ~/.dotfiles/$dir ~/$unescapedDir 2>/dev/null \
          || echo "$dir cannot be transfered" # message when error
    done
done

# Configure wireshark
# TODO: sudo chmod +x /usr/bin/dumpcap

# Copy specifc settings

# libinput gestures
sudo gpasswd -a $USER input
libinput-gestures-setup autostart

# vim commands
mkdir -p ~/.vim/undodir 2>/dev/null
vim -c "PlugInstall" -c "PlugClean" -c "qa!"
ln -sf ~/.dotfiles/vim/coc-settings.json ~/.vim/coc-settings.json
ln -sf ~/.dotfiles/vim/fzf-gruvbox.config ~/.vim/fzf-gruvbox.config

# add zsh plugins 
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/zsh/plugins/zsh-syntax-highlighting/
sudo git clone https://github.com/zsh-users/zsh-history-substring-search.git /usr/share/zsh/plugins/zsh-history-substring-search/
sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh/plugins/zsh-autosuggestions/

# transfer wallpapers
ln -sf ~/.dotfiles/wallpapers ~/Pictures/wallpapers
ln -sf ~/.dotfiles/media/abstergo-transparent-small.png ~/Pictures/abstergo-transparent-small.png

# save firefox settings
saveFirefoxData () {
    # if too big, clear cache before
    oldPath=$(pwd)
    cd ~/
    tar -jcvf dotmozilla.tar.bz2 .mozilla
    mv dotmozilla.tar.bz2 ~/.dotfiles/
    cd ~/.dotfiles
    read -ps "You will have to enter the key to encrypt Firefox profile"
    echo
    gpg -c dotmozilla.tar.bz2
    rm dotmozilla.tar.bz2
    cd $oldPath
}

# transfer firefox options
restoreFirefoxData () {
    oldPath=$(pwd)
    cd ~
    rm -rf ~/.mozilla 2>/dev/null
    read -ps "You will have to enter the key to decrypt Firefox profile"
    echo
    gpg ~/.dotfiles/dotmozilla.tar.bz2.gpg
    mv ~/.dotfiles/dotmozilla.tar.bz2 ./
    tar -xvf ~/dotmozilla.tar.bz2
    rm ~/dotmozilla.tar.bz2
    cd $oldPath
}
restoreFirefoxData

# change shell for zsh
chsh -s /bin/zsh

# set grub chose time to 0 seconds
sudo vim /etc/default/grub -u NONE -c "/GRUB_TIMEOUT" -c "s/[0-9]\+/0" -c "wq"

echo Everything is done !
read -p "Do you want to reboot to apply config ?[y/n]: " userEntry
if [[ "$userEntry" == "y" ]]; then
    sudo shutdown -r now
fi

