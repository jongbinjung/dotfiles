#!/bin/bash
BASE_DIR=`pwd`
COMMENT_MARKER="# Generated from jongbin dotfile"
HEADER="
source $HOME/.bash_paths $COMMENT_MARKER
source $HOME/.bash_aliases $COMMENT_MARKER
"
FOOTER="
source $HOME/.bash_git $COMMENT_MARKER
source $HOME/.bash_prompt $COMMENT_MARKER
source $HOME/.bash_helpers $COMMENT_MARKER"
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
      ln -sf $BASE_DIR/.taskrc $HOME/.taskrc
      ln -sf $BASE_DIR/.Xmodmap $HOME/.Xmodmap
      ln -sf $BASE_DIR/.Xresources $HOME/.Xresources
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
# cp $HOME/.bashrc.bak $HOME/.bashrc

# Remove would-be duplicate lines
cat $HOME/.bashrc | sed -e "/$COMMENT_MARKER/d" > $HOME/.bashrc.mod

# Prepend sourcing headers
echo -e "$HEADER" > "$BASE_DIR"/.tmpheader
echo -e "$FOOTER" > "$BASE_DIR"/.tmpfooter
cat "$BASE_DIR"/.tmpheader "$HOME"/.bashrc.mod "$BASE_DIR"/.tmpfooter > \
  $HOME/.bashrc
rm -vf "$BASE_DIR/.tmpheader" "$BASE_DIR/.tmpfooter" "$HOME/.bashrc.mod"

echo "Copy bash_completion.d to global /etc/bash_completion.d? (Requires root)"
select yn in "Yes" "No"
do
  case $yn in
    Yes )
      echo "Copying bash_completion.d to /etc/bash_completion.d"
      sudo cp $BASE_DIR/bash_completion.d/* /etc/bash_completion.d/
      break ;;
    No)
      echo "Creating local ~/.bash_completion"
      if [ ! -f $HOME/.bash_completion ];
      then
        cat $BASE_DIR/bash_completion.d/* > $HOME/.bash_completion
      else
        echo "Local ~/.bash_completion already exists. Please check contents."
      fi
      break ;;
  esac
done

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
  echo "Installed tmux plugin manager."
  echo "Do prefix + I in tmux to initialize tmux plugins."
fi

unset BASE_DIR
