# dotfiles
My dotfiles

## Commands to make it work

Generate git ssh key
```bash
git config --global user.name Webblitchy
git config --global user.email 55515713+Webblitchy@users.noreply.github.com
ssh-keygen -o -t ed25519 -C "55515713+Webblitchy@users.noreply.github.com" -q
echo "---------------------------------"
cat ~/.ssh/id_ed25519.pub
echo "---------------------------------"
echo "  ->  Add the key here : https://github.com/settings/keys"
```

Or transfer old key (~/.ssh and ~/.gnupg)
and give the right permissions
```
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
```

Install the programs and configs
```bash
mkdir ~/.dotfiles
cd ~/.dotfiles
git clone git@github.com:Webblitchy/dotfiles.git .
# git clone https://github.com/Webblitchy/dotfiles.git .
chmod +x install.sh
sudo -E ./install.sh
```

## Shortcuts
[Neovim config](/dotconfig/nvim)


