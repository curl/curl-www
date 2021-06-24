ROOT=..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
TESTROOT=$(SRCROOT)/tests
LIBROOT=$(SRCROOT)/lib
CURL=$(ROOT)

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += $(ROOT)/_menu.html
MAN2HTML = roffit --bare

PAGES = index.html

all: $(PAGES)

index.html: _index.html $(MAINPARTS)
	$(ACTION)

full: all

clean:
	rm -f $(PAGES)
