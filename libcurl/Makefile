TXT2PLAIN= txt2plain.pl

MAINPARTS= ../_doctype.html _menu.html _links.html setup.t pic.t ../where.t download.t ../ad.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I..  -WWW -Uunix -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: index.html mail.html competitors.html future.html
	cd c; make
	cd perl; make
	cd php; make
	cd ruby; make
	cd java; make
	cd tcl; make
	cd python; make
	cd dylan; make
	cd rexx; make
	cd cocoa; make
	cd scheme; make
	cd using; make
	cd cplusplus; make
	cd postgres; make

index.html: _index.html $(MAINPARTS)
	$(ACTION)

competitors.html: _competitors.html $(MAINPARTS)
	$(ACTION)

future.html: _future.html $(MAINPARTS)
	$(ACTION)

mail.html: _mail.html $(MAINPARTS)
	$(ACTION)
