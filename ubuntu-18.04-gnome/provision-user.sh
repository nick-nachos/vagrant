# Templates
touch "/home/vagrant/Templates/Text File.txt"

# Gnome Shell Extensions
SHELL_EXT_DIR="/home/vagrant/.local/share/gnome-shell/extensions"
SHELL_EXT_DOWNLOAD_DIR="/home/vagrant/Downloads/gnome-shell-extensions"

mkdir -p "$SHELL_EXT_DIR"
mkdir -p "$SHELL_EXT_DOWNLOAD_DIR"
cd "$SHELL_EXT_DOWNLOAD_DIR"

wget https://extensions.gnome.org/extension-data/ShellTile@emasab.it.v55.shell-extension.zip

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

# Favorites
gsettings set org.gnome.shell favorite-apps "[
'org.gnome.Nautilus.desktop',
'firefox.desktop',
'org.gnome.Epiphany.desktop',
'gnome-system-monitor.desktop', 
'org.gnome.Terminal.desktop',
'meld.desktop',
'sublime_text.desktop',
'intellij-idea-community_intellij-idea-community.desktop'
]"
