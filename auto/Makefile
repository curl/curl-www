ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
CURL= $(ROOT)

MAINPARTS= $(ROOT)/_doctype.html $(CURL)/_menu.html $(CURL)/_footer.html \
  $(CURL)/setup.t $(CURL)/pic.t $(CURL)/where.t $(CURL)/css.t \
  $(ROOT)/mirrorlinks.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I. -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: foot.html head.html loghead.html howto.html

foot.html: _foot.html $(MAINPARTS)
	$(ACTION)

head.html: _head.html $(MAINPARTS)
	$(ACTION)

howto.html: _howto.html $(MAINPARTS) _head.html
	$(ACTION)

loghead.html: _loghead.html $(MAINPARTS)
	$(ACTION)

full: all
