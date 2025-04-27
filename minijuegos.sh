#!/bin/bash

function juegos {
    while true; do
        opcion=$(dialog --clear --stdout \
            --title "Minijuegos" \
            --nocancel --menu "Elige un juego:" 15 50 6 \
            1 "Adivina el número" \
            2 "Piedra, Papel o Tijera" \
            3 "Lanzar un dado" \
            4 "Volver")

        case $opcion in
            1) bash Juegos/adivina.sh ;;
            2) bash Juegos/piedra_papel.sh ;;
            3) bash Juegos/dado.sh ;;
            4) break ;;
            "") clear; echo "Menú cancelado."; exit 1 ;;
            *) dialog --msgbox "Opción no válida" 8 30 ;;
        esac
    done
}


