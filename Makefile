EDY_TEX   := $(shell find electrodynamics -name '*.tex' -type f | sort)
MEC_TEX   := $(shell find mechanics       -name '*.tex' -type f | sort)
OPT_TEX   := $(shell find optics          -name '*.tex' -type f | sort)
TEX_FILES := $(EDY_TEX) $(MEC_TEX) $(OPT_TEX)

AUX_FILES := $(patsubst %.tex,%.aux,$(TEX_FILES))
LOG_FILES := $(patsubst %.tex,%.log,$(TEX_FILES))
PDF_FILES := $(patsubst %.tex,%.pdf,$(TEX_FILES))
PNG_FILES := $(patsubst %.tex,%.png,$(TEX_FILES))
SVG_FILES := $(patsubst %.pdf,%.svg,$(PDF_FILES))

EDY_MD    := electrodynamics.md
EDY_SVG   := $(patsubst %.tex,%.svg,$(EDY_TEX))

MEC_MD    := mechanics.md
MEC_SVG   := $(patsubst %.tex,%.svg,$(MEC_TEX))

OPT_MD    := optics.md
OPT_SVG   := $(patsubst %.tex,%.svg,$(OPT_TEX))

MD_FILES  := $(EDY_MD) $(MEC_MD) $(OPT_MD)

.PHONY: all clean distclean

all: $(PDF_FILES) $(PNG_FILES) $(SVG_FILES) $(MD_FILES)

clean:
	-rm -f $(AUX_FILES) $(LOG_FILES)

distclean: clean
	-rm -f $(PDF_FILES) $(PNG_FILES) $(SVG_FILES)
	-rm -f $(MD_FILES)

$(EDY_MD): $(EDY_SVG)
	./generate-list Electrodynamics $^ > $@

$(MEC_MD): $(MEC_SVG)
	./generate-list Mechanics $^ > $@

$(OPT_MD): $(OPT_SVG)
	./generate-list Optics $^ > $@

%.pdf: %.tex
	cd $(dir $<) && pdflatex $(notdir $<)

%.png: %.pdf
	cd $(dir $<) && pdftoppm -singlefile -r 300 -png $(notdir $<) $(basename $(notdir $@))

%.svg: %.pdf
	pdf2svg $< $@
