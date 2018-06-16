#!/usr/bin/env bash

# Plank
function plank_docklet_def {
	echo -e "[PlankDockItemPreferences]\nLauncher=docklet://$1"
}

function plank_app_def {
	echo -e "[PlankDockItemPreferences]\nLauncher=file://$DESKTOP_FILES_DIR/$1.desktop"
}

function plank_local_app_def {
	echo -e "[PlankDockItemPreferences]\nLauncher=file://$LOCAL_DESKTOP_FILES_DIR/$1.desktop"
}

PLANK_THEMES_DIR="/home/vagrant/.local/share/plank/themes"
PLANK_LAUNCHERS_DIR="/home/vagrant/.config/plank/dock1/launchers"
rm -rf "$PLANK_THEMES_DIR"
rm -rf "$PLANK_LAUNCHERS_DIR"
mkdir -p "$PLANK_THEMES_DIR"
mkdir -p "$PLANK_LAUNCHERS_DIR"
cp -r "/vagrant/resources/plank/themes/Arc-Dark" "$PLANK_THEMES_DIR"
PLANK_DOCKLETS=("desktop" "trash")
PLANK_APPS=("Thunar" "firefox" "thunderbird" "xfce4-taskmanager" "xfce4-terminal" "sublime_text" "meld")
PLANK_LOCAL_APPS=("jetbrains-idea-ce")

for PLANK_DOCKLET in "${PLANK_DOCKLETS[@]}"; do
	plank_docklet_def $PLANK_DOCKLET > "$PLANK_LAUNCHERS_DIR/$PLANK_DOCKLET.dockitem"
done

for PLANK_APP in "${PLANK_APPS[@]}"; do
	plank_app_def $PLANK_APP > "$PLANK_LAUNCHERS_DIR/$PLANK_APP.dockitem"
done

for PLANK_LOCAL_APP in "${PLANK_LOCAL_APPS[@]}"; do
	plank_local_app_def $PLANK_LOCAL_APP > "$PLANK_LAUNCHERS_DIR/$PLANK_LOCAL_APP.dockitem"
done

cat /vagrant/resources/plank/plank.conf | dconf load /net/launchpad/plank/docks/
