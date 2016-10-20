ROOT = ../..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
CURL= $(ROOT)
MAN2HTML= roffit --bare

MAINPARTS= $(ROOT)/_doctype.html _menu.html $(ROOT)/setup.t \
  ../pic.t  $(ROOT)/where.t ../download.t $(ROOT)/css.t

NOW=$(shell date +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; fcpp -I.. -I$(ROOT) -I../c -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@;

all: index.html apps.html curl-config.html autoconf.html icons.html

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

icons.html: _icons.html $(MAINPARTS)
	$(ACTION)

clean:
	rm index.html apps.html curl-config.html autoconf.html icons.html
