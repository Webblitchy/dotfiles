# dotfiles
My dotfiles

## Commands to make it work

```bash
mkdir ~/.dotfiles
cd ~/.dotfiles
git clone git@github.com:Webblitchy/dotfiles.git .

# create links
for file in *; do 
    if [[ "$file" == "README.md" ]]; then
        continue
    fi
    ln -s $file ~/$file
done
```
