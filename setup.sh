#!/bin/bash
set -e

if [ "$(grep -e '^ID=' /etc/os-release | cut -d '=' -f 2)" != "arch" ] ; then
	echo "This setup script is only for Arch Linux!"
	exit 1
fi

# Install chaotic-aur
if [ ! -e /etc/pacman.d/chaotic-mirrorlist ] ; then
	echo "Installing chaotic-aur..."
	pkexec pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
	pkexec pacman-key --lsign-key 3056513887B78AEB
	pkexec pacman -U \
		'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
		'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
fi

# Install paru
if ! which paru &> /dev/null ; then
	echo "Installing paru..."
	pkexec pacman -S --needed git base-devel
	tmp="$(mktemp -d)"
	git clone https://aur.archlinux.org/paru.git "$tmp"
	pushd "$tmp"
	makepkg -si
	popd
	rm -rf "$tmp"
fi

# Install packages
echo "Installing packages..."
paru -Syu \
	btop \
	curl \
	e2fsprogs \
	eza \
	expac \
	fd \
	ffmpeg \
	fzf \
	github-cli \
	hwinfo \
	lazygit \
	micro \
	mpv \
	pkgfile \
	python-virtualenv \
	reflector \
	ripgrep \
	starship \
	wget \
	zsh \
	zsh-autosuggestions \
	zsh-syntax-highlighting \
	--needed

echo "Done!"
