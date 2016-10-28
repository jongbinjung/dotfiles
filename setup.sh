#!/bin/bash
BASE_DIR=`pwd`

# Create symlink for necessary dotfiles
echo "Setup all aliases?"
select yn in "Yes" "No"
do
  case $yn in
    Yes )
      ln -sf $BASE_DIR/.bash_aliases $HOME/.bash_aliases
      ln -sf $BASE_DIR/.bash_git $HOME/.bash_git
      ln -sf $BASE_DIR/.bash_helpers $HOME/.bash_helpers
      ln -sf $BASE_DIR/.bash_paths $HOME/.bash_paths
      break ;;
    No)
      exit ;;
  esac
done

echo "Do you want to setup a remote or local prompt?"
select rl in "Remote" "Local"
do
  case $rl in
    Remote)
      ln -sf $BASE_DIR/.bash_prompt_remote $HOME/.bash_prompt
      break ;;
    Local)
      ln -sf $BASE_DIR/.bash_prompt $HOME/.bash_prompt
      break ;;
  esac
done

# Update .bashrc to source necessary files
# Backup original .bashrc
cp $HOME/.bashrc $HOME/.bashrc.bak
cp $HOME/.bashrc.bak $HOME/.bashrc

# Remove would-be duplicate lines
cat $HOME/.bashrc | sed -e '/# Generated from jongbin dotfile/d' > $HOME/.bashrc.mod

# Prepend sourcing headers
cat $BASE_DIR/.header_bashrc $HOME/.bashrc.mod > $HOME/.bashrc
rm -f $HOME/.bashrc.mod

echo "Copy bash_completion.d? (Requires root)"
select yn in "Yes" "No"
do
  case $yn in
    Yes )
      sudo cp $BASE_DIR/bash_completion.d/* /etc/bash_completion.d/
      break ;;
    No)
      exit ;;
  esac
done

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
  echo "Installed tmux plugin manager."
  echo "Do prefix + I in tmux to initialize tmux plugins."
fi

unset BASE_DIR
