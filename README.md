# dotfiles
My dotfiles

## Commands to make it work

Generate git ssh key
```bash 
git config --global user.name Webblitchy
git config --global user.email 55515713+Webblitchy@users.noreply.github.com
ssh-keygen -o -t rsa -C "55515713+Webblitchy@users.noreply.github.com"
cat ~/.ssh/id_rsa.pub
echo "  ->  Add the key here : https://github.com/settings/keys"
```

Install the programms and configs
```bash
mkdir ~/.dotfiles
cd ~/.dotfiles
git clone git@github.com:Webblitchy/dotfiles.git . 2>/dev/null ||
  git clone https://github.com/Webblitchy/dotfiles.git .
chmod +x install.sh
./install.sh
```
