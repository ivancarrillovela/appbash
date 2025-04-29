#!/bin/bash

# --- Cargar el archivo remoto ---
source ./minimos.sh
source ./usuarios.sh
source ./copias_seguridad.sh
source ./remoto.sh
source ./minijuegos.sh
source ./enviar_correo.sh

# --- Variables Globales ---
TEMP_FILE=$(mktemp) # Archivo temporal para guardar la selección del menú

# --- Menú Principal ---
function mostrar_menu_principal {
    dialog --colors --clear --backtitle "\Zb\Z1📂 Aplicación para el Administrador del Sistema\Zn" \
           --title "\Zb\Z4 Menú Principal\Zn" \
           --cancel-label "Salir" \
           --menu "\Zb\Z2Seleccione una opción:\Zn" 17 65 8 \
           1 "\Zb\Z8📦 Instalación de Mínimos\Zn" \
           2 "\Zb\Z8👥 Administrar Usuarios\Zn" \
           3 "\Zb\Z8🔄 Copias de Seguridad\Zn" \
           4 "\Zb\Z8🛡️  Sistema y procesos\Zn" \
           5 "\Zb\Z8💻 Conexión Remota\Zn" \
           6 "\Zb\Z8✉️  Enviar un correo\Zn" \
           7 "\Zb\Z8🎮 Minijuegos\Zn" 2>"$TEMP_FILE"
           

    # Verificar el código de retorno
    local exit_status=$?

    if [ $exit_status -ne 0 ]; then
        salir
    fi

    opcion=$(<"$TEMP_FILE")
    ejecutar_opcion $opcion
}

function salir {
    dialog --colors --msgbox "\Zb\Z1 Saliendo de la aplicación... ¡Hasta luego!\Zn" 10 40
    clear
    exit 0
}

# --- Control de Ejecución ---
function ejecutar_opcion {
    case $1 in
        1) minimos ;;
        2) usuarios ;;
        3) copias_seguridad ;;
        4) ./seguridad_sistema.sh ;;
        5) remoto ;;
        6) correo ;;
        7) juegos ;;
        *) dialog --colors --msgbox "\Zb\Z1❌ Opción no válida. Intente de nuevo.\Zn" 10 40 ;;
    esac
}

# --- Inicio del Programa ---
while true; do
    mostrar_menu_principal
done
