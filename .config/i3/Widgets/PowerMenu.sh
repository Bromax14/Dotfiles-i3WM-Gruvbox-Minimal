#################
# Menu de Apagado #
#################

# Options
shutdown=' Apagar'
reboot=' Reiniciar'
suspend=' Suspender'
logout=' cerrar sesión'
yes=' Si'
no=' No'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-theme-str 'window {width: 250px; height: 230px; location: southeast; anchor: southeast; y-offset: -510; x-offset: -10; border: 0px; border-radius: 0px; background-color: #FFFFFF; border-color: #FFFFFF;}' \
		-theme-str 'mainbox {padding: 10px; spacing: 10px;}' \
		-theme-str 'listview {columns: 1; rows: 5; spacing: 5px;}' \
		-theme-str 'element {padding: 0px; margin: 2px; border-radius: 0px; background-color: #000000;}' \
		-theme-str 'element-text {horizontal-align: 0.0; vertical-align: 1.0; font: "Adwaita Sans 10"; text-color: #737373;}' \
		-p "PowerMenu" \

}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: southeast; anchor: southeast; y-offset: -680; x-offset: -10; fullscreen: false; width: 250px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Seguro?' \

}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$shutdown\n$reboot\n$suspend" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $1 == '--logout' ]]; then
			if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
				i3-msg exit
			elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
				qdbus org.kde.ksmserver /KSMServer logout 0 0 0
			fi
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $suspend)
		run_cmd --suspend
        ;;
    $logout)
		run_cmd --logout
        ;;
esac
