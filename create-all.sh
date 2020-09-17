#!/bin/sh

basedir=$(dirname $0)
tex=$(find ${basedir} -name '*.tex' -type f)

for f in ${tex}
do
    (cd $(dirname $f); pdflatex -shell-escape $(basename $f))
done
