#!/bin/bash

# --- Función para crear un usuario ---
function crear_usuario {
    local nombre_usuario=$(dialog --stdout --inputbox "Introduce el nombre del nuevo usuario:" 8 40)

    if [ -z "$nombre_usuario" ]; then
        dialog --msgbox "Nombre de usuario vacío o cancelado. No se ha creado ningún usuario." 8 50
    else
        if id "$nombre_usuario" &>/dev/null; then
            dialog --msgbox "El usuario '$nombre_usuario' ya existe." 8 40
        else
            sudo useradd "$nombre_usuario"
            if [ $? -eq 0 ]; then
                dialog --msgbox "Usuario '$nombre_usuario' creado correctamente." 8 50
            else
                dialog --msgbox "Error al crear el usuario. ¿Tienes permisos de administrador?" 8 50
            fi
        fi
    fi
}

# --- Función para eliminar un usuario ---
function eliminar_usuario {
    local usuarios=$(awk -F: '$3 >= 1000 && $3 < 65534 { print $1 }' /etc/passwd)
    local menu_items=()
    for u in $usuarios; do
        menu_items+=("$u" "")
    done

    local usuario_a_borrar=$(dialog --stdout --menu "Selecciona el usuario a eliminar:" 15 50 8 "${menu_items[@]}")

    if [ -z "$usuario_a_borrar" ]; then
        dialog --msgbox "Acción cancelada. No se ha eliminado ningún usuario." 8 50
    else
        dialog --yesno "¿Estás seguro de que quieres eliminar al usuario '$usuario_a_borrar'?" 8 50
        if [ $? -eq 0 ]; then
            sudo userdel -r "$usuario_a_borrar"
            if [ $? -eq 0 ]; then
                dialog --msgbox "Usuario '$usuario_a_borrar' eliminado correctamente." 8 50
            else
                dialog --msgbox "Error al eliminar el usuario. ¿Tienes permisos de administrador?" 8 50
            fi
        else
            dialog --msgbox "Eliminación cancelada." 8 50
        fi
    fi
}

# --- Función para bloquear un usuario ---
function bloquear_usuario {
    local usuarios=$(awk -F: '$3 >= 1000 && $3 < 65534 { print $1 }' /etc/passwd)
    local menu_items=()
    for u in $usuarios; do
        menu_items+=("$u" "")
    done

    local usuario_a_bloquear=$(dialog --stdout --menu "Selecciona el usuario a bloquear:" 15 50 8 "${menu_items[@]}")

    if [ -z "$usuario_a_bloquear" ]; then
        dialog --msgbox "Nombre vacío o cancelado. No se ha bloqueado ningún usuario." 8 50
    else
        if id "$usuario_a_bloquear" &>/dev/null; then
            dialog --yesno "¿Estás seguro de que quieres bloquear al usuario '$usuario_a_bloquear'?" 8 50
            if [ $? -eq 0 ]; then
                sudo usermod -L "$usuario_a_bloquear"
                if [ $? -eq 0 ]; then
                    dialog --msgbox "Usuario '$usuario_a_bloquear' bloqueado correctamente." 8 50
                else
                    dialog --msgbox "Error al bloquear el usuario. ¿Tienes permisos de administrador?" 8 50
                fi
            else
                dialog --msgbox "Acción cancelada." 8 40
            fi
        else
            dialog --msgbox "El usuario '$usuario_a_bloquear' no existe." 8 40
        fi
    fi
}

# --- Función para listar usuarios ---
function listar_usuarios {
    local lista_usuarios=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd)
    dialog --msgbox "Usuarios del sistema:\n\n$lista_usuarios" 20 50
}

# --- Función para desbloquear un usuario ---
function desbloquear_usuario {
    local usuarios_bloqueados=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd | while read usuario; do
        if sudo grep -q "^$usuario:!.*" /etc/shadow; then
            echo "$usuario"
        fi
    done)

    if [ -z "$usuarios_bloqueados" ]; then
        dialog --msgbox "No hay usuarios bloqueados." 8 40
    else
        local opciones=()
        for u in $usuarios_bloqueados; do
            opciones+=("$u" "")
        done

        local usuario_a_desbloquear=$(dialog --stdout --title "Desbloquear usuario" \
            --menu "Selecciona un usuario para desbloquear:" 20 50 10 "${opciones[@]}")

        if [ -n "$usuario_a_desbloquear" ]; then
            dialog --yesno "¿Seguro que quieres desbloquear al usuario '$usuario_a_desbloquear'?" 8 50
            if [ $? -eq 0 ]; then
                sudo usermod -U "$usuario_a_desbloquear"
                if [ $? -eq 0 ]; then
                    dialog --msgbox "Usuario '$usuario_a_desbloquear' desbloqueado correctamente." 8 50
                else
                    dialog --msgbox "Error al desbloquear el usuario." 8 50
                fi
            else
                dialog --msgbox "Desbloqueo cancelado." 8 40
            fi
        fi
    fi
}

# --- Menú principal ---
function usuarios {
    while true; do
        opcion=$(dialog --clear --stdout \
            --title "Administrar Usuarios" \
            --nocancel --menu "Selecciona una acción:" 15 50 6 \
            1 "Crear usuario" \
            2 "Eliminar usuario" \
            3 "Bloquear usuario" \
            4 "Listar usuarios" \
            5 "Desbloquear usuario" \
            6 "Volver")

        case $opcion in
            1) crear_usuario ;;
            2) eliminar_usuario ;;
            3) bloquear_usuario ;;
            4) listar_usuarios ;;
            5) desbloquear_usuario ;;
            6) break ;;
            "") clear; echo "Has cancelado o cerrado el menú."; exit 1 ;;
            *) dialog --msgbox "Opción no válida" 8 30 ;;
        esac
    done
}