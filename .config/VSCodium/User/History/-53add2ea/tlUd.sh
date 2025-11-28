#!/bin/bash

if pgrep -f "yad.*Calendario" > /dev/null; then
    pkill -f "yad.*Calendario"
else
    yad --calendar --title="Calendario" --width=300 --height=200 --ontop --no-buttons &
fi
