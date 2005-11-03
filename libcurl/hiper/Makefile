ROOT = ../..

TXT2PLAIN= $(ROOT)/docs/txt2plain.pl

MAINPARTS= $(ROOT)/_doctype.html _menu.html ../_links.html $(ROOT)/setup.t \
../pic.t $(ROOT)/where.t ../download.t $(ROOT)/mirrorlinks.t $(ROOT)/ad.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I$(ROOT) -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: index.html schedule.html roadmap.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

schedule.html: _schedule.html $(MAINPARTS)
	$(ACTION)

roadmap.html: _roadmap.html $(MAINPARTS)
	$(ACTION)
