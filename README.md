# dotfiles
My dotfiles

## Commands to make it work

```bash
setopt interactivecomments

mkdir ~/.dotfiles
cd ~/.dotfiles
git clone git@github.com:Webblitchy/dotfiles.git .

# Install packages
sudo pacman -Syu --noconfirm paru
cat packages.lst | xargs paru --needed --noconfirm

# Copy config files (add links)
for file in .*; do 
    ln -sf ~/.dotfiles/$file ~/$file
done

cd dotconfig
for file in *; do 
    # move directories
    ln -sf ~/.dotfiles/dotconfig/$file/ ~/.config/$file
done

```
