SRCROOT=../cvssource
DOCROOT=$(SRCROOT)/docs

MAINPARTS= ../_doctype.html _menu.html ../_footer.html ../setup.t ../pic.t \
   ../where.t ../ad.t ../libcurl/_links.html ../mirrorlinks.t		   \
   ../css.t ../sflogo.html
NOW=$(shell gnudate +'-D__TODAY__=%B %e, %Y')
FCPPOPTS=-I.. -Idocs -WWW -Uunix -H -C -V -P -LL "$(NOW)"
ACTION=fcpp $(FCPPOPTS) $< $@;

TXT2HTML= txt2html --extract --hrule 10
TXT2PLAIN = txt2plain.pl
MAN2HTML = roffit --bare

PAGES = index.html manpage.html faq.html changes.html \
 sslcerts.html companies.html press.html features.html	 \
 bugs.html install.html readme.html readme.curl.html copyright.html	 \
 thanks.html y2k.html todo.html httpscripting.html comparison-table.html \
 relatedtools.html osdistribs.html versions.html history.html loc.html	 \
 knownbugs.html manual.html caextract.html programs.html security.html	 \
 libs.html http-cookies.html \
 adv_20051013.html adv_20051207.html \
 adv_20060320.html vulnerabilities.html adv_20070710.html \
 gsoc2008.html releases.html adv_20090303.html releases.csv adv_20090812.html \
 adv_20100209.html adv_20101013.html adv_20110623.html ssl-compared.html \
 adv_20120124.html adv_20120124B.html mk-ca-bundle.html adv_20130206.html 

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

gsoc2008.html: _gsoc2008.html $(MAINPARTS)
	$(ACTION)

manpage.html: _manpage.html $(MAINPARTS) mandump.t
	$(ACTION)

mandump.t: $(DOCROOT)/curl.1
	 $(MAN2HTML) < $(DOCROOT)/curl.1 > mandump.t

mk-ca-bundle.html: _mk-ca-bundle.html $(MAINPARTS) mkdump.t
	$(ACTION)

mkdump.t: $(DOCROOT)/mk-ca-bundle.1
	 $(MAN2HTML) < $(DOCROOT)/mk-ca-bundle.1 > mkdump.t

bugs.html: _bugs.html $(MAINPARTS) bugs.t
	$(ACTION)

bugs.t: $(DOCROOT)/BUGS faqparse.pl
	./faqparse.pl < $< > $@

history.html: _history.html $(MAINPARTS) history.t
	$(ACTION)

history.t: $(DOCROOT)/HISTORY
	$(TXT2HTML) < $(DOCROOT)/HISTORY > history.t

changes.html: _changes.shtml $(MAINPARTS) changes.t
	$(ACTION)

changes.t: $(SRCROOT)/CHANGES
	$(TXT2PLAIN) < $< > $@

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

http-cookies.html: _http-cookies.html $(MAINPARTS) http-cookies.t
	$(ACTION)

http-cookies.t: $(DOCROOT)/HTTP-COOKIES faqparse.pl
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

todo.t: $(DOCROOT)/TODO faqparse.pl
	./faqparse.pl < $< | sed -e 's:*:\&#47;:g' -e 's:#:\&#35;:g'> $@

versions.html: _versions.html $(MAINPARTS) versions.t
	$(ACTION)

versions.t: $(DOCROOT)/VERSIONS
	$(TXT2HTML) < $(DOCROOT)/VERSIONS > versions.t

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

ssl-compared.html: _ssl-compared.html $(MAINPARTS)
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

adv_20070710.html: _adv_20070710.html adv_20070710.t $(MAINPARTS)
	$(ACTION)

adv_20070710.t: adv_20070710.txt
	$(TXT2PLAIN) < $< > $@

adv_20090303.html: _adv_20090303.html adv_20090303.t $(MAINPARTS)
	$(ACTION)

adv_20090303.t: adv_20090303.txt
	$(TXT2PLAIN) < $< > $@

adv_20090812.html: _adv_20090812.html adv_20090812.t $(MAINPARTS)
	$(ACTION)

adv_20090812.t: adv_20090812.txt
	$(TXT2PLAIN) < $< > $@

adv_20100209.html: _adv_20100209.html adv_20100209.t $(MAINPARTS)
	$(ACTION)

adv_20100209.t: adv_20100209.txt
	$(TXT2PLAIN) < $< > $@

adv_20101013.html: _adv_20101013.html adv_20101013.t $(MAINPARTS)
	$(ACTION)

adv_20101013.t: adv_20101013.txt
	$(TXT2PLAIN) < $< > $@

adv_20110623.html: _adv_20110623.html adv_20110623.t $(MAINPARTS)
	$(ACTION)

adv_20110623.t: adv_20110623.txt
	$(TXT2PLAIN) < $< > $@

adv_20120124.html: _adv_20120124.html adv_20120124.t $(MAINPARTS)
	$(ACTION)

adv_20120124.t: adv_20120124.txt
	$(TXT2PLAIN) < $< > $@

adv_20120124B.html: _adv_20120124B.html adv_20120124B.t $(MAINPARTS)
	$(ACTION)

adv_20120124B.t: adv_20120124B.txt
	$(TXT2PLAIN) < $< > $@

adv_20130206.html: _adv_20130206.html adv_20130206.t $(MAINPARTS)
	$(ACTION)

adv_20130206.t: adv_20130206.txt
	$(TXT2PLAIN) < $< > $@

vulnerabilities.html: _vulnerabilities.html vuln.txt $(MAINPARTS)
	$(ACTION)

vuln.txt: ../_changes.html ./vulntable.pl vuln.pm
	./vulntable.pl < $< > $@

releases.html: _releases.html rel.txt $(MAINPARTS)
	$(ACTION)

rel.txt: ../_changes.html ./relinfo.pl vuln.pm
	./relinfo.pl < $< > $@

releases.csv: ../_changes.html ./relinfo.pl vuln.pm
	./relinfo.pl --raw < $< > $@


#archive/index.html: mail
#	./fixit

full: all

