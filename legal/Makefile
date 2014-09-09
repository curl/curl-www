ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html

all: index.html thename.html licmix.html distro-dilemma.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

thename.html: _thename.html $(MAINPARTS)
	$(ACTION)

licmix.html: _licmix.html $(MAINPARTS) licmix.t
	$(ACTION)

distro-dilemma.html: _distro-dilemma.html $(MAINPARTS) distro.t
	$(ACTION)

licmix.t: $(DOCROOT)/LICENSE-MIXING
	$(TXT2PLAIN) < $< > $@

distro.t: $(DOCROOT)/DISTRO-DILEMMA
	./dilemma.pl < $< > $@

full: all

