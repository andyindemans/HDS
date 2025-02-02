#!/bin/sh 
set -e 

if [ ! -z "$@" ]; then
    echo "Running command: $@"
    exec $@
    exit $?
fi

if [ ! -z "$TRUSTED_CA_BUNDLE" ]; then
    cp /etc/ssl/certs/ca-certificates.crt /tmp/ca-certificates.crt
    echo "${TRUSTED_CA_BUNDLE}" >> /tmp/ca-certificates.crt
    export CURL_CA_BUNDLE="/tmp/ca-certificates.crt" 
fi

echo "Starting gunicorn server..."
export FLASK_ENV=production
cd ~/api
exec ~/.local/bin/gunicorn -b 0.0.0.0:5000 --timeout 0 $GUNICORN_CMD_ARGS "app:app"
