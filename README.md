# dotfiles

## install brew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## setup mac

```bash
# ensure we have a modern bash
brew install bash
# setup macos
./_setup/macos.sh
```

## install basic tools

```bash
brew bundle install --file=_setup/brewfile.init
```

## unlock bw vault

```bash
export BW_SESSION=$(bw unlock --raw) && bw unlock --check
```

## init

```bash
chezmoi init
chezmoi init git@github.com:xmarcos/dotfiles.git
```

## post-init tasks

```bash
# restore brew aliases
https://github.com/Homebrew/homebrew-aliases/issues/32
for f in ~/.brew-aliases/* ; do
  ln -s $f "$(brew --prefix)/bin/brew-$(basename $f)"
done

# install rest of the apps
brew bundle install --file=_setup/brewfile.plus
```

## TODO

- Use <https://github.com/kcrawford/dockutil> to ensure consisten dock icons on fresh start.
- Automate folder icons <https://github.com/krestaino/macos-folder-icons> (replacement for <https://img2icnsapp.com/>)
- <https://github.com/kevinSuttle/macOS-Defaults/blob/master/REFERENCE.md>
- Fix QL PLugins:
  - <https://github.com/anthonygelibert/QLColorCode/issues/51#issuecomment-572932925>
  - <https://hargitai.co.nz/quicklook-plugin-qlgenerator-cant-be-opened-because-apple-cannot-check-it-for-malicious-software-fix-locally/>
