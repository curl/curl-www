ROOT=..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
TESTROOT=$(SRCROOT)/tests
LIBROOT=$(SRCROOT)/lib
CURL=$(ROOT)

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html
MKRELNOTES = ./mk-release-notes.pl
MAN2HTML = roffit --bare

PAGES = index.html \
 manual.html

all: $(PAGES)
	(cd wcurl-repo && git pull)

wcurl.1: wcurl-repo/wcurl.md
	$(SRCROOT)/scripts/cd2nroff $< > wcurl.1

wcurl.gen: wcurl.1
	 $(MAN2HTML) < $< > wcurl.gen

manual.html: _manual.html $(MAINPARTS) wcurl.gen
	$(ACTION)

index.html: _index.html $(MAINPARTS)
	$(ACTION)

clean:
	rm -f -- $(PAGES)
