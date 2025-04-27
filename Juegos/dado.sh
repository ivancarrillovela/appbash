#!/bin/bash

# Historial en memoria
historial=""

# (Opcional) Historial en archivo externo
historial_archivo="historial_dado.txt"
echo "🎲 Nuevo juego de dados - $(date)" > "$historial_archivo"

while true; do
    # Mostrar "lanzando..."
    dialog --infobox "🎲 Lanzando el dado..." 3 40
    sleep 1.5

    # Calcular resultado entre 1 y 6
    resultado=$((RANDOM % 6 + 1))

    # Representación con emoji
    case $resultado in
        1) cara="⚀" ;;
        2) cara="⚁" ;;
        3) cara="⚂" ;;
        4) cara="⚃" ;;
        5) cara="⚄" ;;
        6) cara="⚅" ;;
    esac

    # Guardar en historial
    historial+=" $cara"
    echo "$resultado $cara" >> "$historial_archivo"

    # Mostrar resultado actual + historial
    dialog --title "Resultado del dado" --msgbox \
"Has lanzado el dado...\n\n🎲 Resultado: $resultado $cara\n\n📜 Historial:\n$historial" 15 50

    # Preguntar si quiere lanzar de nuevo
    dialog --yesno "¿Quieres lanzar otra vez?" 8 40
    respuesta=$?

    if [ $respuesta -ne 0 ]; then
        break
    fi
done

# Mensaje final con ruta al historial
dialog --msgbox "Gracias por jugar, sir.\n\n📁 El historial se ha guardado en:\n$historial_archivo" 10 50

