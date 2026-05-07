#!/usr/bin/env bash
set -e

HTPASSWD_FILE="/config/users"

if [ -z "$RADICALE_PASSWORD" ]; then
    if [ ! -f "$HTPASSWD_FILE" ]; then
        echo "WARNING: No password provided and no users file found!"
        echo "Setting default credentials: admin / radicale"
        RADICALE_PASSWORD="radicale"
    fi
fi

if [ -n "$RADICALE_PASSWORD" ]; then
    echo "Updating admin password..."
    BCRYPT_HASH=$(python3 -c "from passlib.hash import bcrypt; print(bcrypt.hash('$RADICALE_PASSWORD'))")
    echo "admin:$BCRYPT_HASH" > "$HTPASSWD_FILE"
fi

echo "Starting Radicale..."
exec python3 -m radicale --config /config/config.ini
