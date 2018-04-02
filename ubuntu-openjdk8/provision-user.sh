#!/usr/bin/env bash

DESKTOP_FILES_DIR="/usr/share/applications"
LOCAL_DESKTOP_FILES_DIR="/home/vagrant/.local/share/applications"

# umake applications
UMAKE_APP_DIR="/opt/umake"
IDEA_DIR="$UMAKE_APP_DIR/ide/idea"
NETBEANS_DIR="$UMAKE_APP_DIR/ide/netbeans"

mkdir -p "$IDEA_DIR"
umake ide idea "$IDEA_DIR"
mkdir -p "$NETBEANS_DIR"
umake ide netbeans "$NETBEANS_DIR"

# Templates
touch "/home/vagrant/Templates/Text File.txt"

# Startup applications
AUTOSTART_DIR="/home/vagrant/.config/autostart"
mkdir -p "$AUTOSTART_DIR"
cp "$DESKTOP_FILES_DIR/plank.desktop" "$AUTOSTART_DIR"

# Gnome Shell Extensions
SHELL_EXT_DIR="/home/vagrant/.local/share/gnome-shell/extensions"
SHELL_EXT_DOWNLOAD_DIR="/home/vagrant/Downloads/gnome-shell-extensions"

mkdir -p "$SHELL_EXT_DIR"
mkdir -p "$SHELL_EXT_DOWNLOAD_DIR"
cd "$SHELL_EXT_DOWNLOAD_DIR"

wget https://extensions.gnome.org/extension-data/ShellTile@emasab.it.v50.shell-extension.zip
wget https://extensions.gnome.org/extension-data/CoverflowAltTab@palatis.blogspot.com.v32.shell-extension.zip

SHELL_EXT_REGEX="(.+)\.v[0-9]+\.shell-extension\.zip"

for SHELL_EXT_ZIP in $(ls); do
	if [[ $SHELL_EXT_ZIP =~ $SHELL_EXT_REGEX ]]; then
		SHELL_EXT="${BASH_REMATCH[1]}"
		unzip "$SHELL_EXT_ZIP" -d "$SHELL_EXT"
		cp -r "$SHELL_EXT" "$SHELL_EXT_DIR"
	fi
done

cd /home/vagrant
rm -rf "$SHELL_EXT_DOWNLOAD_DIR"

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
PLANK_APPS=("nautilus" "firefox" "thunderbird" "gnome-system-monitor" "gnome-terminal" "sublime_text" "meld")
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

cat /vagrant/resources/plank/plank.dconf | dconf load /net/launchpad/plank/docks/
