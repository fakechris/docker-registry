#!/bin/bash

GUNICORN_WORKERS=${GUNICORN_WORKERS:-8}
REGISTRY_PORT=${REGISTRY_PORT:-5000}
GUNICORN_GRACEFUL_TIMEOUT=${GUNICORN_GRACEFUL_TIMEOUT:-3600}
GUNICORN_SILENT_TIMEOUT=${GUNICORN_SILENT_TIMEOUT:-3600}

cd "$(dirname $0)"
gunicorn -e SETTINGS_FLAVOR=prod --access-logfile - --max-requests 100 --graceful-timeout $GUNICORN_GRACEFUL_TIMEOUT -t $GUNICORN_SILENT_TIMEOUT -k gevent -b 0.0.0.0:$REGISTRY_PORT -w $GUNICORN_WORKERS wsgi:application
