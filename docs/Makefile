ROOT=..
SRCROOT=../cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html

MAN2HTML = roffit --bare
ADVBOX = adv-related-box.inc

ADVCONV= $(MARKDOWN) < $< | perl curlver-to-vulnlink.pl > $@

PAGES = index.html manpage.html faq.html sslcerts.html companies.html	      \
 features.html bugs.html install.html copyright.html thanks.html todo.html    \
 httpscripting.html comparison-table.html relatedtools.html versions.html     \
 history.html knownbugs.html manual.html caextract.html programs.html	      \
 security.html libs.html http-cookies.html adv_20051013.html		      \
 adv_20051207.html adv_20060320.html vulnerabilities.html adv_20070710.html   \
 releases.html adv_20090303.html releases.csv adv_20090812.html		      \
 adv_20100209.html adv_20101013.html adv_20110623.html ssl-compared.html      \
 adv_20120124.html adv_20120124B.html mk-ca-bundle.html adv_20130206.html     \
 adv_20130412.html adv_20130622.html adv_20131115.html adv_20131217.html      \
 adv_20140129.html adv_20140326A.html adv_20140326B.html adv_20140326C.html   \
 adv_20140326D.html survey/survey2014.html adv_20140910A.html		      \
 adv_20140910B.html adv_20141105.html adv_20150108A.html adv_20150108B.html   \
 adv_20150422A.html adv_20150422B.html adv_20001013.html adv_20030803.html    \
 adv_20050221A.html adv_20050221B.html adv_20150422C.html adv_20150422D.html  \
 adv_20150429.html http2.html tooldocs.html projdocs.html reldocs.html	      \
 protdocs.html whodocs.html adv_20150617A.html adv_20150617B.html	      \
 adv_20160127A.html adv_20160127B.html adv_20160518.html adv_20160530.html    \
 adv_20160803A.html adv_20160803B.html adv_20160803C.html adv_20160907.html   \
 code-of-conduct.html adv_20160914.html adv_20161102A.html adv_20161102B.html \
 adv_20161102C.html adv_20161102D.html adv_20161102E.html adv_20161102F.html  \
 adv_20161102G.html adv_20161102H.html adv_20161102I.html adv_20161102J.html  \
 adv_20161102K.html ssl-ciphers.html \
 adv_20161221A.html adv_20161221B.html adv_20161221C.html adv_20161223.html

all: $(PAGES) vuln-make.gen
	-test -f vuln-make.gen && make -f vuln-make.gen
	@echo done 

clean:
	-test -f vuln-make.gen && make -f vuln-make.gen clean
	rm -f $(PAGES) *.gen *.t

vuln-make.gen: vuln.gen

index.html: _index.html $(MAINPARTS)
	$(ACTION)

tooldocs.html: _tooldocs.html $(MAINPARTS)
	$(ACTION)

projdocs.html: _projdocs.html $(MAINPARTS)
	$(ACTION)

reldocs.html: _reldocs.html $(MAINPARTS)
	$(ACTION)

protdocs.html: _protdocs.html $(MAINPARTS)
	$(ACTION)

whodocs.html: _whodocs.html $(MAINPARTS)
	$(ACTION)

libs.html: _libs.html $(MAINPARTS)
	$(ACTION)

manpage.html: _manpage.html $(MAINPARTS) mandump.gen $(ROOT)/manpage.t
	$(ACTION)

mandump.gen: $(DOCROOT)/curl.1
	 $(MAN2HTML) < $(DOCROOT)/curl.1 > mandump.gen

mk-ca-bundle.html: _mk-ca-bundle.html $(MAINPARTS) mkdump.gen $(ROOT)/manpage.t
	$(ACTION)

mkdump.gen: $(DOCROOT)/mk-ca-bundle.1
	 $(MAN2HTML) < $(DOCROOT)/mk-ca-bundle.1 > mkdump.gen

bugs.html: _bugs.html $(MAINPARTS) bugs.gen
	$(ACTION)

bugs.gen: $(DOCROOT)/BUGS faqparse.pl
	./faqparse.pl < $< > $@

history.html: _history.html $(MAINPARTS) history.gen
	$(ACTION)

history.gen: $(DOCROOT)/HISTORY.md
	$(MARKDOWN) < $(DOCROOT)/HISTORY.md > $@

code-of-conduct.html: _code-of-conduct.html $(MAINPARTS) coc.gen
	$(ACTION)

coc.gen: $(DOCROOT)/CODE_OF_CONDUCT.md
	$(MARKDOWN) < $< > $@

companies.html: _companies.html $(MAINPARTS)
	$(ACTION)

survey/survey2014.html: survey/_survey2014.html $(MAINPARTS)
	$(ACTION)

