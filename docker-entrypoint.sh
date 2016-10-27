#!/bin/bash

set -e

export GIT_AUTHOR_NAME="Some User"
export GIT_AUTHOR_EMAIL="some@mail.address"

exec "$@"
