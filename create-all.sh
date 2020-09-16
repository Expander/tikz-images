#!/bin/sh

script='create.sh'
basedir=$(dirname $0)
dirs=$(find ${basedir} -name ${script} -type f | xargs dirname)

for f in ${dirs}
do
    (cd $f; [ -e ${script} ] && ./${script})
done
