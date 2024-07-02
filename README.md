# dotfiles
My dotfiles

## Commands to make it work

Generate git ssh key
```bash
git config --global user.name Webblitchy
git config --global user.email 55515713+Webblitchy@users.noreply.github.com
ssh-keygen -o -t rsa -C "55515713+Webblitchy@users.noreply.github.com" -q
echo "---------------------------------"
cat ~/.ssh/id_rsa.pub
echo "---------------------------------"
echo "  ->  Add the key here : https://github.com/settings/keys"
```

Install the programs and configs
```bash
mkdir ~/.dotfiles
cd ~/.dotfiles
git clone git@github.com:Webblitchy/dotfiles.git
# git clone https://github.com/Webblitchy/dotfiles.git .
chmod +x install.sh
sudo -E ./install.sh
```

## Shortcuts
[Neovim config](/dotconfig/nvim)


