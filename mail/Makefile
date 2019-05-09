ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
CURL= $(ROOT)

MAINPARTS= $(ROOT)/_doctype.html $(CURL)/_menu.html $(CURL)/_footer.html \
 $(CURL)/setup.t $(CURL)/where.t $(ROOT)/css.t

NOW=$(shell date +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; fcpp -I.. -I. -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@;

PAGES = subscribe.html mail.html etiquette.html index.html indexheader.html \
 indexfooter.html mailheader.html mailfooter.html lost.html mailman.html

all: $(PAGES)

subscribe.html: _subscribe.html $(MAINPARTS)
	$(ACTION)

etiquette.html: _etiquette.html $(MAINPARTS) etiquette.gen
	$(ACTION)

etiquette.gen: $(DOCROOT)/MAIL-ETIQUETTE $(ROOT)/docs/faqparse.pl
	$(ROOT)/docs/faqparse.pl < $< > $@

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

# This fils is meant for Mailman ONLY!
mailman.html: _mailman.html $(MAINPARTS)
	$(ACTION)

clean:
	rm -f $(PAGES)
