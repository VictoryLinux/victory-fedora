#!/bin/bash

#####################################################################
#  ____    ____  __                                                 #
#  \   \  /   / |__| ____ ________    ____    _______ ___  ___      #
#   \   \/   /  ___ |   _|\__   __\ /   _  \ |  __   |\  \/  /      #
#    \      /  |   ||  |_   |  |   |   |_|  ||  | |__| \   /        #
#     \____/   |___||____|  |__|    \_____ / |__|       |_|         #
#                                                                   #
# Victory Linux Fedora Install script                               #
# https://github.com/VictoryLinux                                   #
#####################################################################

# Make sure each command executes properly
check_exit_status() {

	if [ $? -eq 0 ]
	then
		echo
		echo "Success"
		echo
	else
		echo
		echo "[ERROR] Update Failed! Check the errors and try again"
		echo
		
		read -p "The last command exited with an error. Exit script? (y/n) " answer

            if [ "$answer" == "y" ]
            then
                exit 1
            fi
	fi
}

function greeting() {

	clear

	echo
	echo "+-------------------------------------------------------------------------+"
	echo "|-------   Hello, $USER. Let's setup your Fedora Victory-Edition.  -------|"
	echo "+-------------------------------------------------------------------------+"
	echo
	echo
	echo    "#####################################################################"
	echo    "#  ____    ____  __                                                 #"
	echo    "#  \   \  /   / |__| ____ ________    ____    _______ ___  ___      #"
	echo    "#   \   \/   /  ___ |   _|\__   __\ /   _  \ |  __   |\  \/  /      #"
	echo    "#    \      /  |   ||  |_   |  |   |   |_|  ||  | |__| \   /        #"
	echo    "#     \____/   |___||____|  |__|    \_____ / |__|       |_|         #"
	echo    "#                                                                   #"
	echo    "# Victory Linux Fedora Install script                               #"
	echo    "# https://github.com/VictoryLinux                                   #"
	echo    "#####################################################################"
	echo
	echo "DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK."  
	echo
	echo 
	echo
	echo
	echo
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "++++++++  Things you need to know before you start  ++++++++"
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "++                                                        ++"
	echo "++ 1.) "This is NOT a silent install"                      ++"
	echo "++                                                        ++"
	echo "++ "you will be asked several questions as it progresses"  ++"
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo
	echo
#	sleep 5s
	echo "ARE YOU READY TO START? [y,n]"
	read input

	# did we get an input value?
	if [ "$input" == "" ]; then

	   echo "Nothing was entered by the user"

	# was it a y or a yes?
	elif [[ "$input" == "y" ]] || [[ "$input" == "yes" ]]; then

	   echo "You replied $input, you are ready to start"
	   echo
	   echo "Starting Fedora Victory-Edition install script."
	   echo
	   sleep 3s

	# treat anything else as a negative response
	else

	   echo "You replied $input, you are not ready"
	   echo
	   exit 1

fi

	echo
	
	check_exit_status
}

# Enable root user
function root() {

	echo "############################"
	echo "|    Enabling Root user.   |"
	echo "############################"
	echo
	sleep 6s
	sudo passwd root
	echo
	check_exit_status
}

# Set the Hostname
function hostname() {
	
	echo "############################"
	echo "|     Set the Hostname.    |"
	echo "############################"
	echo
	sleep 6s
	sudo nano /etc/hostname;
	echo
	check_exit_status
}

# Adding RPM Fusion as a repository
function fusion() {

	echo "#########################################"
	echo "|     Adding RPM Fusion and Flathub.    |"
	echo "#########################################"
	echo
	sleep 6s
	sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm;
	echo
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	echo
	check_exit_status
}

# Updating Fedora
function update() {

	echo "###########################"
	echo "|     Updating Fedora.    |"
	echo "###########################"
	echo
	sleep 6s
	echo	
	sudo dnf update -y;
	echo
	check_exit_status
}

# Removing unwanted pre-installed packages
function debloat() {

	echo "#############################"
	echo "|     Debloating Fedora.    |"
	echo "#############################"
	echo
	sleep 6s
	sudo dnf remove gnome-clocks gnome-maps simple-scan gnome-weather gnome-boxes totem rhythmbox;
	echo
	check_exit_status
}

# Installing Packages
function install() {

	echo "###############################"
	echo "|     Installing Packages.    |"
	echo "###############################"
	echo
	sleep 6s
	sudo dnf install -y gnome-tweak-tool nodejs npm make kmail terminator dconf-editor htop terminator meson onboard neofetch variety unrar fish util-linux-user stacer patch kernel-devel dkms VirtualBox;
	check_exit_status
	sleep 3s
	echo
	systemctl restart vboxdrv
	echo
	sleep 3s
	dnf module install nodejs:15
	echo
	git clone https://github.com/pop-os/shell
	cd shell
	make local-install
	sleep 3s
	sudo dnf install cargo rust gtk3-devel
	git clone https://github.com/pop-os/shell-shortcuts
	cd shell-shortcuts
	make
	sudo make install
	echo
	sudo dnf install dnf-plugins-core
	echo
	sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
	echo
	sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
	echo
	sudo dnf install brave-browser -y
	echo

	echo
	sleep 3s
	flatpak install flathub org.glimpse_editor.Glimpse -y
	flatpak install flathub com.discordapp.Discord -y
	flatpak install flathub org.onlyoffice.desktopeditors -y
#	flatpak install flathub com.spotify.Client -y
	flatpak install flathub com.sublimetext.three -y
	flatpak install flathub com.moonlight_stream.Moonlight -y
	flatpak install flathub com.simplenote.Simplenote -y
	flatpak install flathub com.system76.Popsicle -y
	flatpak install flathub org.videolan.VLC -y
	echo
	flatpak remote-add --if-not-exists plex-media-player https://flatpak.knapsu.eu/plex-media-player.flatpakrepo
	flatpak install plex-media-player tv.plex.PlexMediaPlayer -y
	echo
	echo /usr/local/bin/fish | sudo tee -a /etc/shells
	echo
	cd Downloads
	git clone https://github.com/ryanoasis/nerd-fonts
	cd nerd-fonts
	./install.sh
	echo
	cd ~
	curl -fsSL https://starship.rs/install.sh | bash
	echo
	chsh -s /usr/bin/fish
	echo
	git clone https://github.com/VictoryLinux/fish
	cd fish
	mkdir -p ~/.config/fish
	sudo cp -r ~/victory-fedora/fish/config.fish ~/.config/fish/
	echo
	check_exit_status
}

