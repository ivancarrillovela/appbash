#!/bin/bash

# --- Función de Acceso a Escritorio Remoto ---
function remoto {
    # Verificar si el comando 'dialog' está instalado
    if ! command -v dialog &>/dev/null; then
        echo "ERROR: El comando 'dialog' no está instalado."
        echo "Por favor, asegúrate de ejecutar la opción de 'Instalación de mínimos' antes de usar este script."
        exit 1
    fi

    # Solicitar los detalles de la conexión remota usando variables
    while true; do
        local ip=$(dialog --colors --nocancel --inputbox "\Zb\Z2Ingrese la dirección IP o el nombre del host del servidor:\Zn" 10 50 3>&1 1>&2 2>&3 3>&-)
        if [ -z "$ip" ]; then
            dialog --colors --msgbox "\Zb\Z1ERROR:\Zn No ha ingresado una dirección IP o un nombre de host válido. Este dato es obligatorio." 10 50
        else
            break
        fi
    done

    while true; do
        local usuario=$(dialog --colors --nocancel --inputbox "\Zb\Z2Ingrese el nombre de usuario:\Zn" 10 50 3>&1 1>&2 2>&3 3>&-)
        if [ -z "$usuario" ]; then
            dialog --colors --msgbox "\Zb\Z1ERROR:\Zn No ha ingresado un nombre de usuario. Este dato es obligatorio." 10 50
        else
            break
        fi
    done

    while true; do
        local puerto=$(dialog --colors --nocancel --inputbox "\Zb\Z2Ingrese el puerto (déjelo vacío para usar el 22 por defecto):\Zn" 10 50 3>&1 1>&2 2>&3 3>&-)
        if [ -z "$puerto" ]; then
            dialog --colors --yesno "\Zb\Z1ADVERTENCIA:\Zn No ha ingresado un puerto. ¿Desea usar el puerto predeterminado (22)?" 10 50
            if [ $? -eq 0 ]; then
                puerto=22
                break
            fi
        elif ! [[ "$puerto" =~ ^[0-9]+$ ]]; then
            dialog --colors --msgbox "\Zb\Z1ERROR:\Zn El puerto debe ser un número entero. Por favor, inténtelo de nuevo." 10 50
        else
            break
        fi
    done

    # Confirmar la conexión con los datos ingresados
    dialog --colors --yesno "\Zb\Z2Confirme los datos de conexión:\Zn\n\nServidor: $ip\nUsuario: $usuario\nPuerto: $puerto" 10 50
    local confirmacion=$?

    if [ $confirmacion -eq 0 ]; then
        # Intentar la conexión SSH
        clear
        echo "Intentando conectar a $usuario@$ip en el puerto $puerto..."
        ssh -p $puerto "$usuario@$ip"
        if [ $? -eq 0 ]; then
            dialog --colors --msgbox "\Zb\Z2¡Conexión finalizada correctamente!\Zn" 10 40
        else
            dialog --colors --msgbox "\Zb\Z1ERROR:\Zn No se pudo establecer la conexión SSH. Posibles causas:\n- Dirección IP o nombre de host incorrecto.\n- Nombre de usuario incorrecto.\n- Puerto bloqueado o inaccesible.\n- Servicio SSH no está activo en el servidor." 15 60
        fi
    else
        dialog --colors --msgbox "\Zb\Z1Conexión cancelada por el usuario.\Zn" 10 40
    fi
}