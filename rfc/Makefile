SRCROOT=../cvssource
DOCROOT=$(SRCROOT)/docs

MAINPARTS= ../_doctype.html ../_menu.html ../_footer.html ../setup.t ../pic.t \
   ../where.t ../ad.t ../libcurl/_links.html ../mirrorlinks.t		      \
   ../css.t ../sflogo.t Makefile
NOW=$(shell gnudate +'-D__TODAY__=%B %e, %Y')
ACTION=@echo preprocessing $@; rm -f $@; fcpp -I../docs -I.. -WWW -Uunix -H -C -V -P -LL "$(NOW)" $< $@;

TXT2HTML= txt2html --extract --hrule 10
TXT2PLAIN = txt2plain.pl
MAN2HTML = roffit --bare

PAGES = index.html 

all: $(PAGES)
	@echo done 

clean:
	rm -f $(PAGES)

index.html: _index.html $(MAINPARTS) index.t
	$(ACTION)


full: all

new:
	make index.t

index.t: filedesc mkindex.pl
	./mkindex.pl > index.t
