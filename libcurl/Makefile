ROOT = ..
TXT2PLAIN= txt2plain.pl

MAINPARTS= $(ROOT)/_doctype.html _menu.html _links.html setup.t pic.t	 \
           $(ROOT)/where.t download.t $(ROOT)/mirrorlinks.t $(ROOT)/ad.t \
	   $(ROOT)/css.t $(ROOT)/sflogo.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; \
	rm -f $@; \
	cpp -I.. -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; \
	chmod a-w+r $@

all: index.html mail.html competitors.html threadsafe.html \
     fast.html ipv6.html comparison-table.html relatedlibs.html \
     features.html support.html
	cd c; make
	cd perl; make
	cd php; make
	cd ruby; make
	cd java; make
	cd tcl; make
	cd python; make
	cd dylan; make
	cd rexx; make
	cd cocoa; make
	cd scheme; make
	cd using; make
	cd cplusplus; make
	cd postgres; make
	cd pascal; make
	cd basic; make
	cd lua; make
	cd pascal2; make
	cd euphoria; make
	cd ocaml; make
	cd ada95; make
	cd ferite; make
	cd d; make
	cd q; make
	cd gambas; make
	cd wx; make

index.html: _index.html $(MAINPARTS)
	$(ACTION)

threadsafe.html: _threadsafe.html $(MAINPARTS)
	$(ACTION)

features.html: _features.html $(MAINPARTS)
	$(ACTION)

support.html: _support.html $(MAINPARTS)
	$(ACTION)

ipv6.html: _ipv6.html $(MAINPARTS)
	$(ACTION)

fast.html: _fast.html $(MAINPARTS)
	$(ACTION)

competitors.html: _competitors.html $(MAINPARTS)
	$(ACTION)

comparison-table.html: _comparison-table.html $(MAINPARTS)
	$(ACTION)

mail.html: _mail.html $(MAINPARTS)
	$(ACTION)

relatedlibs.html: _relatedlibs.html $(MAINPARTS)
	$(ACTION)

