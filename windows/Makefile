ROOT=..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

PAGES=index.html microsoft.html try.html

all: $(PAGES)

try.html: _try.html $(MAINPARTS) files.gen
	$(ACTION)

index.html: _index.html $(MAINPARTS) files.gen
	$(ACTION)

microsoft.html: _microsoft.html $(MAINPARTS)
	$(ACTION)

files.gen: mkfiles.pl latest.txt
	./mkfiles.pl >$@

latest.txt:
	./unpack.pl

clean:
	rm -f $(PAGES) *.gen
