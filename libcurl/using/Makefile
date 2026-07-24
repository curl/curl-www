ROOT=../..

include $(ROOT)/mainparts.mk

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
CURL=$(ROOT)
MAN2HTML= roffit --bare

MAINPARTS += \
 _menu.html \
 ../download.t

ACTION=@echo preprocessing $@; rm -f -- $@; fcpp -I.. -I$(ROOT) -I../c -WWW -Uunix -P -H -C -V -LL $< $@;

GEN=index.html apps.html curl-config.html autoconf.html

all: $(GEN)

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

clean:
	rm $(GEN)
