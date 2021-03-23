#!/bin/sh

if [[ -f "$PASSWORD_FILE" ]]; then
    PASSWORD=$(cat "$PASSWORD_FILE")
fi

if [[ -f "/var/run/secrets/$PASSWORD_SECRET" ]]; then
    PASSWORD=$(cat "/var/run/secrets/$PASSWORD_SECRET")
fi

if [[ -f "$SERVER_ADDR_FILE" ]]; then
    SERVER_ADDR=$(cat "$SERVER_ADDR_FILE")
fi

if [[ -f "/var/run/secrets/$SERVER_ADDR_SECRET" ]]; then
    SERVER_ADDR=$(cat "/var/run/secrets/$SERVER_ADDR_SECRET")
fi

exec ss-local \
      -s $SERVER_ADDR \
      -p $SERVER_PORT \
      -b $LOCAL_ADDR \
      -l $LOCAL_PORT \
      -k ${PASSWORD:-$(hostname)} \
      -m $METHOD \
      -t $TIMEOUT \
      --fast-open \
      -u 