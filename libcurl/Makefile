ROOT = ..
SRCROOT= ../cvssource
DOCROOT=$(SRCROOT)/docs
MANROOT=$(DOCROOT)/libcurl
OPTMAN=$(DOCROOT)/libcurl/opts

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html ../alert.t
FCPP_OPTS = -DSHOW_ALERT

PAGES= index.html mail.html competitors.html comparison-table.html	  \
     relatedlibs.html features.html wininet.html libwww.html libsoup.html \
     theysay.html bindings.html abi.html neon.html security.html

MAN2HTMLBASIC = roffit --bare --mandir=$(MANROOT) --mandir=$(OPTMAN) --mandir=$(DOCROOT) --hrefdir=c
# postprocess the roffit HTML to add links to curl error codes
MAN2HTML= ( $(MAN2HTMLBASIC) | perl -0x20 -pe '/(CURL(E|M|SHE)_\w*)/; $$err=$$erra=$$1; $$erra =~ s/_//g; s@CURL(E|M|SHE)_\w*@<a href="libcurl-errors.html\#$$erra">$$err</a>@;' )

all: $(PAGES)
	cd c; make

index.html: _index.html $(MAINPARTS)
	$(ACTION)

abi.html: _abi.html abi.gen $(MAINPARTS)
	$(ACTION)

abi.gen: $(SRCROOT)/docs/libcurl/ABI
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

bindings.html: _bindings.html $(MAINPARTS) bindings.gen
	$(ACTION)
bindings.gen: $(SRCROOT)/docs/BINDINGS.md
	$(MARKDOWN) < $< > $@

security.html: _security.html $(MAINPARTS) security.gen
	$(ACTION)
security.gen: $(SRCROOT)/docs/libcurl/libcurl-security.3
	$(MAN2HTMLBASIC) < $< > $@

clean:
	rm -f $(PAGES) *.gen
	cd c && make clean
