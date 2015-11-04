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
       IMAGES_DIR="images"
        BASE_FILE="index"

    FONTS_SRC_DIR="$APP_DIR/$FONTS_DIR"
   IMAGES_SRC_DIR="$APP_DIR/$IMAGES_DIR"
   ASSET_SRC_DIRS="$FONTS_SRC_DIR $IMAGES_SRC_DIR"
     CSS_SRC_FILE="$APP_DIR/$BASE_FILE.styl"
    HTML_SRC_FILE="$APP_DIR/$BASE_FILE.jade"
      JS_SRC_FILE="$APP_DIR/$BASE_FILE.js"

          PUB_DIR="$PROJ_DIR/public"
    FONTS_DST_DIR="$PUB_DIR/$FONTS_DIR"
   IMAGES_DST_DIR="$PUB_DIR/$IMAGES_DIR"
   ASSET_DST_DIRS="$FONTS_DST_DIR $IMAGES_DST_DIR"
    HTML_DST_FILE="$PUB_DIR/$BASE_FILE.html"
      JS_DST_FILE="$PUB_DIR/$BASE_FILE.js"

    LOCAL_BIN_DIR="$PROJ_DIR/node_modules/.bin"
     CSS_PROC_BIN="$LOCAL_BIN_DIR/stylus"
    HTML_PROC_BIN="$LOCAL_BIN_DIR/jade"
      JS_PROC_BIN="$LOCAL_BIN_DIR/browserify"
     JS_PROC_BINW="$LOCAL_BIN_DIR/watchify"
        SERVE_BIN="$LOCAL_BIN_DIR/budo"

clean-dir()   { for d; { [ -d $d ] && rm -r $d; true; }; }
make-dir()    { for d; { [ -d $d ] || mkdir -p $d; }; }
copy-new()    { cp -u $1/* $2; }

fonts()       { copy-new $FONTS_SRC_DIR  $FONTS_DST_DIR; }
images()      { copy-new $IMAGES_SRC_DIR $IMAGES_DST_DIR; }
assets()      { fonts; images; }
css()         { $CSS_PROC_BIN     -o $PUB_DIR          $CSS_SRC_FILE  $@;}
html()        { $HTML_PROC_BIN    -o $PUB_DIR --pretty $HTML_SRC_FILE $@; }
js()          { ${1-$JS_PROC_BIN} -o $JS_DST_FILE      $JS_SRC_FILE   $2 $3; }

assets-w()    { while (true); do inotifywait $ASSET_SRC_DIRS; assets; done; }
css-w()       { css  --watch; }
html-w()      { html --watch; }
js-w()        { js $JS_PROC_BINW -v --delay 100;}
serve()       { $SERVE_BIN $JS_DST_FILE --live; }

clean()       { clean-dir $PUB_DIR; }
prebuild()    { make-dir $ASSET_DST_DIRS; assets; }

build()       { css && html && js; }
live()        { css-w & html-w & js-w & serve & assets-w;}

$ACTION
