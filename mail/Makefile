ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
CURL= $(ROOT)

MAINPARTS= $(ROOT)/_doctype.html $(CURL)/_menu.html $(CURL)/_footer.html \
 $(CURL)/setup.t $(CURL)/pic.t $(CURL)/where.t $(CURL)/mirrorlinks.t \
 $(ROOT)/ad.t

NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I. -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

TXT2HTML= txt2html --extract --hrule 10

all: subscribe.html mail.html etiquette.html index.html

subscribe.html: _subscribe.html $(MAINPARTS)
	$(ACTION)

etiquette.html: _etiquette.html $(MAINPARTS)
	$(ACTION)

mail.html: _mail.html $(MAINPARTS)
	$(ACTION)

index.html: _index.html _mail.html $(MAINPARTS)
	$(ACTION)

full: all

