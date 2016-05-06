#!/bin/bash

echo "Stalling for MongoDB"
while true; do
    nc -q 1 appmongo 27017 >/dev/null && break
done

/usr/bin/supervisord
