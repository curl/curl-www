ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html

all: index.html thename.html licmix.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

thename.html: _thename.html ../docs/_menu.html $(MAINPARTS)
	$(ACTION)

licmix.html: _licmix.html ../docs/_menu.html $(MAINPARTS) licmix.gen
	$(ACTION)

licmix.gen: $(DOCROOT)/LICENSE-MIXING.md
	$(MARKDOWN) < $< >$@

full: all

