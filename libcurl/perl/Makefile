ROOT = ../..

TXT2PLAIN= $(ROOT)/docs/txt2plain.pl

MAINPARTS= $(ROOT)/_doctype.html ../_menu.html ../_links.html	\
 $(ROOT)/where.t ../download.t $(ROOT)/setup.t $(ROOT)/ad.t

NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I$(ROOT) -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: index.html easy.pm.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

easy.pm.html: _easy.pm.html $(MAINPARTS)
	$(ACTION)
