##################
# Selector de Fondos #
##################

# Selector Wallpaper
WALLPAPER_DIR="/home/admin/Imágenes/Wallpapers"

# Verifica si la carpeta existe
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Error: La carpeta $WALLPAPER_DIR no existe."
  exit 1
fi

# Obtiene la lista de imágenes
WALLPAPER_LIST=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) | sort)

if [ -z "$WALLPAPER_LIST" ]; then
  echo "Error: No se encontraron imágenes en $WALLPAPER_DIR."
  exit 1
fi

# Guarda el wallpaper actual ANTES de cambiarlo
CURRENT_WALLPAPER=$(grep "feh --bg-scale" ~/.config/i3/Autostart | cut -d '"' -f2 2>/dev/null)

# Bucle para poder volver a seleccionar si no te gusta
while true; do
  # Abre Rofi con la lista de wallpapers
  SELECTED_WALLPAPER=$(echo "$WALLPAPER_LIST" | rofi -dmenu -i -p "Wallpapers" -esc 1 -theme-str 'window {location: southeast; anchor: southeast; y-offset: -385; x-offset: -19; fullscreen: false; width: 350px;
height: 340px;}' -theme-str 'mainbox {padding: 10px; spacing: 10px;}' -theme-str 'listview {columns: 1; lines: 10;}' -theme-str 'element-text {font: "Adwaita Sans 10";}')
  ROFI_EXIT_CODE=$?

  # Verifica si se presionó ESC (salida 1) o si no se seleccionó nada
  if [ $ROFI_EXIT_CODE -eq 1 ] || [ -z "$SELECTED_WALLPAPER" ]; then
    echo "Selección cancelada"
    exit 0
  fi

  # Verifica si el archivo seleccionado existe
  if [ -f "$SELECTED_WALLPAPER" ]; then
    # Cambia el wallpaper
    feh --bg-scale "$SELECTED_WALLPAPER"

    # Pregunta si te gusta el fondo
    CONFIRM=$(echo -e "Si\nNo" | rofi \
      -theme-str 'window {location: southeast; anchor: southeast; y-offset: -666; x-offset: -19; fullscreen: false; width: 250px;}' \
      -theme-str 'mainbox {children: [ "message", "listview" ];}' \
      -theme-str 'listview {columns: 2; lines: 1;}' \
      -theme-str 'element-text {horizontal-align: 0.5;}' \
      -theme-str 'textbox {horizontal-align: 0.5;}' \
      -dmenu \
      -p 'Confirmar' \
      -mesg 'Seguro?' \
      -timeout 5000 \
      -esc 1)
    CONFIRM_EXIT_CODE=$?

    # Solo se sale del bucle si:
    # 1. La respuesta es "Si" (y no es vacía ni ESC)
    # 2. O si se presionó ESC en la confirmación (código 1)
    if [ "$CONFIRM" = "Si" ] && [ $CONFIRM_EXIT_CODE -eq 0 ]; then
      # Si confirmas, actualiza la configuración con el nuevo fondo y sale
      I3_CONFIG="/home/admin/.config/i3/Autostart"
      sed -i '/exec --no-startup-id feh --bg-scale/d' "$I3_CONFIG"
      echo "exec --no-startup-id feh --bg-scale \"$SELECTED_WALLPAPER\"" >> "$I3_CONFIG"
      echo "Wallpaper aplicado: $SELECTED_WALLPAPER"
      exit 0  # Sale del script completamente
    elif [ $CONFIRM_EXIT_CODE -eq 1 ] || [ -z "$CONFIRM" ]; then
      # Si presionas ESC o no seleccionas nada, vuelve al fondo anterior
      if [ -n "$CURRENT_WALLPAPER" ] && [ -f "$CURRENT_WALLPAPER" ]; then
        feh --bg-scale "$CURRENT_WALLPAPER"
      fi
    else
      # Si dices "No", vuelve al fondo anterior
      if [ -n "$CURRENT_WALLPAPER" ] && [ -f "$CURRENT_WALLPAPER" ]; then
        feh --bg-scale "$CURRENT_WALLPAPER"
      fi
    fi
  else
    echo "El archivo seleccionado no existe."
  fi
done
