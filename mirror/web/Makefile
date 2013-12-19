ROOT = ../..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

MAINPARTS= $(ROOT)/_doctype.html $(ROOT)/_menu.html $(ROOT)/_footer.html $(ROOT)/setup.t $(ROOT)/pic.t $(ROOT)/where.t
NOW=$(shell date +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; fcpp -I$(ROOT) -Idocs -WWW -Uunix -H -C -V -LL "$(NOW)" _$@ $@; chmod a-w+r $@

all: index.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

full: all

