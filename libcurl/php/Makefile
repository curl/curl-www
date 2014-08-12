ROOT = ../..

MAINPARTS= $(ROOT)/_doctype.html _menu.html ../_links.html $(ROOT)/setup.t	\
 ../pic.t $(ROOT)/where.t ../download.t $(ROOT)/mirrorlinks.t $(ROOT)/ad.t	\
 $(ROOT)/sflogo.t $(ROOT)/css.t
NOW=$(shell date +'-D__TODAY__=%B %d, %Y')o
ACTION=@echo preprocessing $@; rm -f $@; fcpp -I.. -I$(ROOT) -P -WWW -Uunix -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: index.html install.html apps.html examples.html iis.html hosting.html
	cd examples; make

index.html: _index.html $(MAINPARTS)
	$(ACTION)

install.html: _install.html $(MAINPARTS)
	$(ACTION)

apps.html: _apps.html $(MAINPARTS)
	$(ACTION)

iis.html: _iis.html $(MAINPARTS)
	$(ACTION)

hosting.html: _hosting.html $(MAINPARTS)
	$(ACTION)

examples.html: _examples.html $(MAINPARTS)
	$(ACTION)
