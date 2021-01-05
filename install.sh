#!/bin/bash
# Start Setup my ArcoLinux

##################################################################################################################
# # Aurthor     :VictoryLinux 
# 
# 
# 
##################################################################################################################

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
	echo "DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK."
	echo
	echo
	echo
	echo
	echo "This is NOT a silent install" 
	echo
	echo "you will be asked several questions as it progresses"
	echo
	echo
	echo
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "++++++++  Things you need to know before you start  ++++++++"
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "++                                                        ++"
	echo "++ 1.) This first script will install the Gnome DE + GDM  ++"
	echo "++                                                        ++"
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

# searching for the fastest mirrors
function fusion() {

	echo "Adding RPM Fusion."
	echo
	sleep 3s
	sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm ;
	check_exit_status
}

# Downloading and installing all Arch Linux and ArcoLinux packages
function update() {

	echo "Updating Fedora."
	echo
	sleep 3s
	sudo dnf update -y;
	check_exit_status
}

# Downloading and installing all Arch Linux and ArcoLinux packages
function debloat() {

	echo "Debloating Fedora."
	echo
	sleep 3s
	sudo dnf remove gnome-clocks gnome-maps simple-scan gnome-weather gnome-boxes totem rhythmbox;
	check_exit_status
}

# Setting up GDM login screen
function install() {

	echo "Installing Packages."
	echo
	sleep 3s
	sudo dnf install -y gnome-tweak-tool kmail terminator dconf-editor vlc htop terminator curl git meson chrome-gnome-shell onboard neofetch flatpak variety unrar appimagelauncher fish	util-linux-user stacer brave-browser binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms qt5-qtx11extras libxkbcommon VirtualBox;
	check_exit_status
	sleep 3s
	echo
	systemctl restart vboxdrv
	echo
	sleep 3s
	flatpak install flathub org.glimpse_editor.Glimpse
	flatpak install flathub com.discordapp.Discord
	flatpak install flathub org.onlyoffice.desktopeditors
#	flatpak install flathub com.spotify.Client
	flatpak install flathub com.sublimetext.three
	flatpak install flathub com.moonlight_stream.Moonlight
	echo
}

# Installing my Icon Themes
function icons() {

	echo "Giving Gnome a facelift."
	echo
	sleep 3s
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
	check_exit_status
}

# Setting up Favorite Dock icons
function dock() {

	echo "Setting up the Dock."
	echo
	sleep 3s
#	cp /usr/share/applications/plank.desktop ~/.config/autostart/
#	sudo chmod +x ~/.config/autostart/plank.desktop
	echo
	gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'chromium.desktop', 'org.gnome.Nautilus.desktop', 'simplenote.desktop', 'terminator.desktop', 'realvnc-vncviewer.desktop', 'com.teamviewer.TeamViewer.desktop', 'virtualbox.desktop', 'onboard.desktop']"
	
	check_exit_status
}

# Put the wallpaper
function backgrounds() {

	echo "Setting up Favorite Wallpaper."
	echo
	sleep 3s
#	sudo mv ~/victory-edition/victory/backgrounds/my_arcolinux /usr/share/backgrounds/
#	sudo mv ~/victory-edition/victory/backgrounds/my_gnome /usr/share/backgrounds/
#	sudo mv ~/victory-edition/victory/backgrounds/my_wall /usr/share/backgrounds/
	sudo cp -r ~/victory-edition/victory/backgrounds/victory /usr/share/backgrounds/
	echo
	sudo rm -rf /usr/share/backgrounds/gnome
	sudo rm -rf /usr/share/backgrounds/fedora-workstation
	check_exit_status
}

# finish
function finish() {
	read -p "Do you want to stay here and finish now? (y/n) " answer 

            if [ "$answer" == "y" ]
            then
            	cd arco-gnome
		echo
		sh arcosetup-victory.sh

            if [ "$answer" == "n" ]
            then
		echo
		echo "----------------------------------------------"
		echo "---- ArcoLinux part 1 has been installed! ----"
		echo "----------------------------------------------"
		echo
		check_exit_status
		echo
            	echo "After restarting, open terminal and run arcosetup-2.sh from the arco-gnome folder to finish this setup"
            	echo
		echo "Restarting in 20s"
		sleep 15s
                reboot
            fi
        fi

}

greeting
fusion
update
debloat
install

finish
