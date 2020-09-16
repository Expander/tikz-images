#!/bin/sh -e

pdflatex -shell-escape lens-paraxial.tex

rm -f *.aux *.log
