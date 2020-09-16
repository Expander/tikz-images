#!/bin/sh

dirs="
lens-diacaustic
lens-paraxial
"

for f in ${dirs}
do
    (cd $f; [ -e create.sh ] && ./create.sh)
done
