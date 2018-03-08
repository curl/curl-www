ROOT=..
SRCROOT=../cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html ../alert.t

# For each individual advisory page
ADVBOX = adv-related-box.inc
ADVPARTS = $(MAINPARTS) advisory.t $(ADVBOX)

FCPP_OPTS = -DSHOW_ALERT
MAN2HTML = roffit --bare

ADVCONV= $(MARKDOWN) < $< | perl curlver-to-vulnlink.pl > $@
ADV_ACTION = $(MARKDOWN) < $< | perl curlver-to-vulnlink.pl | ./mk-adv-template.pl $@ | fcpp $(FCPP_OPTS) -I$(ROOT) -WWW -Uunix -P -H -C -V -LL - > $@

PAGES = index.html manpage.html faq.html sslcerts.html companies.html	      \
 features.html bugs.html install.html copyright.html thanks.html todo.html    \
 httpscripting.html comparison-table.html versions.html help-us.html          \
 history.html knownbugs.html manual.html caextract.html     	              \
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
 adv_20161221A.html adv_20161221B.html adv_20161221C.html adv_20161223.html   \
 adv_20170222.html adv_20170403.html adv_20170419.html adv_20170614.html      \
 adv_20170809A.html adv_20170809B.html adv_20170809C.html adv_20171004.html   \
 adv_20171023.html adv_2017-12e7.html adv_2017-ae72.html adv_2017-af0a.html \
 adv_2018-b3bf.html adv_2018-824a.html adv_2018-97a2.html adv_2018-9cd6.html \
 adv_2018-b047.html

all: $(PAGES) vuln-make.gen
	-test -f vuln-make.gen && make -f vuln-make.gen
	@echo done 

clean:
	-test -f vuln-make.gen && make -f vuln-make.gen clean
	rm -f $(PAGES)

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

mandump.gen: curl.1
	 $(MAN2HTML) < $< > mandump.gen

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

help-us.html: _help-us.html $(MAINPARTS) help-us.gen
	$(ACTION)
help-us.gen: $(DOCROOT)/HELP-US.md
	$(MARKDOWN) < $(DOCROOT)/HELP-US.md > $@

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

caextract.html: _caextract.html $(MAINPARTS) ../ca/pemlist.gen
	$(ACTION)

security.html: _security.html seclist.gen $(MAINPARTS) $(ADVBOX)
	$(ACTION)
seclist.gen: vuln.pm listvulns.pl
	./listvulns.pl > seclist.gen

adv_20051013.html: adv_20051013.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20051207.html: adv_20051207.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20060320.html: adv_20060320.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20070710.html: adv_20070710.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20090303.html: adv_20090303.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20090812.html: adv_20090812.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20100209.html: adv_20100209.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20101013.html: adv_20101013.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20110623.html: adv_20110623.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20120124.html: adv_20120124.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20120124B.html: adv_20120124B.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20130206.html: adv_20130206.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20130412.html: adv_20130412.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20130622.html: adv_20130622.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20131115.html: adv_20131115.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20131217.html: adv_20131217.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20140129.html: adv_20140129.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20140326A.html: adv_20140326A.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20140326B.html: adv_20140326B.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20140326C.html: adv_20140326C.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20140326D.html: adv_20140326D.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20140910A.html: adv_20140910A.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20140910B.html: adv_20140910B.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20141105.html: adv_20141105.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20150108A.html: adv_20150108A.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20150108B.html: adv_20150108B.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20150422A.html: adv_20150422A.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20150422B.html: adv_20150422B.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20150422C.html: adv_20150422C.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20150422D.html: adv_20150422D.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20150429.html: adv_20150429.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20150617A.html: adv_20150617A.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20150617B.html: adv_20150617B.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20160127A.html: adv_20160127A.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20160127B.html: adv_20160127B.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20160518.html: adv_20160518.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20160530.html: adv_20160530.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20160803A.html: adv_20160803A.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20160803B.html: adv_20160803B.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20160803C.html: adv_20160803C.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20160907.html: adv_20160907.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20160914.html: adv_20160914.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20001013.html: adv_20001013.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20030803.html: adv_20030803.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20050221A.html: adv_20050221A.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20050221B.html: adv_20050221B.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161102A.html: adv_20161102A.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161102B.html: adv_20161102B.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161102C.html: adv_20161102C.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161102D.html: adv_20161102D.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161102E.html: adv_20161102E.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161102F.html: adv_20161102F.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161102G.html: adv_20161102G.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161102H.html: adv_20161102H.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161102I.html: adv_20161102I.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161102J.html: adv_20161102J.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161102K.html: adv_20161102K.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161221A.html: adv_20161221A.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161221B.html: adv_20161221B.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161221C.html: adv_20161221C.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20161223.html: adv_20161223.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20170222.html: adv_20170222.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20170403.html: adv_20170403.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20170419.html: adv_20170419.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20170614.html: adv_20170614.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20170809A.html: adv_20170809A.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20170809B.html: adv_20170809B.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20170809C.html: adv_20170809C.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20171004.html: adv_20171004.md $(ADVPARTS)
	$(ADV_ACTION)
adv_20171023.html: adv_20171023.md $(ADVPARTS)
	$(ADV_ACTION)
adv_2017-12e7.html: adv_2017-12e7.md $(ADVPARTS)
	$(ADV_ACTION)
adv_2017-ae72.html: adv_2017-ae72.md $(ADVPARTS)
	$(ADV_ACTION)
adv_2017-af0a.html: adv_2017-af0a.md $(ADVPARTS)
	$(ADV_ACTION)
adv_2018-b3bf.html: adv_2018-b3bf.md $(ADVPARTS)
	$(ADV_ACTION)
adv_2018-824a.html: adv_2018-824a.md  $(ADVPARTS)
	$(ADV_ACTION)
adv_2018-97a2.html: adv_2018-97a2.md $(ADVPARTS)
	$(ADV_ACTION)
adv_2018-9cd6.html: adv_2018-9cd6.md $(ADVPARTS)
	$(ADV_ACTION)
adv_2018-b047.html: adv_2018-b047.md $(ADVPARTS)
	$(ADV_ACTION)

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

rel.gen: $(ROOT)/_changes.html ./relinfo.pl vuln.pm allvulns.gen
	./relinfo.pl < $< > $@

releases.csv: $(ROOT)/_changes.html ./relinfo.pl vuln.pm
	./relinfo.pl --raw < $< > $@



