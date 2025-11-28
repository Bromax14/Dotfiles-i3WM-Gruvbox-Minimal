####
# Limitar Sonido
####

LIMIT=100
SINK="@DEFAULT_SINK@"

# Obtener volumen actual
VOLUME=$(pactl get-sink-volume $SINK | awk '{print $5}' | sed 's/%//' | head -n1)

if [ $VOLUME -gt $LIMIT ]; then
    pactl set-sink-volume $SINK $LIMIT%
fi
