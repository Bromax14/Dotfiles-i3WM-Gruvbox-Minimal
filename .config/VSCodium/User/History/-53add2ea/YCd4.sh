#!/bin/bash

# Guarda este archivo como ~/.config/polybar/scripts/calendar.sh
# Dale permisos de ejecución: chmod +x ~/.config/polybar/scripts/calendar.sh

# Muestra el calendario con un formato más limpio
cal -m | sed 's/^/  /' | rofi -dmenu -i -p "Calendario" -width 30 -lines 10 -font "monospace 12"