TEX_FILES := $(shell find . -name '*.tex' -type f | sort)

AUX_FILES := $(patsubst %.tex,%.aux,$(TEX_FILES))
LOG_FILES := $(patsubst %.tex,%.log,$(TEX_FILES))
PDF_FILES := $(patsubst %.tex,%.pdf,$(TEX_FILES))
SVG_FILES := $(patsubst %.pdf,%.svg,$(PDF_FILES))

LIST_FILE := list.md

.PHONY: all clean distclean

all: $(PDF_FILES) $(LIST_FILE)

clean:
	-rm -f $(AUX_FILES) $(LOG_FILES)

distclean: clean
	-rm -f $(PDF_FILES) $(SVG_FILES)
	-rm -f $(LIST_FILE)

$(LIST_FILE): $(SVG_FILES)
	./generate-list $^ > $@

%.pdf: %.tex
	cd $(shell dirname $<) && pdflatex -shell-escape $(shell basename $<)

%.svg: %.pdf
	pdf2svg $< $@
