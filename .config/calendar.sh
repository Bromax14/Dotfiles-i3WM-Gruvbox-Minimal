#!/bin/bash
# ~/.config/i3/Widgets/calendar.sh

# Intenta cerrar primero
eww close calendar 2>/dev/null

# Si falló (código de salida distinto de 0), entonces abre
if [ $? -ne 0 ]; then
    eww open calendar
fi
