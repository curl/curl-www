ROOT = ../..

TXT2PLAIN= $(ROOT)/docs/txt2plain.pl

MAINPARTS= $(ROOT)/_doctype.html _menu.html ../_links.html ../setup.t ../pic.t $(ROOT)/where.t ../download.t $(ROOT)/mirrorlinks.t $(ROOT)/ad.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I$(ROOT) -P -WWW -Uunix -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: index.html install.html apps.html examples.html iis.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

install.html: _install.html $(MAINPARTS)
	$(ACTION)

apps.html: _apps.html $(MAINPARTS)
	$(ACTION)

iis.html: _iis.html $(MAINPARTS)
	$(ACTION)

examples.html: _examples.html $(MAINPARTS)
	$(ACTION)
