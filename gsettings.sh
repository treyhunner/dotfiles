
# Mouse & Touchpad
# disable tap to click, slow down mouse speed, disable natural scroll
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click false
gsettings set org.gnome.desktop.peripherals.touchpad speed -0.25882352941176467
gsettings set org.gnome.desktop.peripherals.mouse speed -0.62941176470588234
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

# Appearance
# Radiance Theme, TCP118v1 background, show windows in menu bar, always display menus
gsettings set org.gnome.desktop.wm.preferences theme 'Radiance'
gsettings set org.gnome.desktop.interface gtk-theme 'Radiance'
gsettings set org.gnome.desktop.interface icon-theme 'ubuntu-mono-light'
gsettings set org.gnome.desktop.background secondary-color '#000000'
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/TCP118v1_by_Tiziano_Consonni.jpg'
gsettings set com.canonical.Unity integrated-menus false
gsettings set com.canonical.Unity always-show-menus true

# Brightness & Lock
gsettings set org.gnome.desktop.session idle-delay uint32 600

# Power
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
gsettings set com.canonical.indicator.power show-time true
gsettings set org.gnome.power-manager info-history-type 'charge'
gsettings set org.gnome.power-manager info-stats-type 'discharge-accuracy'

# Keybindings
gsettings set org.gnome.desktop.wm.keybindings minimize ['<Control><Alt>KP_0']
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 @as []
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 @as []
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 @as []
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 @as []
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 @as []
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 @as []
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-11 @as []
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-12 @as []
gsettings set org.gnome.desktop.wm.keybindings unmaximize ['<Control><Super>Down']
gsettings set org.gnome.desktop.wm.keybindings raise ['disabled']
gsettings set org.gnome.desktop.wm.keybindings maximize ['<Control><Super>Up']
gsettings set org.gnome.desktop.wm.keybindings maximize-horizontally ['disabled']
gsettings set org.gnome.desktop.wm.keybindings lower ['disabled']
gsettings set org.gnome.desktop.wm.keybindings toggle-shaded ['<Control><Alt>s']
gsettings set org.gnome.desktop.wm.keybindings maximize-vertically ['disabled']
gsettings set org.gnome.desktop.wm.keybindings show-desktop ['<Control><Super>d']
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized ['<Control><Alt>KP_5']
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 @as []
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 @as []
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 @as []
gsettings set org.gnome.settings-daemon.peripherals.keyboard numlock-state 'on'

# Time
# Show weekday, show date and month, 24 hour time, time in auto-detected location
gsettings set com.canonical.indicator.datetime show-day true
gsettings set com.canonical.indicator.datetime show-date true
gsettings set com.canonical.indicator.datetime time-format '24-hour'
gsettings set com.canonical.indicator.datetime show-auto-detected-location true

# Launcher
gsettings set com.canonical.Unity.Launcher favorites ['application://org.gnome.Nautilus.desktop', 'application://google-chrome.desktop', 'application://gnome-terminal.desktop', 'application://org.gnome.Software.desktop', 'application://nylas-mail.desktop', 'application://quasselclient.desktop', 'application://unity-sound-panel.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']
