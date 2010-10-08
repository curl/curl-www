ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
CURL= $(ROOT)

MAINPARTS= $(ROOT)/_doctype.html $(CURL)/_menu.html $(CURL)/_footer.html \
  $(CURL)/setup.t $(CURL)/pic.t $(CURL)/where.t $(CURL)/css.t \
  $(ROOT)/mirrorlinks.t topline.t $(ROOT)/ad.t _menu.html
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=echo preprocessing $@; \
 rm -f $@; \
 fcpp -I.. -I. -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@;
TXT2PLAIN = txt2plain.pl

PAGES = foot.html head.html loghead.html howto.html summary.html \
	cvshistory.html table0.html table1.html table2.html table3.html \
	missing.html keywords.html builds.html todo-release.html \
	release-notes.html index.html

all: $(PAGES)

index.html: _index.html $(MAINPARTS)
	$(ACTION)

builds.html:
	ln -s table0.html builds.html

foot.html: _foot.html $(MAINPARTS)
	$(ACTION)

head.html: _head.html $(MAINPARTS)
	$(ACTION)

summary.html: _summary.html $(MAINPARTS) summary.t
	$(ACTION)

cvshistory.html: _cvshistory.html $(MAINPARTS) cvs.t
	$(ACTION)

missing.html: _missing.html $(MAINPARTS)
	$(ACTION)

release-notes.txt: $(SRCROOT)/RELEASE-NOTES
	$(TXT2PLAIN) < $< > $@

release-notes.html: _release-notes.html release-notes.txt $(MAINPARTS)
	$(ACTION)

todo-release.txt: $(SRCROOT)/TODO-RELEASE
	$(TXT2PLAIN) < $< > $@

todo-release.html: _todo-release.html todo-release.txt $(MAINPARTS)
	$(ACTION)

howto.html: _howto.html $(MAINPARTS) _head.html
	$(ACTION)

keywords.html: _keywords.html $(MAINPARTS) _head.html keywords.t
	$(ACTION)

loghead.html: _loghead.html $(MAINPARTS)
	$(ACTION)

table0.html: _table0.html $(MAINPARTS) table0.t explainopts.t
	$(ACTION)

table1.html: _table1.html $(MAINPARTS) table1.t explainopts.t
	$(ACTION)
table2.html: _table2.html $(MAINPARTS) table2.t explainopts.t
	$(ACTION)
table3.html: _table3.html $(MAINPARTS) table3.t explainopts.t
	$(ACTION)


full: all

clean:
	rm -f $(PAGES)
