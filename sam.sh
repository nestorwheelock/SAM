#!/usr/bin/env bash

samVersion="0.4b"
samUpdate="https://raw.githubusercontent.com/dmitriypavlov/SAM/master/sam.sh"

# functions

samPath="${0%/*}"
samFile="${0##*/}"
profile=~/.profile

bold=$(tput bold)
red=$(tput setaf 1)
invert=$(tput rev)
normal=$(tput sgr0)

newline() {
	printf "\n"
}

samTitle() {
	echo -n -e "\033k$1\033\\"
}

samPause() {
	newline
	read -p "${bold}Press Enter to continue...${normal}" fackEnterKey
}

samConfirm() {
	newline
	local confirm && read -p "${bold}Are you sure? [Y/n]:${normal} " confirm
	
	if [[ "$confirm" == "Y" || "$confirm" == "y" ]]; then
		clear
		return 0
	else
		echo "${bold}${red}Task aborted${normal}"
		samPause
		return 1
	fi
}

samHelp() {
	clear
	echo "${bold}${invert} SAM Help ${normal}
	
	exit		Exit SAM
	install		Install to $profile
	uninstall	Uninstall from $profile
	update		Perform online update
	about		About SAM"
}

isMac() {
	if [[ $(uname -s) == "Darwin" ]]; then
		return 0
	else
		return 1
	fi
}

samInstall() {
	sudo chmod +x "$samPath/$samFile"
	if ! grep -q "#autosam" "$profile"; then
		echo -e "alias sam='$samPath/$samFile' #autosam\nsam #autosam" >> "$profile"
	fi
}

samUninstall() {
	isMac && sed -i "" "/#autosam/d" $profile || sed -i "/#autosam/d" $profile
}

samUpdate() {
	isMac && curl -s -o "$samPath/$samFile" "$samUpdate" || wget -q -O "$samPath/$samFile" "$samUpdate"
	samPause && exec "$samPath/$samFile"
}

samAbout() {
	clear
	echo "${bold}${invert} About SAM ${normal}"
	newline
	echo "version $samVersion ($samPath/$samFile)"
}

samBanner() {
	clear
	echo "${bold}${invert} Server Administration Menu @ $(hostname) ${normal}"
}

samTask() { 
	
	sam_?() { sam_help; }
	sam_exit() { samConfirm && exit 0; }
	sam_help() { samHelp && samPause; }
	sam_install() { samConfirm && samInstall; }
	sam_uninstall() { samConfirm && samUninstall; }
	sam_update() { samConfirm && samUpdate; }
	sam_about() { samAbout && samPause; }
	
	source "$samPath/$samFile.inc"
	
	read -p "${bold}Enter task:${normal} " task
	
	if type "sam_$task" &> /dev/null; then
		"sam_$task"
	else
		echo "${bold}${red}Task error${normal}"
		sleep 1
	fi
}
 
# init 

samTitle "SAM @ $(hostname -s)"
trap '' SIGINT SIGQUIT SIGTSTP

while true
do
 	samBanner
 	samTask
done