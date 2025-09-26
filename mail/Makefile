ROOT=..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
CURL=$(ROOT)

include $(ROOT)/setup.mk

MAINPARTS= \
 $(ROOT)/_doctype.html \
 $(CURL)/_menu.html \
 $(CURL)/_footer.html \
 $(CURL)/setup.t \
 $(CURL)/where.t \
 $(ROOT)/css.t

ACTION=@echo preprocessing $@; rm -f $@; fcpp -I.. -I. -WWW -Uunix -P -H -C -V -LL $< $@;

PAGES = \
 subscribe.html \
 mail.html \
 etiquette.html \
 index.html \
 indexheader.html \
 indexfooter.html \
 mailheader.html \
 mailfooter.html \
 lost.html \
 mailman.html

all: $(PAGES)

subscribe.html: _subscribe.html $(MAINPARTS)
	$(ACTION)

etiquette.html: _etiquette.html $(MAINPARTS) etiquette.gen
	$(ACTION)

etiquette.gen: $(DOCROOT)/MAIL-ETIQUETTE.md $(ROOT)/docs/faqparse.pl
	$(MARKDOWN) < $< > $@

mail.html: _mail.html $(MAINPARTS)
	$(ACTION)

indexheader.html: _indexheader.html $(MAINPARTS) support.t
	$(ACTION)

indexfooter.html: _indexfooter.html $(MAINPARTS)
	$(ACTION)

mailheader.html: _mailheader.html $(MAINPARTS) support.t
	$(ACTION)

mailfooter.html: _mailfooter.html $(MAINPARTS)
	$(ACTION)

index.html: _index.html _mail.html $(MAINPARTS) support.t
	$(ACTION)

lost.html: _lost.html $(MAINPARTS)
	$(ACTION)

# This file is meant for Mailman ONLY!
mailman.html: _mailman.html $(MAINPARTS)
	$(ACTION)

clean:
	rm -f $(PAGES)
