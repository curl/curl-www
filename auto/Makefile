ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
CURL= $(ROOT)

MAINPARTS= $(ROOT)/_doctype.html $(CURL)/_menu.html $(CURL)/_footer.html \
  $(CURL)/setup.t $(CURL)/pic.t $(CURL)/where.t $(CURL)/css.t \
  $(ROOT)/mirrorlinks.t topline.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; fcpp -I.. -I. -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@;

all: foot.html head.html loghead.html howto.html summary.html index.html \
	cvshistory.html table0.html table1.html table2.html table3.html

foot.html: _foot.html $(MAINPARTS)
	$(ACTION)

head.html: _head.html $(MAINPARTS)
	$(ACTION)

summary.html: _summary.html $(MAINPARTS) summary.t
	$(ACTION)

cvshistory.html: _cvshistory.html $(MAINPARTS) cvs.t
	$(ACTION)

index.html: _index.html $(MAINPARTS) table.t
	$(ACTION)

howto.html: _howto.html $(MAINPARTS) _head.html
	$(ACTION)

loghead.html: _loghead.html $(MAINPARTS)
	$(ACTION)

table0.html: _table0.html $(MAINPARTS) table0.t
	$(ACTION)

table1.html: _table1.html $(MAINPARTS) table1.t
	$(ACTION)
table2.html: _table2.html $(MAINPARTS) table2.t
	$(ACTION)
table3.html: _table3.html $(MAINPARTS) table3.t
	$(ACTION)


full: all