# Installing my Icon Themes
function icons() {

	echo "###################################"
	echo "|     Giving Gnome a facelift.    |"
	echo "###################################"
	echo
	sleep 6s
#	git clone https://github.com/pop-os/icon-theme pop-icon-theme
#	cd pop-icon-theme
#	meson build
#	sudo ninja -C "build" install
#	sudo mv pop-icon-theme/ ~/;
	#gsettings set org.gnome.desktop.interface icon-theme 'Pop'
	echo
	git clone https://github.com/daniruiz/flat-remix
	git clone https://github.com/daniruiz/flat-remix-gtk
	mkdir -p ~/.icons && mkdir -p ~/.themes
	cp -r flat-remix/Flat-Remix* ~/.icons/ && cp -r flat-remix-gtk/Flat-Remix-GTK* ~/.themes/
	rm -rf ~/flat-remix flat-remix-gtk
	gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Blue-Dark"
	gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark"
	echo
	check_exit_status
}

# Install gnome extensions
function extensions() {
	
	#Dash-to-Dock
	echo "###################################"
	echo "|     Installing Dash-to-Dock.    |"
	echo "###################################"
	echo
	sleep 6s
	cd Downloads
	git clone https://github.com/micheleg/dash-to-dock.git
	cd dash-to-dock
	make
	make install
	
	#Caffeine
	echo "###############################"
	echo "|     Installing Caffeine.    |"
	echo "###############################"
	echo
	sleep 6s
	git clone git://github.com/eonpatapon/gnome-shell-extension-caffeine.git
	cd gnome-shell-extension-caffeine
	./update-locale.sh
	glib-compile-schemas --strict --targetdir=caffeine@patapon.info/schemas/ caffeine@patapon.info/schemas
	cp -r caffeine@patapon.info ~/.local/share/gnome-shell/extensions
	
	echo "##################################"
	echo "|     Enableing Dash-to-Dock.    |"
	echo "##################################"
	echo
	sleep 6s
	gnome-shell-extension-tool -e dash-to-dock
	
	echo "##############################"
	echo "|     Enableing Caffeine.    |"
	echo "##############################"
	echo
	sleep 6s
	gnome-shell-extension-tool -e caffeine
	
	echo "#################################"
	echo "|     Enableing Window List.    |"
	echo "#################################"
	echo
	sleep 6s
	gnome-shell-extension-tool -e window-list
	echo
	check_exit_status
}

# Setting up Favorite Dock icons
function dock() {

	echo "###############################"
	echo "|     Setting up the Dock.    |"
	echo "###############################"
	echo
	sleep 6s
	echo
	gsettings set org.gnome.shell favorite-apps "['brave-browser.desktop', 'firefox.desktop', 'chromium.desktop', 'org.gnome.Nautilus.desktop', 'simplenote.desktop', 'terminator.desktop', 'realvnc-vncviewer.desktop', 'com.teamviewer.TeamViewer.desktop', 'virtualbox.desktop', 'net.lutris.Lutris.desktop', 'discord.desktop', 'onboard.desktop', 'tv.plex.PlexMediaPlayer.desktop']"
	echo
	check_exit_status
}

# Put the wallpaper
function backgrounds() {

	echo "#########################################"
	echo "|     Setting up Favorite Wallpaper.    |"
	echo "#########################################"
	echo
	sleep 6s
	git clone https://github.com/VictoryLinux/victory-wallpaper
	echo
	sudo cp -r ~/victory-fedora/victory-wallpaper /usr/share/backgrounds/
	echo
	sudo rm -rf /usr/share/backgrounds/gnome
	sudo rm -rf /usr/share/backgrounds/fedora-workstation
	echo
	check_exit_status
}

#
function structure() {
	
	echo "###############################"
	echo "|     Setting Time Format.    |"
	echo "###############################"
	echo
	sleep 6s
	gsettings set org.gnome.desktop.interface clock-format 12h
	echo
	check_exit_status
}

# finish
function finish() {
	read -p "Are You ready to restart now? (y/n) " answer 

            if [ "$answer" == "y" ]
            then
            	cecho
		echo "----------------------------------------------------"
		echo "---- Fedora Victory Edition has been installed! ----"
		echo "----------------------------------------------------"
		echo
		check_exit_status
		echo
		echo "Restarting in 20s"
		sleep 15s
                reboot

            if [ "$answer" == "n" ]
            then
		exit 1

            fi
        fi

}

greeting
root
hostname
fusion
update
debloat
install
icons
extensions
dock
backgrounds
structure
finish
