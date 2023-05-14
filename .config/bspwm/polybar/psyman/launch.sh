
#!/usr/bin/env bash

###########################################################################################################
#																										 
#    Copyright © 2023 To R																	
#																										 
#	 ██╗ ██╗      ██████╗  ██████╗ ██╗  ██╗██╗  ██╗██████╗ 
#	████████╗    ██╔═████╗██╔═████╗╚██╗██╔╝╚██╗██╔╝██╔══██╗
#	╚██╔═██╔╝    ██║██╔██║██║██╔██║ ╚███╔╝  ╚███╔╝ ██████╔╝
#	████████╗    ████╔╝██║████╔╝██║ ██╔██╗  ██╔██╗ ██╔══██╗
#	╚██╔═██╔╝    ╚██████╔╝╚██████╔╝██╔╝ ██╗██╔╝ ██╗██║  ██║
#	 ╚═╝ ╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
#																										 																									 
#    Copyright (C) Reza (CyD_Project)  <https://github.com/------>							 
#    LICENSE © exception_out_handled, line 11: $LIC not found in stack => No_LICENSE_FOUND (debug_method) !
#						
########################################################################################################################

#1 Files and Directories #
#1.1 added directory to inside of my bspwm theme then you can remove mine and have urs as backup ;)
#1.2 you should read arch linux wiki fore more informations ...
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
POLYBAR_DIR="$HOME/.config/bspwm/polybar"
#1.3 read archlinux->wiki->polybar
SFILE="$POLYBAR_DIR/system"

#2 Get system variable values for various modules #
get_values() {

	CARD=$(light -L | grep 'backlight' | head -n1 | cut -d'/' -f3)
	BATTERY=$(upower -i `upower -e | grep 'BAT'` | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
	ADAPTER=$(upower -i `upower -e | grep 'AC'` | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
	INTERFACE=$(ip link | awk '/state UP/ {print $2}' | tr -d :)

}

#3 Write values to `system` file #
set_values() {

	if [[ "$ADAPTER" ]]; then
		sed -i -e "s/adapter = .*/adapter = $ADAPTER/g" 						${SFILE}
	fi
	if [[ "$BATTERY" ]]; then
		sed -i -e "s/battery = .*/battery = $BATTERY/g" 						${SFILE}
	fi
	if [[ "$CARD" ]]; then
		sed -i -e "s/graphics_card = .*/graphics_card = $CARD/g" 				${SFILE}
	fi
	if [[ "$INTERFACE" ]]; then
		sed -i -e "s/network_interface = .*/network_interface = $INTERFACE/g" 	${SFILE}
	fi

}

#4 Launch Polybar with selected style #
launch_bar() {
	
	CARD=$(light -L | grep 'backlight' | head -n1 | cut -d'/' -f3)
	INTERFACE=$(ip link | awk '/state UP/ {print $2}' | tr -d :)

	if [[ -z "$CARD" ]]; then
		sed -i -e 's/backlight/bna/g' "$DIR"/config
	elif [[ "$CARD" != *"intel_"* ]]; then
		sed -i -e 's/backlight/brightness/g' "$DIR"/config
	fi

	if [[ "$INTERFACE" == e* ]]; then
		sed -i -e 's/network/ethernet/g' "$DIR"/config
	fi
	
    #4.1 close polybar #
	killall -q polybar

    #4.2 Wait until closing polybar # 
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

    #4.3 launch polybar #
    polybar -q main -c "$DIR"/config &
	polybar -q sec -c "$DIR"/config &
	polybar -q third -c "$DIR"/config &
	polybar -q fourth -c "$DIR"/config &
	polybar -q fifth -c "$DIR"/config &
	
}

#5 Execute functions #
get_values
set_values

#6 launch polybar #
launch_bar

#Done!
# Your changes below: #
