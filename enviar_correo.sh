#!/bin/bash

# --- Función para enviar correo utilizando el script Python ---
function correo {
    # Solicitar datos al usuario
    destinatario=$(dialog --nocancel --stdout --inputbox "Introduce el correo del destinatario:" 8 50)
    if [ -z "$destinatario" ]; then
        dialog --msgbox "El destinatario no puede estar vacío. Operación cancelada." 8 50
        return
    fi

    asunto=$(dialog --nocancel --stdout --inputbox "Introduce el asunto del correo:" 8 50)
    if [ -z "$asunto" ]; then
        dialog --msgbox "El asunto no puede estar vacío. Operación cancelada." 8 50
        return
    fi

    cuerpo=$(dialog --nocancel --stdout --inputbox "Introduce el cuerpo del correo:" 10 50)
    if [ -z "$cuerpo" ]; then
        dialog --msgbox "El cuerpo del correo no puede estar vacío. Operación cancelada." 8 50
        return
    fi

    # Ejecutar el script Python con los datos proporcionados
    python3 sendmail.py "$destinatario" "$asunto" "$cuerpo"

    # Verificar si el correo fue enviado correctamente
    if [ $? -eq 0 ]; then
        dialog --msgbox "Correo enviado correctamente." 8 50
    else
        dialog --msgbox "Error al enviar el correo. Verifique los datos y la conexión." 8 50
    fi
}