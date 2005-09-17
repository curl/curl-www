ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

MAINPARTS= $(ROOT)/_doctype.html _menu.html $(ROOT)/_footer.html \
$(ROOT)/setup.t $(ROOT)/pic.t $(ROOT)/where.t $(ROOT)/mirrorlinks.t	 \
$(ROOT)/sflogo.t $(ROOT)/css.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I$(ROOT) -Idocs -WWW -Uunix -H -C -P -V -LL "$(NOW)" _$@ $@; chmod a-w+r $@

TXT2PLAIN = txt2plain.pl

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

