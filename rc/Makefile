ROOT=..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

PAGES=index.html

all: $(PAGES)

index.html: _index.html $(MAINPARTS) files.gen
	$(ACTION)

files.gen: mkindex.pl curl-*rc*
	./mkindex.pl >$@
	date -u "+%Y-%m-%d %H:%M %Z" > files-date.gen

clean:
	rm -f -- $(PAGES) *.gen
