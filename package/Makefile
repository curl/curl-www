TXT2PLAIN= txt2plain.pl

MAINPARTS= ../_doctype.html ../_menu.html ../setup.t ../pic.t ../where.t ../ad.t ../mirrorlinks.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I..  -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: index.html
	cd cygwin; make

index.html: _index.html $(MAINPARTS)
	$(ACTION)
