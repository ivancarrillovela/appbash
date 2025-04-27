#!/bin/bash


    # Ruta base (el directorio donde está este script)
    BASE_DIR="$(dirname "$0")"

    while true; do
        opcion=$(dialog --clear --stdout \
            --title "Menú de Scripts de Seguridad" \
            --nocancel --menu "Selecciona una opción:" 15 50 6 \
            1 "Detección de Virus" \
            2 "Firewall" \
            3 "IPS Bloqueo (Solo maquina virtual)" \
            4 "Monitor Usuario" \
            5 "Mostrar Procesos" \
            6 "Volver")

        case $opcion in
            1) bash "./DeteccionVirus/1" ;;
            2) bash "./Firewall/script" ;;
            3) bash "./IpsBloqueo/1" ;;
            4) bash "./MonitorUsuario/1" ;;
            5) bash "./Procesos/1" ;;
            6) clear; break ;;
            *) clear; exit ;;
        esac
    done
