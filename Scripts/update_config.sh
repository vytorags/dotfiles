#!/usr/bin/env bash

LIST_FILE="$HOME/dotfiles/Scripts/Lists/list_config.txt"
CONFIG_DIR="$HOME/.config"
DOTS_DIR="$HOME/dotfiles/Config"

main() {
	mkdir -p "$DOTS_DIR"
	cd "$CONFIG_DIR" || exit 1

	while read -r config; do
		if [ -d "$config" ]; then
			echo "Syncing $config..."
			rsync -a --exclude='*/.git' "$config/" "$DOTS_DIR/$config/"
		else
			echo "Skipping $config (not found)"
		fi
	done < "$LIST_FILE"
}

main
