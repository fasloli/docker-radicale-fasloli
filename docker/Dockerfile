FROM python:3.11-alpine
RUN apk add --no-cache gcc musl-dev libffi-dev dos2unix newt bash \
    && pip install --no-cache-dir radicale passlib[bcrypt] \
    && apk del gcc musl-dev libffi-dev
RUN mkdir -p /data /config
COPY entrypoint.sh /entrypoint.sh
COPY radicale-admin.sh /usr/local/bin/radicale-admin
RUN dos2unix /entrypoint.sh /usr/local/bin/radicale-admin \
    && chmod +x /entrypoint.sh /usr/local/bin/radicale-admin
EXPOSE 5232
ENTRYPOINT ["/entrypoint.sh"]
