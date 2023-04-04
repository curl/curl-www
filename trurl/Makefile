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
	(cd trurl-www && git pull)

trurl.gen: trurl-www/trurl.1
	 $(MAN2HTML) < $< > trurl.gen

manual.html: _manual.html $(MAINPARTS) trurl.gen
	$(ACTION)

index.html: _index.html $(MAINPARTS)
	$(ACTION)

clean:
	rm -f $(PAGES)
