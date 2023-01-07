# install brew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

# make zsh the default shell
```bash
chsh -s /bin/zsh
```

# install basic tools
```bash
brew bundle install --file=_setup/brewfile.init
```

# configure iTerm
```bash
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "/Users/xmarcos/.config/iterm2"
```

# unlock bw vault
```bash
export BW_SESSION=$(bw unlock --raw) && bw unlock --check
```

# init
```bash
chezmoi init
chezmoi init git@github.com:xmarcos/dotfiles.git
```

# post-init tasks

```bash
# restore brew aliases
https://github.com/Homebrew/homebrew-aliases/issues/32
for f in ~/.brew-aliases/* ; do
  ln -s $f "$(brew --prefix)/bin/brew-$(basename $f)"
done

# install rest of the apps
brew bundle install --file=_setup/brewfile.plus
```
