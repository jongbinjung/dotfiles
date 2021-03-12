#!/usr/bin/env zsh
BASE_DIR=$PWD

# Create symlink for necessary dotfiles
echo "Setup all aliases?"
select yn in "Yes" "No"
do
  case $yn in
    Yes )
      ln -sf "$BASE_DIR/zsh/alias.zsh" "$ZSH_CUSTOM/alias.zsh"
      ln -sf "$BASE_DIR/zsh/path.zsh" "$ZSH_CUSTOM/path.zsh"
      ln -sf "$BASE_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
      ln -sf "$BASE_DIR/.taskrc" "$HOME/.taskrc"
      ln -sf "$BASE_DIR/.Xmodmap" "$HOME/.Xmodmap"
      ln -sf "$BASE_DIR/.tmux.conf" "$HOME/.tmux.conf"
      ln -sf "$BASE_DIR/.Xresources" "$HOME/.Xresources"
      ln -sf "$BASE_DIR/.flake8" "$HOME/.flake8"
      ln -sf "$BASE_DIR/.pylintrc" "$HOME/.pylintrc"
      break ;;
    No)
      exit ;;
  esac
done

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  echo "Installed tmux plugin manager."
  echo "Do prefix + I in tmux to initialize tmux plugins."
fi

unset BASE_DIR
