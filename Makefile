TEX_FILES := $(shell find . -name '*.tex' -type f)

AUX_FILES := $(patsubst %.tex,%.aux,$(TEX_FILES))
LOG_FILES := $(patsubst %.tex,%.log,$(TEX_FILES))
PDF_FILES := $(patsubst %.tex,%.pdf,$(TEX_FILES))
SVG_FILES := $(patsubst %.pdf,%.svg,$(PDF_FILES))

LIST_FILE := list.md

.PHONY: all clean distclean list

all: $(PDF_FILES) list

clean:
	-rm -f $(AUX_FILES) $(LOG_FILES)

distclean: clean
	-rm -f $(PDF_FILES) $(SVG_FILES)
	-rm -f $(LIST_FILE)

list: $(SVG_FILES)
	./generate-list $(SVG_FILES) > $(LIST_FILE)

%.pdf: %.tex
	cd $(shell dirname $<) && pdflatex -shell-escape $(shell basename $<)

%.svg: %.pdf
	@true