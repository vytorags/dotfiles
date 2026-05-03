#!/usr/bin/env bash

set -euo pipefail

dnfPkgs="$HOME/dotfiles/Scripts/Lists/list_pkgs_dnf.txt"
COPRs="$HOME/dotfiles/Scripts/Lists/list_copr.txt"
BUN_VERSION=$(curl -s https://api.github.com/repos/oven-sh/bun/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/bun-v//')
NEOVIM_VERSION="0.12.2"

function installNeovim() {
	echo -e "======================"
	echo -e "=== Install Neovim ==="
	echo -e "======================"
	mkdir -p ~/.local/share/opt
	curl -Lo /tmp/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux64.tar.gz
	tar -xzf /tmp/nvim-linux64.tar.gz -C ~/.local/share/opt/
	ln -sf ~/.local/share/opt/nvim-linux64/bin/nvim ~/.local/bin/nvim
	echo "Neovim installed and symlinked to ~/.local/bin/nvim"
}

function installPrismLauncher() {
	echo -e "============================="
	echo -e "=== Install PrismLauncher ==="
	echo -e "============================="
	sudo dnf copr enable g3tchoo/prismlauncher -y
	sudo dnf install prismlauncher -y
	echo "PrismLauncher installed."
}

function installVesktop() {
	echo -e "======================="
	echo -e "=== Install Vesktop ==="
	echo -e "======================="
	local VESKTOP_RPM_URL="https://vencord.dev/download/vesktop/amd64/rpm"
	local VESKTOP_RPM_PATH="/tmp/vesktop.rpm"

	curl -Lo "$VESKTOP_RPM_PATH" "$VESKTOP_RPM_URL"
	sudo dnf install -y "$VESKTOP_RPM_PATH"
	rm "$VESKTOP_RPM_PATH"
	echo "Vesktop installed."
}

function installBrave() {
	echo -e "====================="
	echo -e "=== Install Brave ==="
	echo -e "====================="
	sudo dnf install dnf-plugins-core -y
	sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
	sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
	sudo dnf install brave-browser -y
	echo "Brave Browser installed."
}

function installRustTools() {
	echo -e "============================="
	echo -e "=== Installing Rust Tools ==="
	echo -e "============================="

	if ! command -v cargo &>/dev/null; then
		echo "AVISO: Cargo não encontrado. Pulando a instalação das ferramentas Rust." >&2
		return 1
	fi

	cargo install ouch
	cargo install ripdrag
	echo "Rust tools (ouch, ripdrag) installed."
}

function installOhMyZsh() {
	echo -e "========================="
	echo -e "=== Install Oh-My-Zsh ==="
	echo -e "========================="
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

	echo -e "=============================="
	echo -e "=== Installing Zsh Plugins ==="
	echo -e "=============================="
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

	echo "Oh-My-Zsh and plugins installed."
}

function enableCOPRs() {
	echo -e "===================="
	echo -e "=== Enable COPRs ==="
	echo -e "===================="
	sudo dnf copr enable $COPRs -y
}


function installBun() {
	echo -e "==================="
	echo -e "=== Install Bun ==="
	echo -e "==================="
	curl -Lo /tmp/bun.zip https://github.com/oven-sh/bun/releases/download/bun-v${BUN_VERSION}/bun-linux-x64-baseline.zip
	unzip /tmp/bun.zip -d /tmp/
	mkdir -p ~/.local/bin
	mv /tmp/bun-linux-x64-baseline/bun ~/.local/bin/
	chmod +x ~/.local/bin/bun
}

function installPkgs() {
	echo -e "==========================="
	echo -e "=== Installing Packages ==="
	echo -e "==========================="
	sudo dnf install $dnfPkgs -y
	installBun
	bun install -g opencode-ai
	installNeovim
	installPrismLauncher
	installVesktop
	installBrave
	installRustTools
}

function flatpakCfg() {
	echo -e "==========================="
	echo -e "=== Configuring Flatpak ==="
	echo -e "==========================="
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

	flatpak install flathub org.localsend.localsend_app -y
	flatpak install flathub io.mrarm.mcpelauncher -y
	flatpak install flathub md.obsidian.Obsidian -y

	echo "Flatpak configured and applications installed."
}

function cfgBookmarks() {
	BOOKMARKS_FILE="$HOME/.config/gtk-3.0/bookmarks"
	mkdir -p "$(dirname "$BOOKMARKS_FILE")"

	echo "file://$HOME/Downloads Downloads" >"$BOOKMARKS_FILE"
	echo "file://$HOME/Documents Documents" >>"$BOOKMARKS_FILE"
	echo "file://$HOME/Workspace Workspace" >>"$BOOKMARKS_FILE"
	echo "file://$HOME/Workspace/Projects Projects" >>"$BOOKMARKS_FILE"
}

function cfgDots() {
	echo -e "============================"
	echo -e "=== Configuring Dotfiles ==="
	echo -e "============================"
	DOTS_DIR="$HOME/dotfiles"
	CONFIG_DIR="$HOME/.config"

	mkdir -p "$CONFIG_DIR"

	for dotfile in $(ls "$DOTS_DIR/Config"); do
		local SOURCE="$DOTS_DIR/Config/$dotfile"
		local DESTINATION="$CONFIG_DIR/$dotfile"

		if [ -L "$DESTINATION" ] && [ "$(readlink "$DESTINATION")" = "$SOURCE" ]; then
			echo "Link simbólico para $dotfile já existe e está correto. Pulando."
			elif [ -e "$DESTINATION" ]; then
			echo "AVISO: $DESTINATION existe e não é um link simbólico para o seu dotfile. Pulando para evitar sobrescrita." >&2
		else
			ln -sf "$SOURCE" "$DESTINATION"
			echo "Symlinked $dotfile to $CONFIG_DIR"
		fi
		done

	dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
	dconf write /org/gnome/desktop/interface/font-name "'Sarasa Mono TC Nerd Font 12'"
	cfgBookmarks
}

function postInstallConfigs() {
	echo -e "===================================="
	echo -e "=== Running Post-Install Configs ==="
	echo -e "===================================="

	sudo usermod -aG docker $USER
	echo "User added to docker group. Please log out and back in for changes to take effect."

	dms greeter enable
	dms greeter sync
	echo "DMS Greeter enabled and synced."
}

function Init() {
	echo -e "=========================="
	echo -e "=== Initializing Setup ==="
	echo -e "=========================="
	enableCOPRs
	installPkgs
	flatpakCfg
	installOhMyZsh
	cfgDots
	postInstallConfigs
}

Init
