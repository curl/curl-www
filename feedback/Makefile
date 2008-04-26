MAINPARTS= ../_doctype.html ../_footer.html ../setup.t ../pic.t \
   ../where.t ../ad.t ../libcurl/_links.html ../mirrorlinks.t		   \
   ../css.t ../sflogo.html Makefile
NOW=$(shell gnudate +'-D__TODAY__=%B %e, %Y')
FCPPOPTS=-I.. -Idocs -WWW -Uunix -H -C -V -P -LL "$(NOW)"
ACTION=@echo preprocessing $@; rm -f $@; fcpp $(FCPPOPTS) $< $@;

PAGES = index.html

all: $(PAGES)
	@echo done 

clean:
	rm -f $(PAGES)

index.html: _index.html $(MAINPARTS)
	$(ACTION)
