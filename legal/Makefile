ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs

MAINPARTS= $(ROOT)/_doctype.html ../_menu.html ../_footer.html ../setup.t ../pic.t ../where.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I$(ROOT) -Idocs -WWW -Uunix -H -C -V -LL "$(NOW)" _$@ $@; chmod a-w+r $@

TXT2HTML= txt2html --extract --hrule 10
TXT2PLAIN = ./txt2plain.pl

all: index.html thename.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

thename.html: _thename.html $(MAINPARTS)
	$(ACTION)

full: all

