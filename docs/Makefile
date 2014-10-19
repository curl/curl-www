ROOT=..
SRCROOT=../cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html

TXT2HTML= txt2html --extract --hrule 10
MAN2HTML = roffit --bare
ADVBOX = adv-related-box.inc

PAGES = index.html manpage.html faq.html changes.html sslcerts.html	      \
 companies.html press.html features.html bugs.html install.html readme.html   \
 readme.curl.html copyright.html thanks.html y2k.html todo.html		      \
 httpscripting.html comparison-table.html relatedtools.html osdistribs.html   \
 versions.html history.html knownbugs.html manual.html caextract.html	      \
 programs.html security.html libs.html http-cookies.html adv_20051013.html    \
 adv_20051207.html adv_20060320.html vulnerabilities.html adv_20070710.html   \
 gsoc2008.html releases.html adv_20090303.html releases.csv adv_20090812.html \
 adv_20100209.html adv_20101013.html adv_20110623.html ssl-compared.html      \
 adv_20120124.html adv_20120124B.html mk-ca-bundle.html adv_20130206.html     \
 adv_20130412.html adv_20130622.html adv_20131115.html adv_20131217.html      \
 adv_20140129.html adv_20140326A.html adv_20140326B.html adv_20140326C.html   \
 adv_20140326D.html survey/survey2014.html adv_20140910A.html		      \
 adv_20140910B.html adv_20141105.html

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
	$(MARKDOWN) < $(DOCROOT)/HISTORY > history.t

changes.html: _changes.shtml $(MAINPARTS) changes.t
	$(ACTION)

changes.t: $(SRCROOT)/CHANGES
	$(TXT2PLAIN) < $< > $@

companies.html: _companies.html $(MAINPARTS)
	$(ACTION)

press.html: _press.html $(MAINPARTS)
	$(ACTION)

survey/survey2014.html: survey/_survey2014.html $(MAINPARTS)
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
	./faqparse.pl < $< > $@

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
	./faqparse.pl < $< | sed -e 's:*:\&#42;:g' -e 's:#undef:\&#35;undef:g'> $@

versions.html: _versions.html $(MAINPARTS) versions.t
	$(ACTION)

versions.t: $(DOCROOT)/VERSIONS
	$(TXT2HTML) < $(DOCROOT)/VERSIONS > versions.t

sslcerts.html: _sslcerts.html $(MAINPARTS) sslcerts.t
	$(ACTION)

sslcerts.t: $(DOCROOT)/SSLCERTS
	$(MARKDOWN) < $< > $@

copyright.html: _copyright.html $(MAINPARTS) copying.t
	$(ACTION)
copying.t: $(SRCROOT)/COPYING
	$(MARKDOWN) < $< > $@

comparison-table.html: _comparison-table.html $(MAINPARTS)  $(ROOT)/release.t
	$(ACTION)

ssl-compared.html: _ssl-compared.html $(MAINPARTS)
	$(ACTION)

relatedtools.html: _relatedtools.html $(MAINPARTS)
	$(ACTION)

osdistribs.html: _osdistribs.html $(MAINPARTS)
	$(ACTION)

y2k.html: _y2k.html $(MAINPARTS)
	$(ACTION)

caextract.html: _caextract.html $(MAINPARTS)
	$(ACTION)

programs.html: _programs.html $(MAINPARTS)
	$(ACTION)

security.html: _security.html $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20051013.html: _adv_20051013.html adv_20051013.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20051013.t: adv_20051013.txt
	$(TXT2PLAIN) < $< > $@

adv_20051207.html: _adv_20051207.html adv_20051207.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20051207.t: adv_20051207.txt
	$(TXT2PLAIN) < $< > $@

adv_20060320.html: _adv_20060320.html adv_20060320.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20060320.t: adv_20060320.txt
	$(TXT2PLAIN) < $< > $@

adv_20070710.html: _adv_20070710.html adv_20070710.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20070710.t: adv_20070710.txt
	$(TXT2PLAIN) < $< > $@

