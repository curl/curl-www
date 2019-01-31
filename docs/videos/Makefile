ROOT=../..
SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += ../_menu.html $(ROOT)/alert.t

FCPP_OPTS = -DSHOW_ALERT
MAN2HTML = roffit --bare

PAGES = index.html

all: $(PAGES)

clean:
	rm -f $(PAGES) *.gen

index.html: _index.html $(MAINPARTS) videos.gen
	$(ACTION)

videos.gen: videolist.txt mkvideos.pl
	perl ./mkvideos.pl < $< > $@
