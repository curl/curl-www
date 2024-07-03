ROOT=..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

PAGES=index.html

all: $(PAGES)

index.html: _index.html $(MAINPARTS) files.gen
	$(ACTION)

files.gen: mkfiles.pl dl/*
	./mkfiles.pl >$@

clean:
	rm -f $(PAGES) *.gen
