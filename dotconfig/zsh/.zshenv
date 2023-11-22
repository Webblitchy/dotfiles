# For Rust
. "$HOME/.cargo/env"

# Define fzf catpuccin theme
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"


ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

export EDITOR="nvim"


# To use docker constant like on mac or windows
export DOCKER_GATEWAY_HOST=172.17.0.1


# To use local bin programs as in bin
export PATH="$PATH:$HOME/.local/bin"

