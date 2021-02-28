# Templates
TEMPLATES_DIR="$HOME/Templates"
mkdir -p "$TEMPLATES_DIR"
touch "$TEMPLATES_DIR/Text File.txt"

# Favorites
gsettings set org.gnome.shell favorite-apps "[
	'org.gnome.Nautilus.desktop', 
	'firefox.desktop', 
	'brave_brave.desktop', 
	'gnome-system-monitor.desktop', 
	'org.gnome.Terminal.desktop', 
	'org.gnome.meld.desktop', 
	'sublime-text_subl.desktop', 
	'sublime-merge_sublime-merge.desktop', 
	'intellij-idea-community_intellij-idea-community.desktop'
]"

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

ssh-keygen -t ed25519 -C "$GIT_USER_EMAIL" -f "$HOME/.ssh/id_ed25519" -q -N "$GIT_USER_PASS"
eval "$(ssh-agent -s)"
ssh-add "$HOME/.ssh/id_ed25519"
