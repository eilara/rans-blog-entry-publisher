#!/bin/bash -e

set -e
set -o pipefail

[ "$DEBUG" ]  &&  set -x

ps | grep node | awk '{print $1}' | xargs kill
