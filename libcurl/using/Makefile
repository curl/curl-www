DAST = /home/dast/public_html

TXT2PLAIN= ../../docs/txt2plain.pl
SRCROOT=/home/dast/src/curl
DOCROOT=$(SRCROOT)/docs
CURL= /home/dast/curl_html

MAINPARTS= $(DAST)/_doctype.html _menu.html ../_links.html ../setup.t ../pic.t $(DAST)/daniel.t ../../where.t ../download.t ../../ad.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I../.. -I$(DAST) -WWW -Uunix -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: index.html apps.html curl-config.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

apps.html: _apps.html $(MAINPARTS)
	$(ACTION)

curl-config.html: _curl-config.html $(MAINPARTS) curl-config.t
	$(ACTION)
curl-config.t: $(DOCROOT)/curl-config.1
	gnroff -man $< | man2html >$@
