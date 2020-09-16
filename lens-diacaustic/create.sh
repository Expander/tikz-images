#!/bin/sh -e

pdflatex -shell-escape lens-diacaustic.tex

rm -f *.aux *.log
