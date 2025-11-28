#!/bin/bash

# Guarda este archivo como ~/.config/polybar/scripts/calendar.sh
# Dale permisos de ejecución: chmod +x ~/.config/polybar/scripts/calendar.sh

# Captura el calendario y lo centra
cal -m | while IFS= read -r line; do
    printf "%*s\n" $(( (${#line} + 60) / 2 )) "$line"
done | rofi -dmenu -i -p "Calendario" -width 15 -lines 10 -font "Adwaita sans 12"