EDY_TEX   := $(shell find electrodynamics -name '*.tex' -type f | sort)
MEC_TEX   := $(shell find mechanics       -name '*.tex' -type f | sort)
OPT_TEX   := $(shell find optics          -name '*.tex' -type f | sort)
TEX_FILES := $(EDY_TEX) $(MEC_TEX) $(OPT_TEX)

AUX_FILES := $(patsubst %.tex,%.aux,$(TEX_FILES))
LOG_FILES := $(patsubst %.tex,%.log,$(TEX_FILES))
PDF_FILES := $(patsubst %.tex,%.pdf,$(TEX_FILES))
PNG_FILES := $(patsubst %.tex,%.png,$(TEX_FILES))
SVG_FILES := $(patsubst %.pdf,%.svg,$(PDF_FILES))

EDY_LIST  := electrodynamics.md
EDY_SVG   := $(patsubst %.tex,%.svg,$(EDY_TEX))

MEC_LIST  := mechanics.md
MEC_SVG   := $(patsubst %.tex,%.svg,$(MEC_TEX))

OPT_LIST  := optics.md
OPT_SVG   := $(patsubst %.tex,%.svg,$(OPT_TEX))

MD_FILES  := $(EDY_LIST) $(MEC_LIST) $(OPT_LIST)

.PHONY: all clean distclean

all: $(PDF_FILES) $(PNG_FILES) $(SVG_FILES) $(MD_FILES)

clean:
	-rm -f $(AUX_FILES) $(LOG_FILES)

distclean: clean
	-rm -f $(PDF_FILES) $(PNG_FILES) $(SVG_FILES)
	-rm -f $(MD_FILES)

$(EDY_LIST): $(EDY_SVG)
	./generate-list $^ > $@

$(MEC_LIST): $(MEC_SVG)
	./generate-list $^ > $@

$(OPT_LIST): $(OPT_SVG)
	./generate-list $^ > $@

%.pdf: %.tex
	cd $(dir $<) && pdflatex $(notdir $<)

%.png: %.pdf
	cd $(dir $<) && pdftoppm -singlefile -r 300 -png $(notdir $<) $(basename $(notdir $@))

%.svg: %.pdf
	pdf2svg $< $@
