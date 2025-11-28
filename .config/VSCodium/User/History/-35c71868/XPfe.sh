####
# Selector Wallpaper
####

# Ruta a la carpeta donde tienes tus wallpapers
WALLPAPER_DIR="/home/admin/Imágenes/Wallpapers" # Cambia esta ruta si usas otra

# Verifica si la carpeta existe
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Error: La carpeta $WALLPAPER_DIR no existe."
  exit 1
fi

# Obtiene la lista de imágenes (extenciones comunes)
WALLPAPER_LIST=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) | sort)

# Verifica si hay imágenes
if [ -z "$WALLPAPER_LIST" ]; then
  echo "Error: No se encontraron imágenes en $WALLPAPER_DIR."
  exit 1
fi

# Guarda el wallpaper actual antes de cambiarlo
CURRENT_WALLPAPER=$(grep "feh --bg-scale" ~/.config/i3/Autostart | cut -d '"' -f2)

# Abre Rofi con la lista de wallpapers
SELECTED_WALLPAPER=$(echo "$WALLPAPER_LIST" | rofi -dmenu -i -p "Selecciona un Fondo:")

# Verifica si se seleccionó un wallpaper
if [ -n "$SELECTED_WALLPAPER" ] && [ -f "$SELECTED_WALLPAPER" ]; then
  # Cambia el wallpaper usando feh
  feh --bg-scale "$SELECTED_WALLPAPER"

  # Opcional: Actualiza la configuración de i3 para que se quede al reiniciar
  I3_CONFIG="/home/admin/.config/i3/Autostart"
  sed -i '/exec --no-startup-id feh --bg-scale/d' "$I3_CONFIG"
  echo "exec --no-startup-id feh --bg-scale \"$SELECTED_WALLPAPER\"" >> "$I3_CONFIG"

  # Muestra un mensaje de confirmación con rofi, usando tu estilo del PowerMenu
  CONFIRM=$(echo -e "Si\nNo" | rofi \
		-theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmar' \
		-mesg 'Te Gusta el Fondo?' \
    -timeout 5000)

  if [ "$CONFIRM" = "No" ] || [ -z "$CONFIRM" ]; then
    # Si no respondes o dices "No", vuelve al fondo anterior
    if [ -n "$CURRENT_WALLPAPER" ] && [ -f "$CURRENT_WALLPAPER" ]; then
      feh --bg-scale "$CURRENT_WALLPAPER"
      # Actualiza la configuración de i3 de nuevo con el fondo anterior
      sed -i '/exec --no-startup-id feh --bg-scale/d' "$I3_CONFIG"
      echo "exec --no-startup-id feh --bg-scale \"$CURRENT_WALLPAPER\"" >> "$I3_CONFIG"
      echo "Fondo revertido a: $CURRENT_WALLPAPER"
    else
      echo "No se pudo revertir, no se encontró el fondo anterior."
    fi
  else
    # Si dices "Confirmar" o esperas los 5 segundos, se queda el nuevo fondo
    echo "Wallpaper aplicado: $SELECTED_WALLPAPER"
  fi
else
  echo "No se seleccionó ningún wallpaper o el archivo no existe."
fi
