SRCROOT=../cvssource
DOCROOT=$(SRCROOT)/docs
TESTROOT=$(SRCROOT)/tests

MAINPARTS= ../_doctype.html _menu.html ../_footer.html ../setup.t ../pic.t \
   ../where.t ../ad.t ../libcurl/_links.html ../mirrorlinks.t		   \
   ../css.t ../sflogo.t Makefile
NOW=$(shell gnudate +'-D__TODAY__=%B %e, %Y')
FCPPOPTS=-I.. -Idocs -WWW -Uunix -H -C -V -P -LL "$(NOW)"
ACTION=@echo preprocessing $@; rm -f $@; fcpp $(FCPPOPTS) $< $@;

TXT2HTML= txt2html --extract --hrule 10
TXT2PLAIN = txt2plain.pl
MAN2HTML = roffit --bare

PAGES = index.html manpage.html faq.html changes.html contribute.html	 \
 internals.html sslcerts.html companies.html press.html features.html	 \
 bugs.html install.html readme.html readme.curl.html copyright.html	 \
 thanks.html y2k.html todo.html httpscripting.html comparison-table.html \
 relatedtools.html osdistribs.html versions.html history.html loc.html	 \
 knownbugs.html manual.html caextract.html programs.html security.html	 \
 testcurl.html runtests.html libs.html adv_20051013.html adv_20051207.html \
 adv_20060320.html vulnerabilities.html

all: $(PAGES)
	@echo done 

clean:
	rm -f $(PAGES)

index.html: _index.html $(MAINPARTS)
	$(ACTION)

index2.html: _index2.html $(MAINPARTS)
	$(ACTION)


libs.html: _libs.html $(MAINPARTS)
	$(ACTION)

manpage.html: _manpage.html $(MAINPARTS) mandump.t
	$(ACTION)

mandump.t: $(DOCROOT)/curl.1
	 $(MAN2HTML) < $(DOCROOT)/curl.1 > mandump.t

testcurl.html: _testcurl.html $(MAINPARTS) testcurl.dump
	$(ACTION)
testcurl.dump: $(TESTROOT)/testcurl.1
	 $(MAN2HTML) < $< > $@

runtests.html: _runtests.html $(MAINPARTS) runtests.dump
	$(ACTION)
runtests.dump: $(TESTROOT)/runtests.1
	 $(MAN2HTML) < $< > $@


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

thanks.html: _thanks.html $(MAINPARTS) thanks.t thanks2.t
	actual=`wc -l thanks.t | awk '{print $$1}'` && fcpp $(FCPPOPTS) -D__NUM__=$$actual $< $@

thanks.t: $(DOCROOT)/THANKS
	grep "^[A-Za-z]" $(DOCROOT)/THANKS | awk '{ print $$0 ", ";}' > $@

thanks2.t: $(DOCROOT)/THANKS thanks.pl
	grep "^[A-Za-z]" $(DOCROOT)/THANKS | ./thanks.pl > $@

faq.html: _faq.shtml $(MAINPARTS) faq.t
	$(ACTION)

faq.t: $(DOCROOT)/FAQ faqparse.pl
	./faqparse.pl < $< > $@

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
	$(TXT2PLAIN) < $< >$@

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

comparison-table.html: _comparison-table.html $(MAINPARTS)  ../release.t
	$(ACTION)

relatedtools.html: _relatedtools.html $(MAINPARTS)
	$(ACTION)

osdistribs.html: _osdistribs.html $(MAINPARTS)
	$(ACTION)

y2k.html: _y2k.html $(MAINPARTS)
	$(ACTION)

loc.html: loc.t $(MAINPARTS)
	$(ACTION)

caextract.html: _caextract.html $(MAINPARTS)
	$(ACTION)

programs.html: _programs.html $(MAINPARTS)
	$(ACTION)

security.html: _security.html $(MAINPARTS)
	$(ACTION)

adv_20051013.html: _adv_20051013.html adv_20051013.t $(MAINPARTS)
	$(ACTION)

adv_20051013.t: adv_20051013.txt
	$(TXT2PLAIN) < $< > $@

adv_20051207.html: _adv_20051207.html adv_20051207.t $(MAINPARTS)
	$(ACTION)

adv_20051207.t: adv_20051207.txt
	$(TXT2PLAIN) < $< > $@

adv_20060320.html: _adv_20060320.html adv_20060320.t $(MAINPARTS)
	$(ACTION)

adv_20060320.t: adv_20060320.txt
	$(TXT2PLAIN) < $< > $@

vulnerabilities.html: _vulnerabilities.html vuln.txt $(MAINPARTS)
	$(ACTION)

vuln.txt: ../_changes.html ./vulntable.pl
	./vulntable.pl < $< > $@


#archive/index.html: mail
#	./fixit

full: all

