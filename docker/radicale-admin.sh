#!/bin/bash
HTPASSWD_FILE="/config/users"
touch "$HTPASSWD_FILE"
while true; do
    CHOICE=$(whiptail --title "Radicale Admin Control Panel" \
        --backtitle "Management Tool" \
        --nocancel \
        --ok-button "Select" \
        --menu "Navigation:" 15 60 4 \
        "Add/Update" "Create or modify a user" \
        "Delete" "Remove a user from the system" \
        "List" "Display all registered users" \
        "Exit" "Close this administrator tool" 3>&1 1>&2 2>&3)
    case "$CHOICE" in
        "Add/Update")
            USERNAME=$(whiptail --inputbox "Enter username:" 8 40 3>&1 1>&2 2>&3)
            PASSWORD=$(whiptail --passwordbox "Enter password:" 8 40 3>&1 1>&2 2>&3)
            if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
                HASH=$(python3 -c "from passlib.hash import bcrypt; print(bcrypt.hash('$PASSWORD'))")
                sed -i "/^$USERNAME:/d" "$HTPASSWD_FILE"
                echo "$USERNAME:$HASH" >> "$HTPASSWD_FILE"
                whiptail --msgbox "Success: User $USERNAME has been updated." 8 45
            fi
            ;;
        "Delete")
            USERNAME=$(whiptail --inputbox "Enter username to delete:" 8 40 3>&1 1>&2 2>&3)
            if [ -n "$USERNAME" ]; then
                sed -i "/^$USERNAME:/d" "$HTPASSWD_FILE"
                whiptail --msgbox "Done: User $USERNAME removed." 8 40
            fi
            ;;
        "List")
            USERS=$(cut -d: -f1 "$HTPASSWD_FILE")
            FORMATTED_LIST="Current active users:\n---------------------\n$USERS"
            whiptail --title "User Registry" --ok-button "Back" --msgbox "$FORMATTED_LIST" 15 45
            ;;
        "Exit")
            clear
            break
            ;;
    esac
done
