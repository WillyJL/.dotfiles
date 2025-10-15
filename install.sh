#!/bin/bash
set -e

# Copy dotfiles
echo "Copying dotfiles..."
cp -rT "$PWD/home/user" "$HOME"
if [ "$(grep -e '^ID=' /etc/os-release | cut -d '=' -f 2)" != "arch" ] ; then
    pkexec cp -rT "$PWD/etc" "/etc"
fi
pkexec cp -rT "$PWD/usr" "/usr"
pkexec fc-cache

# Check shell
shell="$(cat /proc/$PPID/cmdline | cut -d '' -f 1)"
if [[ ! "$shell" == *zsh ]] ; then
	echo "Remember to change shell to /usr/bin/zsh in your terminal!"
fi

echo "Done!"
