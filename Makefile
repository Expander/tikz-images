DID_MD    := didactics.md
DID_TEX   := $(shell find didactics       -name '*.tex' -a ! -name '*_inverted.tex' -type f | sort)
DID_TEX   := $(DID_TEX) $(patsubst %.tex,%_inverted.tex,$(DID_TEX))
DID_SVG   := $(patsubst %.tex,%.svg,$(DID_TEX))

EDY_MD    := electrodynamics.md
EDY_TEX   := $(shell find electrodynamics -name '*.tex' -a ! -name '*_inverted.tex' -type f | sort)
EDY_TEX   := $(EDY_TEX) $(patsubst %.tex,%_inverted.tex,$(EDY_TEX))
EDY_SVG   := $(patsubst %.tex,%.svg,$(EDY_TEX))

MEC_MD    := mechanics.md
MEC_TEX   := $(shell find mechanics       -name '*.tex' -a ! -name '*_inverted.tex' -type f | sort)
MEC_TEX   := $(MEC_TEX) $(patsubst %.tex,%_inverted.tex,$(MEC_TEX))
MEC_SVG   := $(patsubst %.tex,%.svg,$(MEC_TEX))

OPT_MD    := optics.md
OPT_TEX   := $(shell find optics          -name '*.tex' -a ! -name '*_inverted.tex' -type f | sort)
OPT_TEX   := $(OPT_TEX) $(patsubst %.tex,%_inverted.tex,$(OPT_TEX))
OPT_SVG   := $(patsubst %.tex,%.svg,$(OPT_TEX))

STA_MD    := statistics.md
STA_TEX   := $(shell find statistics      -name '*.tex' -a ! -name '*_inverted.tex' -type f | sort)
STA_TEX   := $(STA_TEX) $(patsubst %.tex,%_inverted.tex,$(STA_TEX))
STA_SVG   := $(patsubst %.tex,%.svg,$(STA_TEX))

MD_FILES  := $(DID_MD)  $(EDY_MD)  $(MEC_MD)  $(OPT_MD)  $(STA_MD)
SVG_FILES := $(DID_SVG) $(EDY_SVG) $(MEC_SVG) $(OPT_SVG) $(STA_SVG)
TEX_FILES := $(DID_TEX) $(EDY_TEX) $(MEC_TEX) $(OPT_TEX) $(STA_TEX)

AUX_FILES := $(patsubst %.tex,%.aux,$(TEX_FILES))
LOG_FILES := $(patsubst %.tex,%.log,$(TEX_FILES))
PDF_FILES := $(patsubst %.tex,%.pdf,$(TEX_FILES))
PNG_FILES := $(patsubst %.tex,%.png,$(TEX_FILES))

.PHONY: all clean distclean

.PRECIOUS: %_inverted.tex

all: $(PDF_FILES) $(PNG_FILES) $(SVG_FILES) $(MD_FILES)

clean:
	-rm -f $(AUX_FILES) $(LOG_FILES)

distclean: clean
	-rm -f $(PDF_FILES) $(PNG_FILES) $(SVG_FILES) $(MD_FILES)

$(DID_MD): $(DID_SVG)
	./generate-list Didactics $^ > $@

$(EDY_MD): $(EDY_SVG)
	./generate-list Electrodynamics $^ > $@

$(MEC_MD): $(MEC_SVG)
	./generate-list Mechanics $^ > $@

$(OPT_MD): $(OPT_SVG)
	./generate-list Optics $^ > $@

$(STA_MD): $(STA_SVG)
	./generate-list Statistics $^ > $@

%_inverted.tex: %.tex invert_colors
	./invert_colors $< $@

%.pdf: %.tex
	cd $(dir $<) && pdflatex --shell-escape $(notdir $<)

%.png: %.pdf
	cd $(dir $<) && pdftoppm -singlefile -r 300 -png $(notdir $<) $(basename $(notdir $@))

%.svg: %.pdf
	pdf2svg $< $@
