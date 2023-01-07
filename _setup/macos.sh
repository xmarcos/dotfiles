#!/usr/bin/env bash

# close System Preferences to prevent it from overriding settings we're about to change
osascript -e 'tell application "System Preferences" to quit'

printf "Configuring macOS\n"
printf "=================\n"

read -erp "Username: " -i "$USER" USERNAME
read -erp "Computer Name: " -i "$(sysctl hw.model | awk '{print $2}')" COMPUTER

printf "Making zsh the default shell\n"
chsh -s /bin/zsh

printf "Changing the computer name to [%s]\n" "${COMPUTER}"
sudo scutil --set ComputerName "${COMPUTER}"
sudo scutil --set LocalHostName "${COMPUTER}"
sudo scutil --set HostName "${COMPUTER}"
dscacheutil -flushcache

# create some common directories
mkdir -p /Users/"${USERNAME}"/{Code,Cloud/{Notes,Screenshots}}

printf "Tweaking the system...\n"

# only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# prepare iterm
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "/Users/${USERNAME}/.config/iterm2"

# save screenshot to cloud-syncd folder using computer-name prefix
defaults write com.apple.screencapture location -string "/Users/${USERNAME}/Cloud/Screenshots"
defaults write com.apple.screencapture name "screenshot-${COMPUTER}"

# use keyboard navigation to move focus between controls.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# move dock to the left, change icon size and autohide
defaults write com.apple.dock "orientation" -string "left"
defaults write com.apple.dock "tilesize" -int "36"
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "show-recents" -bool "false"
defaults write com.apple.dock "mineffect" -string "suck"

# remove all the garbage from the dock
defaults write com.apple.dock persistent-apps -array

# apply changes to dock
killall Dock

# finder tweaks
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"
defaults write NSGlobalDomain "AppleShowScrollBars" -string "Always"
defaults write NSGlobalDomain "NSNavPanelExpandedStateForSaveMode" -bool true
defaults write NSGlobalDomain "NSNavPanelExpandedStateForSaveMode2" -bool true
defaults write com.apple.finder "ShowStatusBar" -bool true
# when performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# enable spring loading for directories with no delay
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0
# show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool true
defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool true
defaults write com.apple.finder "ShowMountedServersOnDesktop" -bool true
defaults write com.apple.finder "ShowRemovableMediaOnDesktop" -bool true
defaults write com.apple.finder "ShowPathbar" -bool true
# avoid creating .DS_Store files on network/USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
# use column view in all Finder windows by default, other view modes: `icnv`, `Nlsv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# enable AirDrop over ethernet and on older macs
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
# expand the following File Info pane: General and "Open with"
defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true

# finder sidebar
defaults write com.apple.finder ShowRecentTags -bool False

# finder favorites (NOT WORKING SINCE Catalina)
# sfltool add-item com.apple.LSSharedFileList.FavoriteItems file:///Users/"${USERNAME}"/Cloud
# sfltool add-item com.apple.LSSharedFileList.FavoriteItems file:///Users/"${USERNAME}"/Code

# apply changes to Finder
killall Finder

# disable resume system-wide
defaults write com.apple.systempreferences "NSQuitAlwaysKeepsWindows" -bool false

# disable time maching prompt
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool true

# disable iTunes ability to listen to media keys
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# restore sanity
defaults write NSGlobalDomain "AppleMeasurementUnits" -string "Centimeters"
defaults write NSGlobalDomain "AppleMetricUnits" -bool true
defaults write NSGlobalDomain "NSAutomaticCapitalizationEnabled" -bool false

# three finger drag (built-in trackpad)
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
# three finger drag (bt trackpad)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0

# turn off universal clipboard
defaults delete ~/Library/Preferences/com.apple.coreservices.useractivityd.plist
defaults write ~/Library/Preferences/com.apple.coreservices.useractivityd.plist ClipboardSharingEnabled -bool false

# CHROME, disable the backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

killall SystemUIServer

printf "Done ✅\n"

exit 0
