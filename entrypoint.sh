#!/bin/sh

if [ -z "$SPLATNET2STATINK_CONFIG" ]; then
  echo 'The environment variable SPLATNET2STATINK_CONFIG is missing'
  exit 1
fi

echo $SPLATNET2STATINK_CONFIG > config.txt

exec "$@"
