###########
# i3-Floating #
###########

# Guardamos el ID de la ventana enfocada antes de hacer toggle
WINDOW_ID=$(i3-msg -t get_tree | jq -r '..|select(.focused?)| .id')

# Alternamos el modo flotante de la ventana enfocada
i3-msg floating toggle

# Esperamos un momento brevemente para que el cambio se aplique
sleep 0

# Si la ventana ahora es flotante, la redimensionamos y centramos
# Usamos el ID específico de la ventana que estaba enfocada para evitar afectar otras
i3-msg "[con_id=$WINDOW_ID] resize set 856 486"
i3-msg "[con_id=$WINDOW_ID] move position center"