thanks.html: _thanks.html $(MAINPARTS) thanks.gen thanksnum.gen
	$(ACTION)

thanksnum.gen: $(DOCROOT)/THANKS
	egrep '^[^ $$]' $< | wc -l  | awk '{print "#define __THANKSNUM__ " $$1}' > $@

thanks.gen: $(DOCROOT)/THANKS thanks.pl
	egrep '^[^ $$]' $< | ./thanks.pl > $@

faq.html: _faq.shtml $(MAINPARTS) faq.gen
	$(ACTION)

faq.gen: $(DOCROOT)/FAQ faqparse.pl
	./faqparse.pl < $< > $@

http-cookies.html: _http-cookies.html $(MAINPARTS) http-cookies.gen
	$(ACTION)

http-cookies.gen: $(DOCROOT)/HTTP-COOKIES.md faqparse.pl
	$(MARKDOWN) < $< >$@

knownbugs.html: _knownbugs.html $(MAINPARTS) knownbugs.gen
	$(ACTION)

knownbugs.gen: $(DOCROOT)/KNOWN_BUGS faqparse.pl
	./faqparse.pl < $< > $@

httpscript.gen: $(DOCROOT)/TheArtOfHttpScripting
	./faqparse.pl < $< > $@

httpscripting.html: _httpscripting.shtml $(MAINPARTS) httpscript.gen
	$(ACTION)

features.html: _features.html $(MAINPARTS) features.gen
	$(ACTION)

features.gen: $(DOCROOT)/FEATURES
	$(TXT2PLAIN) < $<  > $@

install.html: _install.html $(MAINPARTS) install.gen
	$(ACTION)

install.gen: $(DOCROOT)/INSTALL.md
	$(MARKDOWN) < $< > $@

manual.html: _manual.html $(MAINPARTS) manual.gen
	$(ACTION)

manual.gen: $(DOCROOT)/MANUAL
	$(TXT2PLAIN) < $< >$@

todo.html: _todo.html $(MAINPARTS) todo.gen
	$(ACTION)

todo.gen: $(DOCROOT)/TODO faqparse.pl
	./faqparse.pl < $< > $@

versions.html: _versions.html $(MAINPARTS) versions.gen
	$(ACTION)

versions.gen: $(DOCROOT)/VERSIONS
	$(MARKDOWN) < $< >$@

sslcerts.html: _sslcerts.html $(MAINPARTS) sslcerts.gen
	$(ACTION)

sslcerts.gen: $(DOCROOT)/SSLCERTS.md
	$(MARKDOWN) < $< > $@

copyright.html: _copyright.html $(MAINPARTS) copying.gen
	$(ACTION)
copying.gen: $(SRCROOT)/COPYING
	$(MARKDOWN) < $< > $@

comparison-table.html: _comparison-table.html $(MAINPARTS)  $(ROOT)/release.t
	$(ACTION)

ssl-compared.html: _ssl-compared.html $(MAINPARTS)
	$(ACTION)

ciphers.gen: $(SRCROOT)/docs/CIPHERS.md
	$(MARKDOWN) < $< > $@
ssl-ciphers.html: _ssl-ciphers.html $(MAINPARTS) ciphers.gen
	$(ACTION)

relatedtools.html: _relatedtools.html $(MAINPARTS)
	$(ACTION)

caextract.html: _caextract.html $(MAINPARTS) ../ca/pemlist.gen
	$(ACTION)

programs.html: _programs.html $(MAINPARTS)
	$(ACTION)

security.html: _security.html seclist.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
seclist.gen: vuln.pm listvulns.pl
	./listvulns.pl > seclist.gen

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
	$(ADVCONV)

adv_20150108A.html: _adv_20150108A.html adv_20150108A.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20150108A.gen: adv_20150108A.txt
	$(ADVCONV)

adv_20150108B.html: _adv_20150108B.html adv_20150108B.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20150108B.gen: adv_20150108B.txt
	$(ADVCONV)

adv_20150422A.html: _adv_20150422A.html adv_20150422A.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20150422A.gen: adv_20150422A.txt
	$(ADVCONV)

adv_20150422B.html: _adv_20150422B.html adv_20150422B.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20150422B.gen: adv_20150422B.txt
	$(ADVCONV)

adv_20150422C.html: _adv_20150422C.html adv_20150422C.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20150422C.gen: adv_20150422C.txt
	$(ADVCONV)

adv_20150422D.html: _adv_20150422D.html adv_20150422D.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20150422D.gen: adv_20150422D.txt
	$(ADVCONV)

adv_20150429.html: _adv_20150429.html adv_20150429.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20150429.gen: adv_20150429.txt
	$(ADVCONV)

adv_20150617A.html: _adv_20150617A.html adv_20150617A.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20150617A.gen: adv_20150617A.txt
	$(ADVCONV)

