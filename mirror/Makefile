DAST = ../../public_html

SRCROOT=/home/dast/src/curl
DOCROOT=$(SRCROOT)/docs

MAINPARTS= $(DAST)/_doctype.html ../_menu.html ../_footer.html ../setup.t ../pic.t $(DAST)/daniel.t ../where.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I$(DAST) -Idocs -WWW -Uunix -H -C -V -LL "$(NOW)" _$@ $@; chmod a-w+r $@

TXT2HTML= txt2html --extract --hrule 10
TXT2PLAIN = ./txt2plain.pl

all: index.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

full: all

