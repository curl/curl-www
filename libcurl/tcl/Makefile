DAST = /home/dast/public_html

TXT2PLAIN= ../../docs/txt2plain.pl

MAINPARTS= $(DAST)/_doctype.html ../_menu.html ../_links.html ../setup.t ../pic.t $(DAST)/daniel.t ../../where.t ../download.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I../.. -I$(DAST) -WWW -Uunix -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

all: index.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)
