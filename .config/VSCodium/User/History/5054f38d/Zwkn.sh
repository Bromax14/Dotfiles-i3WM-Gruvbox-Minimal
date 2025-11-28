#!/bin/bash

# Ruta a tus scripts (usando $HOME en lugar de ~)
script1="$HOME/.config/i3/Widgets/Selector-Wallpaper.sh"
script2="$HOME/.config/i3/Widgets/PowerMenu.sh"
script3="$HOME/.config/i3/Widgets/wifi_menu.sh"

# Bucle para mostrar el menú hasta que se elija una opción
while true; do
  # Menú principal con estilo personalizado
  opcion=$(echo -e "Selecciona un Wallpaper\nMenu De apagado\nMenu De Wifi" | rofi \
      -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 280px;}' \
      -theme-str 'mainbox {children: [ "message", "listview" ];}' \
      -theme-str 'listview {lines: 3;}' \
      -theme-str 'textbox {horizontal-align: 0.5;}' \
      -dmenu \
      -p 'Menú Principal' \
      -mesg 'Configuracion Basica' \
      -i \
      -no-show-match \
      -no-sort)

  # Ejecutar según la opción elegida
  case $opcion in
    "Selecciona un Wallpaper")
      "$script1"
      ;;
    "Menu De apagado")
      "$script2"
      ;;
      "Menu De Wifi"
      "$script3"
      ;;
    "")
      # Si se cancela con Esc, se sale del script
      exit 0
      ;;
    *)
      echo "Opción no válida"
      ;;
  esac
done
