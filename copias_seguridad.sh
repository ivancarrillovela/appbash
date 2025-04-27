#!/bin/bash

# Ruta donde se almacenarán las copias de seguridad
COPIAS_DIR="/var/backups/mis_backups/"

# --- Función para verificar y crear el directorio de copias ---
function verificar_directorio {
    if [ ! -d "$COPIAS_DIR" ]; then
        mkdir -p "$COPIAS_DIR"
        if [ $? -ne 0 ]; then
            dialog --msgbox "Error al crear el directorio de copias de seguridad: $COPIAS_DIR. Verifique permisos." 8 50
            exit 1
        fi
    fi
}

# --- Función para crear una copia de seguridad ---
function crear_copia {
    verificar_directorio

    local fecha=$(date +"%Y-%m-%d_%H-%M-%S")
    local archivo_backup="$COPIAS_DIR/backup_$fecha.tar.gz"

    dialog --infobox "Creando copia de seguridad en: $archivo_backup" 6 50
    tar -czvf "$archivo_backup" --exclude="$COPIAS_DIR" /

    if [ $? -eq 0 ]; then
        dialog --msgbox "¡Copia de seguridad creada con éxito!\nArchivo: $archivo_backup" 8 50
    else
        dialog --msgbox "Error al crear la copia de seguridad. Debes ejecutar la aplicación como administrador." 8 50
    fi
}

# --- Función para restaurar una copia de seguridad ---
function restaurar_copia {
    verificar_directorio

    local archivos=$(ls "$COPIAS_DIR" 2>/dev/null)
    if [ -z "$archivos" ]; then
        dialog --msgbox "No hay copias de seguridad disponibles en $COPIAS_DIR." 8 50
        return
    fi

    # Crear un archivo temporal con la lista de copias
    local copias_temp=$(mktemp)
    echo "$archivos" > "$copias_temp"

    # Mostrar el menú para seleccionar la copia
    dialog --nocancel --menu "Seleccione la copia de seguridad a restaurar:" 15 50 10 $(awk '{print NR " " $0}' "$copias_temp") 2>seleccion_temp
    local seleccion=$(<seleccion_temp)
    local copia_seleccionada=$(sed -n "${seleccion}p" "$copias_temp")

    if [ -z "$copia_seleccionada" ]; then
        dialog --msgbox "No se seleccionó ninguna copia. Restauración cancelada." 8 50
    else
        dialog --yesno "¿Desea restaurar la copia seleccionada?\n\nCopia: $copia_seleccionada" 10 50
        local confirmacion=$?

        if [ $confirmacion -eq 0 ]; then
            if [ -f "$COPIAS_DIR/$copia_seleccionada" ]; then
                tar -xzvf "$COPIAS_DIR/$copia_seleccionada" -C /
                if [ $? -eq 0 ]; then
                    dialog --msgbox "¡Restauración completada!" 8 50
                else
                    dialog --msgbox "Error al restaurar la copia. Debes ejecutar la aplicacion como administrador." 8 50
                fi
            else
                dialog --msgbox "El archivo seleccionado no existe. Restauración cancelada." 8 50
            fi
        else
            dialog --msgbox "Restauración cancelada." 8 50
        fi
    fi

    # Limpiar archivos temporales
    rm -f "$copias_temp" seleccion_temp
}

# --- Función para mostrar el menú principal ---
function copias_seguridad {
    while true; do
        dialog --nocancel --menu "Seleccione una opción:" 15 50 10 \
            1 "Crear copia de seguridad" \
            2 "Restaurar copia de seguridad" \
            3 "Volver" 2>opcion_temp

        local opcion=$(<opcion_temp)

        case $opcion in
            1) crear_copia ;;
            2) restaurar_copia ;;
            3) break ;;
            *) dialog --msgbox "Opción no válida." 8 50 ;;
        esac
    done

    # Limpiar archivo temporal
    rm -f opcion_temp
}

