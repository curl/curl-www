ROOT = ../..

TXT2PLAIN= $(ROOT)/docs/txt2plain.pl

MAINPARTS= $(ROOT)/_doctype.html $(ROOT)/_menu.html $(ROOT)/setup.t $(ROOT)/where.t $(ROOT)/ad.t $(ROOT)/mirrorlinks.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; \
     rm -f $@; \
     cpp -I.. -I$(ROOT) -P -WWW -Uunix -H -C -V -LL "$(NOW)" $< $@; \
     chmod a-w+r $@

all: index.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)
