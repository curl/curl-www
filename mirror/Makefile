ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

all: index.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

clean:
	rm index.html
