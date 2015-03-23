ROOT = ..
CVSROOT= ../cvssource

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html
TXT2HTML= txt2html --extract --hrule 10

all: index.html mail.html competitors.html comparison-table.html	  \
     relatedlibs.html features.html wininet.html libwww.html libsoup.html \
     theysay.html bindings.html abi.html neon.html
	cd c; make
	cd ada95; make
	cd basic; make
	cd ch; make
	cd cocoa; make
	cd cplusplus; make
	cd d; make
	cd dotnet; make
	cd dylan; make
	cd eiffel; make
	cd euphoria; make
	cd falcon && make
	cd ferite; make
	cd foxpro; make
	cd gambas; make
	cd glib; make
	cd haskell; make
	cd hiper; make
	cd ilerpg; make
	cd java; make
	cd lisp; make
	cd lua; make
	cd mono; make
	cd nodejs; make
	cd ocaml; make
	cd pascal2; make
	cd pascal; make
	cd perl; make
	cd php; make
	cd postgres; make
	cd python; make
	cd q; make
	cd r; make
	cd rexx; make
	cd ruby; make
	cd scheme; make
	cd scilab; make
	cd slang; make
	cd smalltalk; make
	cd spf; make
	cd spl; make
	cd tcl; make
	cd using; make
	cd vb; make
	cd wx; make
	cd xblite; make

index.html: _index.html $(MAINPARTS) bindingbox.t
	$(ACTION)

threadsafe.html: _threadsafe.html $(MAINPARTS)
	$(ACTION)

abi.html: _abi.html abi.gen $(MAINPARTS)
	$(ACTION)

abi.gen: $(CVSROOT)/docs/libcurl/ABI
	$(MARKDOWN) < $< > $@

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

neon.html: _neon.html $(MAINPARTS)
	$(ACTION)

theysay.html: _theysay.html $(MAINPARTS)
	$(ACTION)

bindings.html: _bindings.html $(MAINPARTS) bindingbox.t
	$(ACTION)

