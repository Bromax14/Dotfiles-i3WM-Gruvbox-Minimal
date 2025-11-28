#!/bin/bash

# Intenta detectar el entorno gráfico y abrir nmtui
if [ -n "$DISPLAY" ]; then
    # Estamos en entorno gráfico
    if command -v alacritty &> /dev/null; then
        alacritty -t "WiFi Manager" -e nmtui &
    elif command -v gnome-terminal &> /dev/null; then
        gnome-terminal --title="WiFi Manager" -- nmtui &
    elif command -v xfce4-terminal &> /dev/null; then
        xfce4-terminal -T "WiFi Manager" -e "nmtui" &
    elif command -v konsole &> /dev/null; then
        konsole -e nmtui --title "WiFi Manager" &
    elif command -v xterm &> /dev/null; then
        xterm -title "WiFi Manager" -e nmtui &
    else
        # Último recurso: intentar directamente
        xterm -e nmtui &
    fi
else
    # Sin entorno gráfico, intentar directamente
    nmtui
fi