ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

MAINPARTS= $(ROOT)/_doctype.html $(ROOT)/_menu.html $(ROOT)/_footer.html \
$(ROOT)/setup.t $(ROOT)/pic.t $(ROOT)/where.t $(ROOT)/mirrorlinks.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; \
cpp -I$(ROOT) -Idocs -WWW -Uunix -P -H -C -V -LL "$(NOW)" _$@ $@; chmod a-w+r $@

TXT2HTML= txt2html --extract --hrule 10
TXT2PLAIN = ./txt2plain.pl

all: index.html
	cd web; make

index.html: _index.html $(MAINPARTS)
	$(ACTION)

full: all

