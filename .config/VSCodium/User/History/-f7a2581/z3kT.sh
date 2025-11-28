####
# InfoMenu
####

    "Ver Info Completa")
        # Mostrar toda la info como antes, en otro Rofi no interactivo
        USER_INFO=$(whoami)
        KERNEL=$(uname -r)
        UPTIME=$(uptime -p 2>/dev/null || echo "Uptime info not available")
        # Intentar obtener el nombre del CPU usando /proc/cpuinfo primero
        CPU_INFO=$(grep 'model name' /proc/cpuinfo | head -n 1 | cut -d':' -f2- | xargs 2>/dev/null)
        if [ -z "$CPU_INFO" ]; then
            # Fallback a lscpu si /proc/cpuinfo falla
            CPU_INFO=$(lscpu | grep -E "^(Model name|Nombre de modelo):" | head -n 1 | cut -d':' -f2- | xargs 2>/dev/null)
        fi
        if [ -z "$CPU_INFO" ]; then
            # Último recurso si todo falla
            CPU_INFO="Nombre de CPU no encontrado"
        fi
        RAM_TOTAL=$(free -h | awk 'NR==2{print $2}')
        RAM_USED=$(free -h | awk 'NR==2{print $3}')
        DISK_TOTAL=$(df -h / | awk 'NR==2{print $2}')
        DISK_USED=$(df -h / | awk 'NR==2{print $3}')

        printf "Usuario: %s\nKernel: %s\nTiempo encendido: %s\nCPU: %s\nRAM Total: %s | RAM Usada: %s\nDisco Raíz Total: %s | Disco Raíz Usado: %s\n" \
               "$USER_INFO" "$KERNEL" "$UPTIME" "$CPU_INFO" "$RAM_TOTAL" "$RAM_USED" "$DISK_TOTAL" "$DISK_USED" | \
        rofi -dmenu -p "Info Completa" -markup-rows -theme-str 'window {width: 450px; height: 320px; location: center; anchor: center; background-color: #FFFFFF;} mainbox {padding: 10px;} element-text {font: "Adwaita Sans 10"; text-color: #737373;}'

        ;;
esac
