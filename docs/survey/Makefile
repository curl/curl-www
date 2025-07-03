ROOT=../..
SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
INTERNALS=$(DOCROOT)/internals

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += ../_menu.html ../../alert.t

FCPP_OPTS = -DSHOW_ALERT
MAN2HTML = roffit --bare

PAGES = \
 index.html \
 2014.html

all: $(PAGES)

clean:
	rm -f $(PAGES)

index.html: _index.html $(MAINPARTS)
	$(ACTION)

2014.html: _2014.html $(MAINPARTS)
	$(ACTION)
