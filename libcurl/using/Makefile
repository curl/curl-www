ROOT = ../..

TXT2PLAIN= $(ROOT)/docs/txt2plain.pl
SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
CURL= $(ROOT)
MAN2HTML= roffit --bare

MAINPARTS= $(ROOT)/_doctype.html _menu.html ../_links.html ../setup.t \
  ../pic.t  $(ROOT)/where.t ../download.t $(ROOT)/ad.t $(ROOT)/css.t \
  $(ROOT)/mirrorlinks.t $(ROOT)/sflogo.t ../c/manpage.t

NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I$(ROOT) -I../c -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: index.html apps.html curl-config.html autoconf.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

apps.html: _apps.html $(MAINPARTS)
	$(ACTION)

autoconf.html: _autoconf.html $(MAINPARTS)
	$(ACTION)

curl-config.html: _curl-config.html $(MAINPARTS) curl-config.t
	$(ACTION)
curl-config.t: $(DOCROOT)/curl-config.1
	$(MAN2HTML) < $< >$@
