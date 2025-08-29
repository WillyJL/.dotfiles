#!/bin/bash
set -e

# Copy dotfiles
echo "Copying dotfiles..."
cp -rT "$PWD/home/user" "$HOME"
sudo cp -rT "$PWD/usr/local" "/usr/local"
sudo fc-cache

# Check shell
shell="$(cat /proc/$PPID/cmdline | cut -d '' -f 1)"
if [[ ! "$shell" == *zsh ]] ; then
	echo "Remember to change shell to /usr/bin/zsh in your terminal!"
fi

echo "Done!"
