ROOT = ../..

MAINPARTS= $(ROOT)/_doctype.html ../_menu.html ../_links.html $(ROOT)/setup.t	\
 ../pic.t $(ROOT)/where.t $(ROOT)/mirrorlinks.t $(ROOT)/ad.t $(ROOT)/css.t	\
 $(ROOT)/sflogo.t

NOW=$(shell date +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; fcpp -I.. -I$(ROOT) -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: index.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)
