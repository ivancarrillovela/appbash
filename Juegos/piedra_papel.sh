#!/bin/bash

# Inicializar marcador
victorias=0
derrotas=0
empates=0

# Traducciones con emojis
declare -A opciones
opciones[1]="🪨 Piedra"
opciones[2]="📄 Papel"
opciones[3]="✂️ Tijera"

while true; do
    # Mostrar menú de elección
    eleccion=$(dialog --stdout --title "🎮 Piedra, Papel o Tijera" \
        --menu "¿Qué eliges?" 15 40 3 \
        1 "🪨 Piedra" \
        2 "📄 Papel" \
        3 "✂️ Tijera")

    # Si se canceló
    if [ -z "$eleccion" ]; then
        dialog --msgbox "🚫 Juego cancelado." 8 30
        break
    fi

    # Elección aleatoria de la CPU
    cpu=$((RANDOM % 3 + 1))

    # Mostrar CPU pensando...
    dialog --infobox "🤖 La CPU está eligiendo..." 3 40
    sleep 1.5

    # Calcular resultado
    if [ "$eleccion" -eq "$cpu" ]; then
        resultado="🤝 ¡Empate!"
        ((empates++))
    elif [[ "$eleccion" == 1 && "$cpu" == 3 ]] || \
         [[ "$eleccion" == 2 && "$cpu" == 1 ]] || \
         [[ "$eleccion" == 3 && "$cpu" == 2 ]]; then
        resultado="🎉 ¡Ganaste!"
        ((victorias++))
    else
        resultado="💀 Perdiste 😢"
        ((derrotas++))
    fi

    # Mostrar resultado y marcador
    dialog --title "Resultado de la Ronda" --msgbox \
"🧍 Tú: ${opciones[$eleccion]}\n🤖 CPU: ${opciones[$cpu]}\n\n$resultado\n\n📊 Marcador actual:\n✅ Victorias: $victorias\n❌ Derrotas: $derrotas\n🤝 Empates: $empates" 15 50

    # Preguntar si quiere jugar de nuevo
    dialog --yesno "¿Quieres jugar otra vez?" 8 40
    respuesta=$?

    if [ $respuesta -ne 0 ]; then
        break
    fi
done

