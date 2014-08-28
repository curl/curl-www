ROOT = ../..

MAINPARTS= $(ROOT)/_doctype.html ../_menu.html $(ROOT)/where.t ../download.t	\
 $(ROOT)/setup.t $(ROOT)/ad.t

NOW=$(shell date +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; fcpp -I.. -I$(ROOT) -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: index.html easy.pm.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

easy.pm.html: _easy.pm.html $(MAINPARTS)
	$(ACTION)
