DAST = /home/dast/public_html

SRCROOT=/home/dast/src/curl
DOCROOT=$(SRCROOT)/docs
CURL= /home/dast/curl_html

MAINPARTS= $(DAST)/_doctype.html $(CURL)/_menu.html $(CURL)/_footer.html $(CURL)/setup.t $(CURL)/pic.t $(DAST)/daniel.t $(CURL)/where.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I../.. -I. -I$(DAST) -WWW -Uunix -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

TXT2HTML= txt2html --extract --hrule 10

all: subscribe.html mail.html

subscribe.html: _subscribe.html $(MAINPARTS)
	$(ACTION)

mail.html: _mail.html $(MAINPARTS)
	$(ACTION)

full: all

