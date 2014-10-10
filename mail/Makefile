ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
CURL= $(ROOT)

MAINPARTS= $(ROOT)/_doctype.html $(CURL)/_menu.html $(CURL)/_footer.html \
 $(CURL)/setup.t $(CURL)/pic.t $(CURL)/where.t $(CURL)/mirrorlinks.t \
 $(ROOT)/ad.t $(ROOT)/sflogo.t

NOW=$(shell date +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; fcpp -I.. -I. -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@;

all: subscribe.html mail.html etiquette.html index.html indexheader.html \
 indexfooter.html mailheader.html mailfooter.html lost.html mailman.html \
 activity.html 

subscribe.html: _subscribe.html $(MAINPARTS)
	$(ACTION)

etiquette.html: _etiquette.html $(MAINPARTS) etiquette.gen
	$(ACTION)

etiquette.gen: $(DOCROOT)/MAIL-ETIQUETTE $(ROOT)/docs/faqparse.pl
	$(ROOT)/docs/faqparse.pl < $< > $@

activity.html: _activity.html $(MAINPARTS)
	$(ACTION)

mail.html: _mail.html $(MAINPARTS)
	$(ACTION)

indexheader.html: _indexheader.html $(MAINPARTS)
	$(ACTION)

indexfooter.html: _indexfooter.html $(MAINPARTS)
	$(ACTION)

mailheader.html: _mailheader.html $(MAINPARTS)
	$(ACTION)

mailfooter.html: _mailfooter.html $(MAINPARTS)
	$(ACTION)

index.html: _index.html _mail.html $(MAINPARTS)
	$(ACTION)

lost.html: _lost.html $(MAINPARTS)
	$(ACTION)

# This fils is meant for Mailman ONLY!
mailman.html: _mailman.html $(MAINPARTS)
	$(ACTION)

full: all

