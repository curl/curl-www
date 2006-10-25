ROOT = ..
TXT2PLAIN= txt2plain.pl

MAINPARTS= $(ROOT)/_doctype.html _menu.html _links.html $(ROOT)/setup.t pic.t \
 $(ROOT)/where.t download.t $(ROOT)/mirrorlinks.t $(ROOT)/ad.t $(ROOT)/css.t  \
 $(ROOT)/sflogo.t $(ROOT)/_footer.html
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; \
	rm -f $@; \
	cpp -I.. -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; \
	chmod a-w+r $@

all: index.html mail.html competitors.html comparison-table.html	  \
     relatedlibs.html features.html wininet.html libwww.html libsoup.html \
     theysay.html bindings.html
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
	cd ch; make
	cd glib; make
	cd dotnet; make
	cd r; make
	cd mono; make
	cd vb; make
	cd lisp; make
	cd slang; make
	cd hiper; make
	cd xblite; make
	cd spl; make
	cd smalltalk; make

index.html: _index.html $(MAINPARTS) bindingbox.t
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

docs.html: _docs.html $(MAINPARTS)
	$(ACTION)

competitors.html: _competitors.html $(MAINPARTS)
	$(ACTION)

comparison-table.html: _comparison-table.html $(MAINPARTS)
	$(ACTION)

mail.html: _mail.html $(MAINPARTS)
	$(ACTION)

relatedlibs.html: _relatedlibs.html $(MAINPARTS)
	$(ACTION)

wininet.html: _wininet.html $(MAINPARTS)
	$(ACTION)

libwww.html: _libwww.html $(MAINPARTS)
	$(ACTION)

libsoup.html: _libsoup.html $(MAINPARTS)
	$(ACTION)

theysay.html: _theysay.html $(MAINPARTS)
	$(ACTION)

bindings.html: _bindings.html $(MAINPARTS) bindingbox.t
	$(ACTION)

