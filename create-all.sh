#!/bin/sh

dirs="
diacaustic
"

for f in ${dirs}
do
    (cd $f; [ -e create.sh ] && ./create.sh)
done