adv_20150617B.html: _adv_20150617B.html adv_20150617B.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20150617B.gen: adv_20150617B.txt
	$(ADVCONV)

adv_20160127A.html: _adv_20160127A.html adv_20160127A.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20160127A.gen: adv_20160127A.txt
	$(ADVCONV)

adv_20160127B.html: _adv_20160127B.html adv_20160127B.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20160127B.gen: adv_20160127B.txt
	$(ADVCONV)

adv_20160518.html: _adv_20160518.html adv_20160518.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20160518.gen: adv_20160518.txt
	$(ADVCONV)

adv_20160530.html: _adv_20160530.html adv_20160530.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20160530.gen: adv_20160530.txt
	$(ADVCONV)

adv_20160803A.html: _adv_20160803A.html adv_20160803A.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20160803A.gen: adv_20160803A.txt
	$(ADVCONV)

adv_20160803B.html: _adv_20160803B.html adv_20160803B.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20160803B.gen: adv_20160803B.txt
	$(ADVCONV)

adv_20160803C.html: _adv_20160803C.html adv_20160803C.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20160803C.gen: adv_20160803C.txt
	$(ADVCONV)

adv_20160907.html: _adv_20160907.html adv_20160907.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20160907.gen: adv_20160907.txt
	$(ADVCONV)

adv_20160914.html: _adv_20160914.html adv_20160914.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20160914.gen: adv_20160914.txt
	$(ADVCONV)

adv_20001013.html: _adv_20001013.html $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20030803.html: _adv_20030803.html $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20050221A.html: _adv_20050221A.html $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20050221B.html: _adv_20050221B.html $(MAINPARTS) $(ADVBOX)
	$(ACTION)

adv_20161102A.html: _adv_20161102A.html adv_20161102A.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161102A.gen: adv_20161102A.txt
	$(ADVCONV)

adv_20161102B.html: _adv_20161102B.html adv_20161102B.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161102B.gen: adv_20161102B.txt
	$(ADVCONV)

adv_20161102C.html: _adv_20161102C.html adv_20161102C.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161102C.gen: adv_20161102C.txt
	$(ADVCONV)

adv_20161102D.html: _adv_20161102D.html adv_20161102D.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161102D.gen: adv_20161102D.txt
	$(ADVCONV)

adv_20161102E.html: _adv_20161102E.html adv_20161102E.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161102E.gen: adv_20161102E.txt
	$(ADVCONV)

adv_20161102F.html: _adv_20161102F.html adv_20161102F.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161102F.gen: adv_20161102F.txt
	$(ADVCONV)

adv_20161102G.html: _adv_20161102G.html adv_20161102G.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161102G.gen: adv_20161102G.txt
	$(ADVCONV)

adv_20161102H.html: _adv_20161102H.html adv_20161102H.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161102H.gen: adv_20161102H.txt
	$(ADVCONV)

adv_20161102I.html: _adv_20161102I.html adv_20161102I.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161102I.gen: adv_20161102I.txt
	$(ADVCONV)

adv_20161102J.html: _adv_20161102J.html adv_20161102J.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161102J.gen: adv_20161102J.txt
	$(ADVCONV)

adv_20161102K.html: _adv_20161102K.html adv_20161102K.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161102K.gen: adv_20161102K.txt
	$(ADVCONV)

adv_20161221A.html: _adv_20161221A.html adv_20161221A.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161221A.gen: adv_20161221A.txt
	$(ADVCONV)

adv_20161221B.html: _adv_20161221B.html adv_20161221B.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161221B.gen: adv_20161221B.txt
	$(ADVCONV)

adv_20161221C.html: _adv_20161221C.html adv_20161221C.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161221C.gen: adv_20161221C.txt
	$(ADVCONV)

adv_20161223.html: _adv_20161223.html adv_20161223.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
adv_20161223.gen: adv_20161223.txt
	$(ADVCONV)

vulnerabilities.html: _vulnerabilities.html vuln.gen $(MAINPARTS)
	$(ACTION)

vuln.gen: $(ROOT)/_changes.html ./vulntable.pl vuln.pm _singlevuln.templ
	./vulntable.pl < $< > $@

http2.gen: $(SRCROOT)/docs/HTTP2.md
	$(MARKDOWN) < $< > $@

http2.html: _http2.html http2.gen $(MAINPARTS)
	$(ACTION)

releases.html: _releases.html rel.gen $(MAINPARTS)
	$(ACTION)

rel.gen: $(ROOT)/_changes.html ./relinfo.pl vuln.pm
	./relinfo.pl < $< > $@

releases.csv: $(ROOT)/_changes.html ./relinfo.pl vuln.pm
	./relinfo.pl --raw < $< > $@



