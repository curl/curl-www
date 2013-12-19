ROOT = ../../..

MAINPARTS= $(ROOT)/_doctype.html ../_menu.html $(ROOT)/setup.t	\
 $(ROOT)/where.t $(ROOT)/mirrorlinks.t $(ROOT)/ad.t $(ROOT)/sflogo.html
NOW=$(shell date +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; fcpp -I.. -I$(ROOT) -P -WWW -Uunix -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

PHPSRC = $(shell echo *.php)
PHPHTML = $(patsubst %.php,%.html,$(PHPSRC))
PHPDESC = $(patsubst %.php,%.php.html,$(PHPSRC))

all: index.html $(PHPHTML)

index.html: ./mkindex.pl $(MAINPARTS) $(PHPDESC)
	./mkindex.pl > $@

%.html: %.php ./mkindex.pl %.php.html $(PHPDESC) $(MAINPARTS) authors.txt
	./mkindex.pl $< > $@ 

clean:
	rm -f index.html $(PHPHTML)
