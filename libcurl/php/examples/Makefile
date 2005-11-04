ROOT = ../../..

TXT2PLAIN= $(ROOT)/docs/txt2plain.pl

MAINPARTS= $(ROOT)/_doctype.html ../_menu.html $(ROOT)/setup.t	\
 $(ROOT)/where.t $(ROOT)/mirrorlinks.t $(ROOT)/ad.t $(ROOT)/sflogo.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I$(ROOT) -P -WWW -Uunix -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

PHPSRC = $(shell echo *.php)
PHPHTML = $(patsubst %.php,%.html,$(PHPSRC))

all: index.html $(PHPHTML)

index.html: ./mkindex.pl $(MAINPARTS)
	./mkindex.pl > $@


%.html: %.php ./mkindex.pl
	echo $@ $<
	./mkindex.pl $< > $@ 

php:
	(for i in $(PHPSRC); do \
	  echo $$i; \
	done)

html:
	echo $(PHPHTML)
