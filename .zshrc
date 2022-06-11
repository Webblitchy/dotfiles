# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

# Decommenter pour ajouter des themes
#source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Apply fzf-gruvbox theme
# https://github.com/base16-project/base16-fzf
source ~/.vim/fzf-gruvbox.config


# mes alias
alias ll="ls -Athor"
alias open="dolphin"
alias vrc="vim ~/.vimrc"
alias vimtutor="cp /usr/share/vim/vim82/tutor/tutor.fr.utf-8 /tmp/vimtutor; vim /tmp/vimtutor"
alias grep="grep --color=auto"
alias sshvm="ssh ubuntu@152.67.78.43"
alias cours="cd /home/eliott/cours"
alias hello="kdialog --passivepopup 'Hello'"

# demande confirmation avant overwrite:
alias cp="cp -i"
alias mv="mv -i"