adv_20090303.html: _adv_20090303.html adv_20090303.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20090303.t: adv_20090303.txt
	$(TXT2PLAIN) < $< > $@

adv_20090812.html: _adv_20090812.html adv_20090812.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20090812.t: adv_20090812.txt
	$(TXT2PLAIN) < $< > $@

adv_20100209.html: _adv_20100209.html adv_20100209.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20100209.t: adv_20100209.txt
	$(TXT2PLAIN) < $< > $@

adv_20101013.html: _adv_20101013.html adv_20101013.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20101013.t: adv_20101013.txt
	$(TXT2PLAIN) < $< > $@

adv_20110623.html: _adv_20110623.html adv_20110623.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20110623.t: adv_20110623.txt
	$(TXT2PLAIN) < $< > $@

adv_20120124.html: _adv_20120124.html adv_20120124.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20120124.t: adv_20120124.txt
	$(TXT2PLAIN) < $< > $@

adv_20120124B.html: _adv_20120124B.html adv_20120124B.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20120124B.t: adv_20120124B.txt
	$(TXT2PLAIN) < $< > $@

adv_20130206.html: _adv_20130206.html adv_20130206.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20130206.t: adv_20130206.txt
	$(TXT2PLAIN) < $< > $@

adv_20130412.html: _adv_20130412.html adv_20130412.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20130412.t: adv_20130412.txt
	$(TXT2PLAIN) < $< > $@

adv_20130622.html: _adv_20130622.html adv_20130622.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20130622.t: adv_20130622.txt
	$(TXT2PLAIN) < $< > $@

adv_20131115.html: _adv_20131115.html adv_20131115.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20131115.t: adv_20131115.txt
	$(TXT2PLAIN) < $< > $@

adv_20131217.html: _adv_20131217.html adv_20131217.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20131217.t: adv_20131217.txt
	$(TXT2PLAIN) < $< > $@

adv_20140129.html: _adv_20140129.html adv_20140129.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20140129.t: adv_20140129.txt
	$(TXT2PLAIN) < $< > $@

adv_20140326A.html: _adv_20140326A.html adv_20140326A.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20140326A.t: adv_20140326A.txt
	$(TXT2PLAIN) < $< > $@

adv_20140326B.html: _adv_20140326B.html adv_20140326B.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20140326B.t: adv_20140326B.txt
	$(TXT2PLAIN) < $< > $@

adv_20140326C.html: _adv_20140326C.html adv_20140326C.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20140326C.t: adv_20140326C.txt
	$(TXT2PLAIN) < $< > $@

adv_20140326D.html: _adv_20140326D.html adv_20140326D.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20140326D.t: adv_20140326D.txt
	$(TXT2PLAIN) < $< > $@

adv_20140910A.html: _adv_20140910A.html adv_20140910A.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20140910A.t: adv_20140910A.txt
	$(TXT2PLAIN) < $< > $@

adv_20140910B.html: _adv_20140910B.html adv_20140910B.t $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20140910B.t: adv_20140910B.txt
	$(TXT2PLAIN) < $< > $@

adv_20141105.html: _adv_20141105.html adv_20141105.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20141105.gen: adv_20141105.txt
	$(MARKDOWN) < $< > $@

vulnerabilities.html: _vulnerabilities.html vuln.txt $(MAINPARTS)
	$(ACTION)

vuln.txt: $(ROOT)/_changes.html ./vulntable.pl vuln.pm
	./vulntable.pl < $< > $@

releases.html: _releases.html rel.txt $(MAINPARTS)
	$(ACTION)

rel.txt: $(ROOT)/_changes.html ./relinfo.pl vuln.pm
	./relinfo.pl < $< > $@

releases.csv: $(ROOT)/_changes.html ./relinfo.pl vuln.pm
	./relinfo.pl --raw < $< > $@


#archive/index.html: mail
#	./fixit

full: all

