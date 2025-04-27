#!/bin/bash

while true; do
    numero_secreto=$(( RANDOM % 10 + 1 ))
    intentos=0

    while true; do
        guess=$(dialog --stdout --inputbox "🔢 Adivina un número del 1 al 10:" 8 40)
        ((intentos++))

        # Si canceló
        if [ -z "$guess" ]; then
            dialog --msgbox "🚫 Juego cancelado." 8 30
            break
        fi

        # Validar que sea un número
        if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
            dialog --msgbox "❗ Eso no es un número válido." 8 30
        elif [ "$guess" -lt "$numero_secreto" ]; then
            dialog --msgbox "📉 Demasiado bajo." 8 30
        elif [ "$guess" -gt "$numero_secreto" ]; then
            dialog --msgbox "📈 Demasiado alto." 8 30
        else
            dialog --msgbox "🎉 ¡Correcto! El número era $numero_secreto\nAdivinaste en $intentos intento(s)." 10 40
            break
        fi
    done

    # Preguntar si quiere jugar otra vez
    dialog --yesno "¿Quieres jugar otra vez?" 8 40
    respuesta=$?

    if [ $respuesta -ne 0 ]; then
        break
    fi
done

