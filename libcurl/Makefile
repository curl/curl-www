TXT2PLAIN= txt2plain.pl

MAINPARTS= ..//_doctype.html _menu.html _links.html setup.t pic.t ../where.t download.t ../ad.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I../.. -I$(DAST) -WWW -Uunix -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: index.html example.shtml mail.html competitors.html
	cd c; make
	cd perl; make
	cd php; make
	cd ruby; make
	cd java; make
	cd tcl; make
	cd python; make
	cd dylan; make
	cd rexx; make
	cd using; make

index.html: _index.html $(MAINPARTS)
	$(ACTION)

competitors.html: _competitors.html $(MAINPARTS)
	$(ACTION)

mail.html: _mail.html $(MAINPARTS)
	$(ACTION)

example.shtml: _example.html $(MAINPARTS) tinytest.html tinytest2.html curlgtk.html
	$(ACTION)

tinytest.html: tinytest.c
	$(TXT2PLAIN) < $< > $@

tinytest2.html: tinytest2.c
	$(TXT2PLAIN) < $< > $@

curlgtk.html: curlgtk.c
	$(TXT2PLAIN) < $< > $@
