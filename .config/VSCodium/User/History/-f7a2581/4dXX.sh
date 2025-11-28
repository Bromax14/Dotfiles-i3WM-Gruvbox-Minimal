#!/bin/bash

# Script de Menú Interactivo de Información del Sistema para Rofi
# Autor: Amiga de Broki 😊

# Definir las opciones del menú
option=$(printf "Ver Info Completa\nVer Solo CPU\nVer Solo RAM\nVer Solo Disco\nVer Solo Kernel" | rofi \
    -dmenu \
    -p "Info Sistema" \
    -theme-str 'window {width: 250px; height: 320px; location: center; anchor: center; border: 0px; border-radius: 0px; background-color: #FFFFFF; border-color: #FFFFFF;}' \
    -theme-str 'mainbox {padding: 10px; spacing: 10px;}' \
    -theme-str 'listview {columns: 1; rows: 6; spacing: 5px;}' \
    -theme-str 'element {padding: 0px; margin: 2px; border-radius: 0px; background-color: #000000;}' \
    -theme-str 'element-text {horizontal-align: 0.0; vertical-align: 1.0; font: "CaskaydiaCove Nerd Font 10"; text-color: #737373;}' \
    -mesg "uptime: $(uptime -p 2>/dev/null || echo 'info no disponible')")

# Acciones según la opción seleccionada
case $option in
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
        rofi -dmenu -p "Info Completa" -markup-rows -theme-str 'window {width: 450px; height: 300px; location: center; anchor: center; background-color: #FFFFFF;} mainbox {padding: 10px;} element-text {font: "CaskaydiaCove Nerd Font 10"; text-color: #737373;}'

        ;;
    "Ver Solo CPU")
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
        echo "CPU: $CPU_INFO" | rofi -dmenu -p "CPU" -markup-rows -theme-str 'window {width: 430px; height: 100px; location: center; anchor: center; background-color: #FFFFFF;} mainbox {padding: 10px;} element-text {font: "CaskaydiaCove Nerd Font 10"; text-color: #737373;}'

        ;;
    "Ver Solo RAM")
        RAM_TOTAL=$(free -h | awk 'NR==2{print $2}')
        RAM_USED=$(free -h | awk 'NR==2{print $3}')
        printf "RAM Total: %s\nRAM Usada: %s\n" "$RAM_TOTAL" "$RAM_USED" | rofi -dmenu -p "RAM" -markup-rows -theme-str 'window {width: 300px; height: 150px; location: center; anchor: center; background-color: #FFFFFF;} mainbox {padding: 10px;} element-text {font: "CaskaydiaCove Nerd Font 10"; text-color: #737373;}'

        ;;
    "Ver Solo Disco")
        DISK_TOTAL=$(df -h / | awk 'NR==2{print $2}')
        DISK_USED=$(df -h / | awk 'NR==2{print $3}')
        printf "Disco Raíz Total: %s\nDisco Raíz Usado: %s\n" "$DISK_TOTAL" "$DISK_USED" | rofi -dmenu -p "Disco" -markup-rows -theme-str 'window {width: 300px; height: 150px; location: center; anchor: center; background-color: #FFFFFF;} mainbox {padding: 10px;} element-text {font: "CaskaydiaCove Nerd Font 10"; text-color: #737373;}'

        ;;
    "Ver Solo Kernel")
        echo "Kernel: $(uname -r)" | rofi -dmenu -p "Kernel" -markup-rows -theme-str 'window {width: 300px; height: 100px; location: center; anchor: center; background-color: #FFFFFF;} mainbox {padding: 10px;} element-text {font: "CaskaydiaCove Nerd Font 10"; text-color: #737373;}'
        ;;
esac
