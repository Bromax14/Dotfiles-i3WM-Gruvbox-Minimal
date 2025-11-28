##########
# Polycava #
##########

cava -p ~/.config/cava/config_raw | while IFS=';' read -r -a values; do
    bars=""
    for num in "${values[@]}"; do
        if [[ "$num" =~ ^[0-9]+$ ]]; then
            if [ "$num" -ge 45 ]; then
                bars+="█"
            elif [ "$num" -ge 40 ]; then
                bars+="▇"
            elif [ "$num" -ge 35 ]; then
                bars+="▆"
            elif [ "$num" -ge 30 ]; then
                bars+="▅"
            elif [ "$num" -ge 25 ]; then
                bars+="▄"
            elif [ "$num" -ge 20 ]; then
                bars+="▃"
            elif [ "$num" -ge 15 ]; then
                bars+="▂"
            elif [ "$num" -ge 10 ]; then
                bars+="▁"
            else
                bars+="▁"
            fi
        else
            bars+=" "
        fi
    done
    echo "$bars"
done
