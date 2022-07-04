#!/bin/bash

cd ~/.dotfiles

# Install packages
sudo pacman -Syu --noconfirm paru
cat packages.lst | xargs paru -Syu --needed --noconfirm

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
    if [[ "$dotDir" == "home/" ]]; then
        continue
    fi
    for dir in $dotDir*; do
        unescapedDir=$(echo $dir | sed "s/dot/./g" | sed "s/_/\//g")
        rm -rf ~/$unescapedDir 2>/dev/null
        ln -sf ~/.dotfiles/$dir ~/$unescapedDir 2>/dev/null \
          || echo "Programm not installed : $dir cannot be transfered" # message when error
    done
done

# Configure wireshark
# TODO: sudo chmod +x /usr/bin/dumpcap

# Copy specifc settings
sudo ln -sf ~/.dotfiles/logid.cfg /etc/logid.cfg # to make MXMaster3 works

# libinput gestures
sudo gpasswd -a $USER input
libinput-gestures-setup autostart start

# vim commands
mkdir -p ~/.vim/undodir 2>/dev/null
# vim add ~/.vim/coc-settings.json and fzf-theme
vim +PlugInstall +PlugClean! +qa! 2>/dev/null

# add zsh plugins 
sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/zsh/plugins/zsh-syntax-highlighting/
sudo git clone https://github.com/zsh-users/zsh-history-substring-search.git /usr/share/zsh/plugins/zsh-history-substring-search/
sudo git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh/plugins/zsh-autosuggestions/


chsh -s /bin/zsh
