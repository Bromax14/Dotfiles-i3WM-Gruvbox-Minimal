#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Interfaz WiFi
INTERFACE="wlp2s0b1"

# Función para mostrar el menú
mostrar_menu() {
    clear
    echo -e "${YELLOW}╔══════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║         Gestor WiFi con nmtui        ║${NC}"
    echo -e "${YELLOW}╠══════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║ 1. Conectar a una red                ║${NC}"
    echo -e "${GREEN}║ 2. Ver redes conectadas              ║${NC}"
    echo -e "${GREEN}║ 3. Activar/Desactivar WiFi          ║${NC}"
    echo -e "${GREEN}║ 4. Ver estado de la interfaz        ║${NC}"
    echo -e "${GREEN}║ 5. Salir                             ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════╝${NC}"
    echo -e -n "${YELLOW}Elige una opción (1-5): ${NC}"
}

# Bucle principal
while true; do
    mostrar_menu
    read -r opcion

    case $opcion in
        1)
            echo -e "${GREEN}Abriendo nmtui para conectar a una red...${NC}"
            nmtui connect
            read -p "Presiona Enter para continuar..."
            ;;
        2)
            echo -e "${GREEN}Verificando redes conectadas...${NC}"
            nmcli connection show --active
            read -p "Presiona Enter para continuar..."
            ;;
        3)
            echo -e "${YELLOW}¿Deseas activar (on) o desactivar (off) el WiFi? (on/off): ${NC}"
            read -r wifi_estado
            if [[ "$wifi_estado" == "on" ]]; then
                nmcli radio wifi on
                echo -e "${GREEN}WiFi activado.${NC}"
            elif [[ "$wifi_estado" == "off" ]]; then
                nmcli radio wifi off
                echo -e "${RED}WiFi desactivado.${NC}"
            else
                echo -e "${RED}Opción no válida.${NC}"
            fi
            read -p "Presiona Enter para continuar..."
            ;;
        4)
            echo -e "${GREEN}Estado actual de $INTERFACE:${NC}"
            ip link show "$INTERFACE"
            read -p "Presiona Enter para continuar..."
            ;;
        5)
            echo -e "${GREEN}¡Hasta la próxima, Broki!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opción inválida. Intenta de nuevo.${NC}"
            sleep 1
            ;;
    esac
done
