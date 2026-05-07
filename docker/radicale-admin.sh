#!/bin/bash
HTPASSWD_FILE="/config/users"
touch "$HTPASSWD_FILE"

while true; do
    CHOICE=$(whiptail --title "Radicale Admin" --menu "Choose an option" 15 60 4 \
        "1" "Add/Update User" \
        "2" "Delete User" \
        "3" "List Users" \
        "4" "Exit" 3>&1 1>&2 2>&3)

    case "$CHOICE" in
        1)
            USERNAME=$(whiptail --inputbox "Enter username" 8 40 3>&1 1>&2 2>&3)
            PASSWORD=$(whiptail --passwordbox "Enter password" 8 40 3>&1 1>&2 2>&3)
            if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
                HASH=$(python3 -c "from passlib.hash import bcrypt; print(bcrypt.hash('$PASSWORD'))")
                sed -i "/^$USERNAME:/d" "$HTPASSWD_FILE"
                echo "$USERNAME:$HASH" >> "$HTPASSWD_FILE"
                whiptail --msgbox "User $USERNAME updated." 8 40
            fi
            ;;
        2)
            USERNAME=$(whiptail --inputbox "Enter username to delete" 8 40 3>&1 1>&2 2>&3)
            if [ -n "$USERNAME" ]; then
                sed -i "/^$USERNAME:/d" "$HTPASSWD_FILE"
                whiptail --msgbox "User $USERNAME deleted." 8 40
            fi
            ;;
        3)
            USERS=$(cut -d: -f1 "$HTPASSWD_FILE")
            whiptail --msgbox "Current users:\n$USERS" 15 40
            ;;
        *) break ;;
    esac
done
