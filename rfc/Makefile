SRCROOT=../cvssource
DOCROOT=$(SRCROOT)/docs

MAINPARTS= ../_doctype.html ../dev/_menu.html ../_footer.html ../setup.t \
   ../where.t ../css.t Makefile
NOW=$(shell date +'-D__TODAY__=%B %e, %Y')
ACTION=@echo preprocessing $@; rm -f $@; fcpp -I../docs -I.. -WWW -Uunix -H -C -V -P -LL "$(NOW)" $< $@;

PAGES = index.html 

all: $(PAGES)
	@echo done 

clean:
	rm -f $(PAGES)

index.html: _index.html $(MAINPARTS) index.gen
	$(ACTION)

full: all

new:
	make index.t

index.gen: filedesc mkindex.pl
	./mkindex.pl > index.gen
