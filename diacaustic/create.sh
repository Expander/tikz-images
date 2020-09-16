#!/bin/sh -e

pdflatex -shell-escape diacaustic.tex

rm -f *.aux *.log
