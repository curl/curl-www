ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
CURL= $(ROOT)

MAINPARTS= $(ROOT)/_doctype.html $(CURL)/_menu.html $(CURL)/_footer.html $(CURL)/setup.t $(CURL)/pic.t $(CURL)/where.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I. -WWW -Uunix -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

TXT2HTML= txt2html --extract --hrule 10

all: subscribe.html mail.html

subscribe.html: _subscribe.html $(MAINPARTS)
	$(ACTION)

mail.html: _mail.html $(MAINPARTS)
	$(ACTION)

full: all

