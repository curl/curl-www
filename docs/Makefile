ROOT=..
SRCROOT=../cvssource
DOCROOT=$(SRCROOT)/docs

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html ../alert.t

# For each individual advisory page
ADVBOX = adv-related-box.inc

FCPP_OPTS = -DSHOW_ALERT
MAN2HTML = roffit --bare

PAGES =						\
 CVE-2000-0973.html				\
 CVE-2003-XXXX.html				\
 CVE-2005-0490.html				\
 CVE-2005-0490.html				\
 CVE-2005-3185.html				\
 CVE-2005-4077.html				\
 CVE-2006-1061.html				\
 CVE-2007-3564.html				\
 CVE-2009-0037.html				\
 CVE-2009-2417.html				\
 CVE-2010-0734.html				\
 CVE-2010-3842.html				\
 CVE-2011-2192.html				\
 CVE-2012-0036.html				\
 CVE-2011-3389.html				\
 CVE-2013-0249.html				\
 CVE-2013-1944.html				\
 CVE-2013-2174.html				\
 CVE-2013-4545.html				\
 CVE-2013-6422.html				\
 CVE-2014-0015.html				\
 CVE-2014-0138.html				\
 CVE-2014-0139.html				\
 CVE-2014-1263.html				\
 CVE-2014-2522.html				\
 CVE-2014-3613.html				\
 CVE-2014-3620.html				\
 CVE-2014-3707.html				\
 CVE-2014-8151.html				\
 CVE-2014-8150.html				\
 CVE-2015-3143.html				\
 CVE-2015-3148.html				\
 CVE-2015-3145.html				\
 CVE-2015-3144.html				\
 CVE-2015-3153.html				\
 CVE-2015-3236.html				\
 CVE-2015-3237.html				\
 CVE-2016-0755.html				\
 CVE-2016-0754.html				\
 CVE-2016-3739.html				\
 CVE-2016-4802.html				\
 CVE-2016-5419.html				\
 CVE-2016-5420.html				\
 CVE-2016-5421.html				\
 CVE-2016-7141.html				\
 CVE-2016-7167.html				\
 CVE-2016-8615.html				\
 CVE-2016-8616.html				\
 CVE-2016-8617.html				\
 CVE-2016-8618.html				\
 CVE-2016-8619.html				\
 CVE-2016-8620.html				\
 CVE-2016-8621.html				\
 CVE-2016-8622.html				\
 CVE-2016-8623.html				\
 CVE-2016-8624.html				\
 CVE-2016-8625.html				\
 CVE-2016-9586.html				\
 CVE-2016-9952.html				\
 CVE-2016-9953.html				\
 CVE-2016-9594.html				\
 CVE-2017-8816.html				\
 CVE-2017-8817.html				\
 CVE-2017-8818.html				\
 CVE-2017-2629.html				\
 CVE-2017-7407.html				\
 CVE-2017-7468.html				\
 CVE-2017-9502.html				\
 CVE-2017-1000101.html				\
 CVE-2017-1000100.html				\
 CVE-2017-1000099.html				\
 CVE-2017-1000254.html				\
 CVE-2017-1000257.html				\
 CVE-2018-0500.html                             \
 CVE-2018-1000005.html				\
 CVE-2018-1000300.html				\
 CVE-2018-1000121.html				\
 CVE-2018-1000120.html				\
 CVE-2018-1000122.html				\
 CVE-2018-1000301.html				\
 CVE-2018-1000007.html				\
 bugs.html					\
 caextract.html					\
 code-of-conduct.html				\
 companies.html					\
 comparison-table.html				\
 copyright.html					\
 faq.html					\
 features.html					\
 governance.html				\
 help-us.html					\
 history.html					\
 http-cookies.html				\
 http2.html					\
 httpscripting.html				\
 index.html					\
 install.html					\
 knownbugs.html					\
 libs.html					\
 manpage.html					\
 manual.html					\
 mk-ca-bundle.html				\
 projdocs.html					\
 protdocs.html					\
 reldocs.html					\
 releases.csv					\
 releases.html					\
 security.html					\
 ssl-ciphers.html				\
 ssl-compared.html				\
 sslcerts.html					\
 survey/survey2014.html				\
 thanks.html					\
 todo.html					\
 tooldocs.html					\
 versions.html					\
 vulnerabilities.html				\
 whodocs.html

all: vuln.gen $(PAGES) vuln-make.gen
	-test -f vuln-make.gen && make -f vuln-make.gen
	@echo done 

clean:
	-test -f vuln-make.gen && make -f vuln-make.gen clean
	rm -f $(PAGES) *.gen

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

governance.html: _governance.html $(MAINPARTS) governance.gen
	$(ACTION)

governance.gen: $(DOCROOT)/GOVERNANCE.md
	$(MARKDOWN) < $< > $@

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

CVE-%.html: CVE-%.md $(MAINPARTS) advisory.t $(ADVBOX)
	$(MARKDOWN) < $< | perl curlver-to-vulnlink.pl | ./mk-adv-template.pl $@ | fcpp $(FCPP_OPTS) -I$(ROOT) -WWW -Uunix -P -H -C -V -LL - > $@

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



