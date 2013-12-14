ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

MAINPARTS= $(ROOT)/_doctype.html $(ROOT)/_menu.html $(ROOT)/_footer.html \
$(ROOT)/setup.t $(ROOT)/pic.t $(ROOT)/where.t $(ROOT)/mirrorlinks.t
NOW=$(shell date +'-D__TODAY__=%B %d, %Y')

ACTION=rm -f $@; \
       fcpp -WWW -Uunix -I$(ROOT) -H -C -P -V -LL "$(NOW)" $< $@

all: index.html
	cd web; make

index.html: _index.html $(MAINPARTS)
	$(ACTION)

full: all

