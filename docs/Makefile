SRCROOT=../cvssource
DOCROOT=$(SRCROOT)/docs

MAINPARTS= ../_doctype.html _menu.html ../_footer.html ../setup.t ../pic.t docmenu.t ../where.t ../ad.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -Idocs -WWW -Uunix -H -C -V -P -LL "$(NOW)" _$@ $@; chmod a-w+r $@

TXT2HTML= txt2html --extract --hrule 10
TXT2PLAIN = txt2plain.pl
MAN2HTML = man2html | sed 's/^$$/\&nbsp;/g'

all: index.html manpage.html faq.shtml changes.shtml \
	contribute.html internals.shtml internals.t \
	features.html resources.html bugs.html \
	install.html readme.html readme.curl.html \
	resources.html copyright.html thanks.html \
	y2k.html todo.html httpscripting.shtml comparison-table.html \
	relatedtools.html osdistribs.html versions.html
	@echo done 
#archive/index.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

index2.html: _index2.html $(MAINPARTS)
	$(ACTION)


manpage.html: _manpage.html $(MAINPARTS) manual.t
	$(ACTION)

manual.t: $(DOCROOT)/curl.1
	gnroff -man $(DOCROOT)/curl.1 | $(MAN2HTML) >manual.t


bugs.html: _bugs.html $(MAINPARTS) bugs.t
	$(ACTION)

bugs.t: $(DOCROOT)/BUGS
	$(TXT2HTML) < $(DOCROOT)/BUGS > bugs.t


changes.shtml: _changes.shtml $(MAINPARTS) changes.t
	$(ACTION)

changes.t: $(SRCROOT)/CHANGES
	$(TXT2PLAIN) < $< > $@

contribute.html: _contribute.html $(MAINPARTS) contribute.t
	$(ACTION)

contribute.t: $(DOCROOT)/CONTRIBUTE
	$(TXT2HTML) < $(DOCROOT)/CONTRIBUTE > contribute.t

thanks.html: _thanks.html $(MAINPARTS) thanks.t
	$(ACTION)

thanks.t: $(DOCROOT)/THANKS
	$(TXT2PLAIN) < $< > $@


faq.shtml: _faq.shtml $(MAINPARTS) $(DOCROOT)/FAQ
	$(ACTION)

httpscript.t: $(DOCROOT)/TheArtOfHttpScripting
	$(TXT2PLAIN) < $< > $@

httpscripting.shtml: _httpscripting.shtml $(MAINPARTS) httpscript.t
	$(ACTION)

#faq.t: $(DOCROOT)/FAQ
#	$(TXT2HTML)  -H '^ *\d+\. \w+' -H '^ *\d+\.\d+\. \w+' < $(DOCROOT)/FAQ > faq.t


features.html: _features.html $(MAINPARTS) features.t
	$(ACTION)

features.t: $(DOCROOT)/FEATURES
	$(TXT2HTML) < $(DOCROOT)/FEATURES > features.t


resources.html: _resources.html $(MAINPARTS) resources.t
	$(ACTION)

resources.t: $(DOCROOT)/RESOURCES
	$(TXT2HTML) < $(DOCROOT)/RESOURCES > resources.t


install.html: _install.html $(MAINPARTS) install.t
	$(ACTION)

install.t: $(DOCROOT)/INSTALL
	$(TXT2HTML) < $(DOCROOT)/INSTALL > install.t


readme.html: _readme.html $(MAINPARTS) readme.t
	$(ACTION)

readme.t: $(SRCROOT)/README
	$(TXT2HTML) < $(SRCROOT)/README > readme.t


readme.curl.html: _readme.curl.html $(MAINPARTS) readme.curl.t
	$(ACTION)

readme.curl.t: $(DOCROOT)/MANUAL
	$(TXT2HTML) < $< >$@


#readme.libcurl.html: _readme.libcurl.html $(MAINPARTS) readme.libcurl.t
#	$(ACTION)

#readme.libcurl.t: $(DOCROOT)/LIBCURL
#	$(TXT2HTML) < $< >$@


todo.html: _todo.html $(MAINPARTS) todo.t
	$(ACTION)

todo.t: $(DOCROOT)/TODO
	$(TXT2HTML) < $(DOCROOT)/TODO > todo.t

versions.html: _versions.html $(MAINPARTS) versions.t
	$(ACTION)

versions.t: $(DOCROOT)/VERSIONS
	$(TXT2HTML) < $(DOCROOT)/VERSIONS > versions.t


internals.shtml: _internals.shtml $(MAINPARTS)
	$(ACTION)

internals.t: $(DOCROOT)/INTERNALS
	$(TXT2PLAIN) < $< > $@

copyright.html: _copyright.html $(MAINPARTS)
	$(ACTION)

comparison-table.html: _comparison-table.html $(MAINPARTS)
	$(ACTION)

relatedtools.html: _relatedtools.html $(MAINPARTS)
	$(ACTION)

osdistribs.html: _osdistribs.html $(MAINPARTS)
	$(ACTION)

y2k.html: _y2k.html $(MAINPARTS)
	$(ACTION)

#archive/index.html: mail
#	./fixit

full: all

