#####################
# Launcher De la Polybar #
#####################

# Add this script to your wm startup file.

DIR="~/.config/polybar/Mi-Config"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0; done

# Launch the bar
polybar -q main -c "$DIR"/config.ini &
