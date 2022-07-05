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
sudo ln -sf ~/.dotfiles/logid.cfg /etc/logid.cfg # to make MXMaster3 works

# libinput gestures
sudo gpasswd -a $USER input
libinput-gestures-setup autostart
echo test 1
# vim commands
mkdir -p ~/.vim/undodir 2>/dev/null
echo test 2
# vim add ~/.vim/coc-settings.json and fzf-theme
vim +PlugInstall +PlugClean! +qa! 1>/dev/null 2>/dev/null
echo test 3

# add zsh plugins 
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/zsh/plugins/zsh-syntax-highlighting/
sudo git clone https://github.com/zsh-users/zsh-history-substring-search.git /usr/share/zsh/plugins/zsh-history-substring-search/
sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh/plugins/zsh-autosuggestions/

# save firefox settings with
saveFirefoxData () {
    # if too big, clear cache before
    oldPath=$(pwd)
    cd ~/
    tar -jcvf firefox-browser-profile.tar.bz2 .mozilla
    mv firefox-browser-profile.tar.bz2 ~/.dotfiles/
    cd ~/.dotfiles
    gpg -c firefox-browser-profile.tar.bz2
    rm firefox-browser-profile.tar.bz2
    cd $oldPath
}

# transfer firefox options
restoreFirefoxData () {
    oldPath=$(pwd)
    cd ~
    rm -rf ~/.mozilla 2>/dev/null
    gpg ~/.dotfiles/firefox-browser-profile.tar.bz2.gpg
    mv ~/.dotfiles/firefox-browser-profile.tar.bz2.gpg ./
    tar -xvf ~/firefox-browser-profile.tar.bz2
    rm ~/firefox-browser-profile.tar.bz2
    cd $oldPath
}
restoreFirefoxData

# cd home/firefox
# profileFolder=$(ls ~/.mozilla/firefox | grep .default-release)
# for file in *; do
#     rm -rf ~/.mozilla/firefox/$profileFolder/$file
#     ln -sf ~/.dotfiles/home/firefox/$file ~/.mozilla/firefox/$profileFolder/$file
# done
# cd ../..

# transfer wallpapers
ln -sf ~/.dotfiles/wallpapers ~/Pictures/wallpapers
ln -sf ~/.dotfiles/media/abstergo-transparent-small.png ~/Pictures/abstergo-transparent-small.png

# change shell for zsh
chsh -s /bin/zsh

echo Everything is done !
read -p "Do you want to reboot to apply config ?[y/n]:" userEntry
if [[ "$userEntry" == "y" ]]; then
    sudo shutdown -r now
fi

