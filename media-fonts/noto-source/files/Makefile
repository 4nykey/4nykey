glyphs:=$(wildcard src/*.glyphs src/*/*.plist src/*/*.ufo)
targets=$(addsuffix .built,$(glyphs))

all: $(targets)

%.glyphs.built: %.glyphs
	-$(FONTMAKE) -g $<
	@touch $@

%DevanagariUI-MM.plist.built: %DevanagariUI-MM.plist
	-$(FONTMAKE) --mti-source $< --family-name "Noto Sans Devanagari UI" -g $(addsuffix Devanagari-MM.glyphs,$*)
	@touch $@

%.plist.built: %.plist
	-$(FONTMAKE) --mti-source $< -g $*.glyphs
	@touch $@

%.ufo.built: %.ufo
	-fontmake -o ttf --keep-overlaps -u $<
	@touch $@
