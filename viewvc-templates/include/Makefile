ROOT = ../..

MAINPARTS= $(ROOT)/_doctype.html $(ROOT)/setup.t \
 $(ROOT)/where.t $(ROOT)/mirrorlinks.t $(ROOT)/ad.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION= cpp -I.. -I$(ROOT) -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@

all: header.ezt footer.ezt

header.ezt: header.t $(MAINPARTS)
	$(ACTION)

footer.ezt: footer.t $(MAINPARTS)
	$(ACTION)
