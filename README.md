# dotfiles
My dotfiles

## Install packages
```
sudo pacman -Syu --noconfirm paru
paru 
```


## Commands to make it work

```bash
mkdir ~/.dotfiles
cd ~/.dotfiles
git clone git@github.com:Webblitchy/dotfiles.git .

# create links
for file in .*; do 
    ln -sf ~/.dotfiles/$file ~/$file
done

cd dotconfig
for file in .*; do
    ls -sf ~/.dotfiles/dotconfig/$file ~/.config/$file
done

```
