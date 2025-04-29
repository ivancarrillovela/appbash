#!/bin/bash

# --- Dar permisos de ejecución a todos los archivos en la carpeta ---
function dar_permisos_ejecucion {
    local carpeta=$1

    if [ -d "$carpeta" ]; then
        chmod +x "$carpeta"/*
        dialog --msgbox "Se han otorgado permisos de ejecución a todos los archivos en la carpeta: $carpeta" 8 50
    else
        dialog --msgbox "La carpeta $carpeta no existe. Verifica la ruta." 8 50
    fi
}

# --- Instalación de paquetes mínimos y configuración de copias ---
function minimos {
    dialog --infobox "Comprobando e instalando los requisitos mínimos..." 5 40
    apt-get update 
    instalar_paquete dialog
    instalar_paquete netcat
    instalar_paquete python3
    instalar_paquete ssh
    instalar_paquete rsync
    instalar_paquete tar
    instalar_paquete clamav
    instalar_paquete chkrootkit
    

    # Ruta del directorio para las copias de seguridad
    local directorio_copias="/var/backups/mis_backups/"
    crear_directorio_copias "$directorio_copias"

    # Dar permisos de ejecución a los archivos en el directorio actual
    dar_permisos_ejecucion "$(pwd)"

    dialog --msgbox "Todos los requisitos están instalados y el directorio para las copias de seguridad está listo en: $directorio_copias" 8 50
}

# --- Instalación de requisitos mínimos ---
function instalar_paquete {
    local paquete=$1

    if ! command -v "$paquete" &>/dev/null; then
        dialog --infobox "El paquete '$paquete' no está instalado. Procediendo con la instalación..." 5 50
        if command -v apt-get &>/dev/null; then
            sudo apt-get update
            sudo apt-get install -y "$paquete"
        elif command -v yum &>/dev/null; then
            sudo yum install -y "$paquete"
        elif command -v pacman &>/dev/null; then
            sudo pacman -Sy --noconfirm "$paquete"
        else
            dialog --msgbox "Gestor de paquetes no compatible. Instala '$paquete' manualmente." 8 50
            exit 1
        fi
    fi
}

# --- Crear directorio para copias de seguridad ---
function crear_directorio_copias {
    local directorio=$1

    if [ ! -d "$directorio" ]; then
        mkdir -p "$directorio"
        dialog --infobox "Creando el directorio para copias de seguridad en: $directorio" 5 50
    else
        dialog --msgbox "El directorio $directorio ya existe." 8 50
    fi
}
