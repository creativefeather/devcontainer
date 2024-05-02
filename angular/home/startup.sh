#!/bin/bash


: "${APP_NAME:=my_app}"
: "${ROUTING:=true}"
: "${STYLE:=css}"

# If the /app directory is empty, create an Angular app
if [ -z "$(ls -A /app)" ]; then
    cd /app
    npx ng new $APP_NAME \
    --directory . \
    --routing $ROUTING \
    --style $STYLE \
    --no-interactive
fi

npx ng serve --host 0.0.0.0 || tail -f /dev/null