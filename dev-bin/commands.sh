#!/bin/bash -e

set -e
set -o pipefail

  [ "$DEBUG" ]  &&  set -x

              CMD="$0"
           ACTION="${1-build}"

          CMD_DIR="$(cd "$(dirname "$CMD")" && pwd -P)"
         PROJ_DIR="$(dirname "$CMD_DIR")"

          APP_DIR="$PROJ_DIR/app"
        FONTS_DIR="fonts"
        BASE_FILE="index"

    FONTS_SRC_DIR="$APP_DIR/$FONTS_DIR"
     CSS_SRC_FILE="$APP_DIR/$BASE_FILE.styl"
    HTML_SRC_FILE="$APP_DIR/$BASE_FILE.jade"
      JS_SRC_FILE="$APP_DIR/$BASE_FILE.js"

          PUB_DIR="$PROJ_DIR/public"
    FONTS_DST_DIR="$PUB_DIR/$FONTS_DIR"
    HTML_DST_FILE="$PUB_DIR/$BASE_FILE.html"
      JS_DST_FILE="$PUB_DIR/$BASE_FILE.js"

    LOCAL_BIN_DIR="$PROJ_DIR/node_modules/.bin"
     CSS_PROC_BIN="$LOCAL_BIN_DIR/stylus"
    HTML_PROC_BIN="$LOCAL_BIN_DIR/jade"
      JS_PROC_BIN="$LOCAL_BIN_DIR/browserify"
     JS_PROC_BINW="$LOCAL_BIN_DIR/watchify"
        SERVE_BIN="$LOCAL_BIN_DIR/budo"

fonts()    { cp -u $FONTS_SRC_DIR/* $FONTS_DST_DIR; }
css()      { $CSS_PROC_BIN -o $PUB_DIR $CSS_SRC_FILE $@;}
html()     { $HTML_PROC_BIN -o $PUB_DIR --pretty $HTML_SRC_FILE $@; }
js()       { ${1-$JS_PROC_BIN} -o $JS_DST_FILE $JS_SRC_FILE $2 $3; }

css-w()    { css --watch; }
html-w()   { html --watch; }
js-w()     { js $JS_PROC_BINW -v --delay 100;}
serve()    { $SERVE_BIN $JS_DST_FILE --live; }

clean()    { [ -d $PUB_DIR ] && rm -r $PUB_DIR; true; }
prebuild() { [ -d $FONTS_DST_DIR ] || mkdir -p $FONTS_DST_DIR; fonts; }

build()    { css && html && js; }
live()     { css-w & html-w & js-w & serve & }

$ACTION
