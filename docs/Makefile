SRCROOT=../cvssource
DOCROOT=$(SRCROOT)/docs

MAINPARTS= ../_doctype.html _menu.html ../_footer.html ../setup.t ../pic.t \
   docmenu.t ../where.t ../ad.t ../libcurl/_links.html ../mirrorlinks.t	   \
   ../css.t ../searchform.t ../sflogo.t Makefile
NOW=$(shell gnudate +'-D__TODAY__=%B %e, %Y')
ACTION=@echo preprocessing $@; rm -f $@; fcpp -I.. -Idocs -WWW -Uunix -H -C -V -P -LL "$(NOW)" $< $@;

TXT2HTML= txt2html --extract --hrule 10
TXT2PLAIN = txt2plain.pl
MAN2HTML = roffit --bare

PAGES = index.html manpage.html faq.html changes.html contribute.html	\
        internals.html sslcerts.html companies.html press.html		\
	features.html resources.html bugs.html				\
	install.html readme.html readme.curl.html			\
	resources.html copyright.html thanks.html			\
	y2k.html todo.html httpscripting.html	\
        comparison-table.html relatedtools.html osdistribs.html		\
	versions.html history.html loc.html knownbugs.html manual.html

all: $(PAGES)
	@echo done 

clean:
	rm -f $(PAGES)

index.html: _index.html $(MAINPARTS)
	$(ACTION)

index2.html: _index2.html $(MAINPARTS)
	$(ACTION)


manpage.html: _manpage.html $(MAINPARTS) mandump.t
	$(ACTION)

mandump.t: $(DOCROOT)/curl.1
	 $(MAN2HTML) < $(DOCROOT)/curl.1 > mandump.t


bugs.html: _bugs.html $(MAINPARTS) bugs.t
	$(ACTION)

bugs.t: $(DOCROOT)/BUGS
	$(TXT2HTML) < $(DOCROOT)/BUGS > bugs.t


history.html: _history.html $(MAINPARTS) history.t
	$(ACTION)

history.t: $(DOCROOT)/HISTORY
	$(TXT2HTML) < $(DOCROOT)/HISTORY > history.t

changes.html: _changes.shtml $(MAINPARTS) changes.t
	$(ACTION)

changes.t: $(SRCROOT)/CHANGES
	$(TXT2PLAIN) < $< > $@

contribute.html: _contribute.html $(MAINPARTS) contribute.t
	$(ACTION)

contribute.t: $(DOCROOT)/CONTRIBUTE
	$(TXT2HTML) < $(DOCROOT)/CONTRIBUTE > contribute.t

companies.html: _companies.html $(MAINPARTS)
	$(ACTION)

press.html: _press.html $(MAINPARTS)
	$(ACTION)

thanks.html: _thanks.html $(MAINPARTS) thanks.t
	$(ACTION)

thanks.t: $(DOCROOT)/THANKS
	$(TXT2PLAIN) < $< | sed -e 's/@/ at /g' -e 's/\([a-z]\)\.\([a-z]\)/\1 dot \2/g' -e 's/\&lt;/<span class=\"addy\">\&lt;/' -e 's/\&gt;/\&gt;<\/span>/' |awk '/^[A-Z]/ { printf("<br>%s", $$0) }' > $@

faq.html: _faq.shtml $(MAINPARTS) faq.t
	$(ACTION)

faq.t: $(DOCROOT)/FAQ
	$(TXT2PLAIN) < $< > $@

knownbugs.html: _knownbugs.html $(MAINPARTS) knownbugs.t
	$(ACTION)

knownbugs.t: $(DOCROOT)/KNOWN_BUGS
	$(TXT2PLAIN) < $< > $@

httpscript.t: $(DOCROOT)/TheArtOfHttpScripting
	$(TXT2PLAIN) < $< > $@

httpscripting.html: _httpscripting.shtml $(MAINPARTS) httpscript.t
	$(ACTION)

#faq.t: $(DOCROOT)/FAQ
#	$(TXT2HTML)  -H '^ *\d+\. \w+' -H '^ *\d+\.\d+\. \w+' < $(DOCROOT)/FAQ > faq.t


features.html: _features.html $(MAINPARTS) features.t
	$(ACTION)

features.t: $(DOCROOT)/FEATURES
	$(TXT2PLAIN) < $<  > $@

resources.html: _resources.html $(MAINPARTS) resources.t
	$(ACTION)

resources.t: $(DOCROOT)/RESOURCES
	$(TXT2HTML) < $(DOCROOT)/RESOURCES > resources.t


install.html: _install.html $(MAINPARTS) install.t
	$(ACTION)

install.t: $(DOCROOT)/INSTALL
	$(TXT2PLAIN) < $< > $@


readme.html: _readme.html $(MAINPARTS) readme.t
	$(ACTION)

readme.t: $(SRCROOT)/README
	$(TXT2HTML) < $(SRCROOT)/README > readme.t


readme.curl.html: _readme.curl.html $(MAINPARTS) manual.t
	$(ACTION)

manual.html: _manual.html $(MAINPARTS) manual.t
	$(ACTION)

manual.t: $(DOCROOT)/MANUAL
	$(TXT2HTML) < $< >$@

todo.html: _todo.html $(MAINPARTS) todo.t
	$(ACTION)

todo.t: $(DOCROOT)/TODO
	$(TXT2PLAIN) < $< > $@

versions.html: _versions.html $(MAINPARTS) versions.t
	$(ACTION)

versions.t: $(DOCROOT)/VERSIONS
	$(TXT2HTML) < $(DOCROOT)/VERSIONS > versions.t


internals.html: _internals.shtml $(MAINPARTS) internals.t
	$(ACTION)

internals.t: $(DOCROOT)/INTERNALS
	$(TXT2PLAIN) < $< > $@

sslcerts.html: _sslcerts.html $(MAINPARTS) sslcerts.t
	$(ACTION)

sslcerts.t: $(DOCROOT)/SSLCERTS
	$(TXT2PLAIN) < $< > $@

copyright.html: _copyright.html $(MAINPARTS) copying.t
	$(ACTION)
copying.t: $(SRCROOT)/COPYING
	$(TXT2PLAIN) < $< > $@

comparison-table.html: _comparison-table.html $(MAINPARTS)
	$(ACTION)

relatedtools.html: _relatedtools.html $(MAINPARTS)
	$(ACTION)

osdistribs.html: _osdistribs.html $(MAINPARTS)
	$(ACTION)

y2k.html: _y2k.html $(MAINPARTS)
	$(ACTION)

loc.html: loc.t $(MAINPARTS)
	$(ACTION)

#archive/index.html: mail
#	./fixit

full: all

