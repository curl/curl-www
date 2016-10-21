ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html

PAGES=index.html thename.html licmix.html

all: $(PAGES)

index.html: _index.html $(MAINPARTS)
	$(ACTION)

thename.html: _thename.html ../docs/_menu.html $(MAINPARTS)
	$(ACTION)

licmix.html: _licmix.html ../docs/_menu.html $(MAINPARTS) licmix.gen
	$(ACTION)

licmix.gen: $(DOCROOT)/LICENSE-MIXING.md
	$(MARKDOWN) < $< >$@

clean:
	rm -f $(PAGES) *.gen
