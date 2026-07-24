ROOT=..

SRCROOT=../cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk

MAINPARTS += \
 ../dev/_menu.html \
 Makefile

ACTION=@echo preprocessing $@; rm -f -- $@; fcpp -I../docs -I.. -WWW -Uunix -H -C -V -P -LL $< $@;

PAGES = index.html

all: $(PAGES)
	@echo done

clean:
	rm -f -- $(PAGES)

index.html: _index.html $(MAINPARTS) index.gen
	$(ACTION)

full: all

new:
	make index.t

index.gen: filedesc mkindex.pl
	./mkindex.pl > index.gen
