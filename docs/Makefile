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

CVELIST = \
 CVE-2000-0973.html \
 CVE-2003-1605.html \
 CVE-2005-0490.html \
 CVE-2005-0490.html \
 CVE-2005-3185.html \
 CVE-2005-4077.html \
 CVE-2006-1061.html \
 CVE-2007-3564.html \
 CVE-2009-0037.html \
 CVE-2009-2417.html \
 CVE-2010-0734.html \
 CVE-2010-3842.html \
 CVE-2011-2192.html \
 CVE-2012-0036.html \
 CVE-2011-3389.html \
 CVE-2013-0249.html \
 CVE-2013-1944.html \
 CVE-2013-2174.html \
 CVE-2013-4545.html \
 CVE-2013-6422.html \
 CVE-2014-0015.html \
 CVE-2014-0138.html \
 CVE-2014-0139.html \
 CVE-2014-1263.html \
 CVE-2014-2522.html \
 CVE-2014-3613.html \
 CVE-2014-3620.html \
 CVE-2014-3707.html \
 CVE-2014-8151.html \
 CVE-2014-8150.html \
 CVE-2015-3143.html \
 CVE-2015-3148.html \
 CVE-2015-3145.html \
 CVE-2015-3144.html \
 CVE-2015-3153.html \
 CVE-2015-3236.html \
 CVE-2015-3237.html \
 CVE-2016-0755.html \
 CVE-2016-0754.html \
 CVE-2016-3739.html \
 CVE-2016-4802.html \
 CVE-2016-5419.html \
 CVE-2016-5420.html \
 CVE-2016-5421.html \
 CVE-2016-7141.html \
 CVE-2016-7167.html \
 CVE-2016-8615.html \
 CVE-2016-8616.html \
 CVE-2016-8617.html \
 CVE-2016-8618.html \
 CVE-2016-8619.html \
 CVE-2016-8620.html \
 CVE-2016-8621.html \
 CVE-2016-8622.html \
 CVE-2016-8623.html \
 CVE-2016-8624.html \
 CVE-2016-8625.html \
 CVE-2016-9586.html \
 CVE-2016-9952.html \
 CVE-2016-9953.html \
 CVE-2016-9594.html \
 CVE-2017-8816.html \
 CVE-2017-8817.html \
 CVE-2017-8818.html \
 CVE-2017-2629.html \
 CVE-2017-7407.html \
 CVE-2017-7468.html \
 CVE-2017-9502.html \
 CVE-2017-1000101.html \
 CVE-2017-1000100.html \
 CVE-2017-1000099.html \
 CVE-2017-1000254.html \
 CVE-2017-1000257.html \
 CVE-2018-0500.html \
 CVE-2018-1000005.html \
 CVE-2018-1000300.html \
 CVE-2018-1000121.html \
 CVE-2018-1000120.html \
 CVE-2018-1000122.html \
 CVE-2018-1000301.html \
 CVE-2018-1000007.html \
 CVE-2018-14618.html \
 CVE-2018-16839.html \
 CVE-2018-16840.html \
 CVE-2018-16842.html \
 CVE-2018-16890.html \
 CVE-2019-3822.html \
 CVE-2019-3823.html \
 CVE-2019-5435.html \
 CVE-2019-5436.html \
 CVE-2019-5443.html \
 CVE-2019-5481.html \
 CVE-2019-5482.html \
 CVE-2019-15601.html \
 CVE-2020-8169.html \
 CVE-2020-8177.html \
 CVE-2020-8231.html \
 CVE-2020-8284.html \
 CVE-2020-8285.html \
 CVE-2020-8286.html \
 CVE-2021-22876.html \
 CVE-2021-22890.html \
 CVE-2021-22897.html \
 CVE-2021-22898.html \
 CVE-2021-22901.html \
 CVE-2021-22922.html \
 CVE-2021-22923.html \
 CVE-2021-22924.html \
 CVE-2021-22925.html \
 CVE-2021-22926.html \
 CVE-2021-22945.html \
 CVE-2021-22946.html \
 CVE-2021-22947.html \
 CVE-2022-22576.html \
 CVE-2022-27774.html \
 CVE-2022-27775.html \
 CVE-2022-27776.html \
 CVE-2022-27778.html \
 CVE-2022-27779.html \
 CVE-2022-27780.html \
 CVE-2022-27781.html \
 CVE-2022-27782.html \
 CVE-2022-30115.html \
 CVE-2022-32205.html \
 CVE-2022-32206.html \
 CVE-2022-32207.html \
 CVE-2022-32208.html \
 CVE-2022-35252.html \
 CVE-2022-32221.html \
 CVE-2022-35260.html \
 CVE-2022-42915.html \
 CVE-2022-42916.html \
 CVE-2022-43551.html \
 CVE-2022-43552.html \
 CVE-2023-23914.html \
 CVE-2023-23915.html \
 CVE-2023-23916.html \
 CVE-2023-27533.html \
 CVE-2023-27534.html \
 CVE-2023-27535.html \
 CVE-2023-27536.html \
 CVE-2023-27537.html \
 CVE-2023-27538.html \
 CVE-2023-28319.html \
 CVE-2023-28320.html \
 CVE-2023-28321.html \
 CVE-2023-28322.html \
 CVE-2023-32001.html \
 CVE-2020-19909.html

PAGES = \
 $(CVELIST) \
 alt-svc.html \
 bugbounty.html \
 bugs.html \
 caextract.html \
 code-of-conduct.html \
 companies.html \
 comparison-table.html \
 copyright.html \
 faq.html \
 features.html \
 governance.html \
 help-us.html \
 history.html \
 hsts.html \
 http-cookies.html \
 http2.html \
 http3.html \
 httpscripting.html \
 index.html \
 install.html \
 irc.html \
 knownbugs.html \
 libs.html \
 manpage.html \
 manual.html \
 mk-ca-bundle.html \
 mqtt.html \
 projdocs.html \
 protdocs.html \
 reldocs.html \
 releases.csv \
 releases.html \
 security.html \
 security-m.html \
 security-h.html \
 security-c.html \
 ssl-ciphers.html \
 ssl-compared.html \
 sslcerts.html \
 survey/survey2014.html \
 thanks.html \
 thename.html \
 todo.html \
 tooldocs.html \
 url-syntax.html \
 versions.html \
 vuln.csv \
 vuln.json \
 vulnerabilities.html \
 vulnall.html \
 websocket.html \
 whodocs.html

all: vuln.gen $(PAGES) vuln-make.gen
	-test -f vuln-make.gen && make -f vuln-make.gen
	cd videos && make

clean:
	-test -f vuln-make.gen && make -f vuln-make.gen clean
	rm -f $(PAGES) *.gen *.json vuln-*.html

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

manpage.html: _manpage.html $(MAINPARTS) manoptionsdump.gen mandump.gen $(ROOT)/manpage.t
	$(ACTION)

manoptionsdump.gen:
	perl generatemanmenu.pl $(DOCROOT)/cmdline-opts > manoptionsdump.gen

curl.1: ../cvssource/docs/cmdline-opts/*.d
	(cd ../cvssource/docs/cmdline-opts && perl gen.pl mainpage *.d) > curl.1

mandump.gen: curl.1
	 $(MAN2HTML) < $< > mandump.gen

mk-ca-bundle.html: _mk-ca-bundle.html $(MAINPARTS) mkdump.gen $(ROOT)/manpage.t
	$(ACTION)

mkdump.gen: $(DOCROOT)/mk-ca-bundle.1
	 $(MAN2HTML) < $(DOCROOT)/mk-ca-bundle.1 > mkdump.gen

bugs.html: _bugs.html $(MAINPARTS) bugs.gen
	$(ACTION)

bugs.gen: $(DOCROOT)/BUGS.md faqparse.pl
	$(MARKDOWN) < $< > $@

bugbounty.html: _bugbounty.html $(MAINPARTS) bugbounty.gen $(ADVBOX)
	$(ACTION)
bugbounty.gen: $(DOCROOT)/BUG-BOUNTY.md
	$(MARKDOWN) < $(DOCROOT)/BUG-BOUNTY.md > $@

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

url-syntax.html: _url-syntax.html $(MAINPARTS) url-syntax.gen
	$(ACTION)
url-syntax.gen: $(DOCROOT)/URL-SYNTAX.md
	$(MARKDOWN) < $(DOCROOT)/URL-SYNTAX.md > $@

companies.html: _companies.html $(MAINPARTS)
	$(ACTION)

survey/survey2014.html: survey/_survey2014.html $(MAINPARTS)
	$(ACTION)

thanks.html: _thanks.html $(MAINPARTS) thanks.gen thanksnum.gen
	$(ACTION)

thanksnum.gen: $(DOCROOT)/THANKS
	egrep '^[^ $$]' $< | wc -l  | awk '{print "#define __THANKSNUM__ " $$1}' > $@

thanks.gen: $(DOCROOT)/THANKS
	grep '^[^ ]' $< | sort | sed -e 's/ /\&nbsp;/g' -e 's/-/\&\#8209/g' | awk '{print $$0 "&nbsp;&middot; "; }' > $@

faq.html: _faq.shtml $(MAINPARTS) faq.gen
	$(ACTION)

faq.gen: $(DOCROOT)/FAQ faqparse.pl
	./faqparse.pl < $< > $@

alt-svc.html: _alt-svc.html $(MAINPARTS) alt-svc.gen
	$(ACTION)
alt-svc.gen: $(DOCROOT)/ALTSVC.md
	$(MARKDOWN) < $< >$@

hsts.html: _hsts.html $(MAINPARTS) hsts.gen
	$(ACTION)

hsts.gen: $(DOCROOT)/HSTS.md
	$(GITHUB) $< >$@

http-cookies.html: _http-cookies.html $(MAINPARTS) http-cookies.gen
	$(ACTION)

http-cookies.gen: $(DOCROOT)/HTTP-COOKIES.md
	$(GITHUB) $< >$@

irc.html: _irc.html $(MAINPARTS)
	$(ACTION)

knownbugs.html: _knownbugs.html $(MAINPARTS) knownbugs.gen
	$(ACTION)

knownbugs.gen: $(DOCROOT)/KNOWN_BUGS faqparse.pl
	./faqparse.pl < $< > $@

httpscript.gen: $(DOCROOT)/TheArtOfHttpScripting.md
	$(MARKDOWN) < $< > $@

httpscripting.html: _httpscripting.shtml $(MAINPARTS) httpscript.gen
	$(ACTION)

features.html: _features.html $(MAINPARTS) features.gen
	$(ACTION)

features.gen: $(DOCROOT)/FEATURES.md
	$(MARKDOWN) < $<  > $@

install.html: _install.html $(MAINPARTS) install.gen
	$(ACTION)

install.gen: $(DOCROOT)/INSTALL.md
	$(MARKDOWN) < $< > $@

manual.html: _manual.html $(MAINPARTS) manual.gen
	$(ACTION)

manual.gen: $(DOCROOT)/MANUAL.md
	$(MARKDOWN) < $< >$@

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

versions.gen: $(DOCROOT)/VERSIONS.md
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
	fcpp $(FCPP_OPTS) -DSEVERITY=0 -I$(ROOT) -WWW -Uunix -P -H -C -V -LL $< $@
security-m.html: _security.html seclist-m.gen $(MAINPARTS) $(ADVBOX)
	fcpp $(FCPP_OPTS) -DSEVERITY=1 -I$(ROOT) -WWW -Uunix -P -H -C -V -LL $< $@
security-h.html: _security.html seclist-h.gen $(MAINPARTS) $(ADVBOX)
	fcpp $(FCPP_OPTS) -DSEVERITY=2 -I$(ROOT) -WWW -Uunix -P -H -C -V -LL $< $@
security-c.html: _security.html seclist-c.gen $(MAINPARTS) $(ADVBOX)
	fcpp $(FCPP_OPTS) -DSEVERITY=3 -I$(ROOT) -WWW -Uunix -P -H -C -V -LL $< $@

seclist.gen: vuln.pm listvulns.pl vuln.pm $(CVELIST)
	./listvulns.pl low > seclist.gen
seclist-m.gen: vuln.pm listvulns.pl vuln.pm $(CVELIST)
	./listvulns.pl medium > seclist-m.gen
seclist-h.gen: vuln.pm listvulns.pl vuln.pm $(CVELIST)
	./listvulns.pl high > seclist-h.gen
seclist-c.gen: vuln.pm listvulns.pl vuln.pm $(CVELIST)
	./listvulns.pl critical > seclist-c.gen

CVE-%.html: CVE-%.md $(MAINPARTS) advisory.t $(ADVBOX) curlver-to-vulnlink.pl mk-adv-template.pl cve-checker.pl
	@perl cve-checker.pl $<
	$(MARKDOWN) < $< | perl curlver-to-vulnlink.pl | ./mk-adv-template.pl $@ | fcpp $(FCPP_OPTS) -I$(ROOT) -WWW -Uunix -P -H -C -V -LL - > $@

vulnerabilities.html: _vulnerabilities.html vuln.gen $(MAINPARTS)
	$(ACTION)
vulnall.html: _vulnall.html vuln0.gen $(MAINPARTS)
	$(ACTION)

vuln.gen: $(ROOT)/_changes.html ./vulntable.pl vuln.pm _singlevuln.templ
	./vulntable.pl 25 < $< > $@
vuln0.gen: $(ROOT)/_changes.html ./vulntable.pl vuln.pm _singlevuln.templ vuln.json
	./vulntable.pl < $< > $@

allvulns.gen: $(ROOT)/_changes.html ./allvulns.pl vuln.pm
	./allvulns.pl < $< > $@

vuln.csv: vuln.pm
	./vuln2csv.pl > $@

vuln.json: vuln.pm vuln2json.pl $(CVELIST) releases.csv
	./vuln2json.pl > $@

http2.gen: $(SRCROOT)/docs/HTTP2.md
	$(MARKDOWN) < $< > $@

http2.html: _http2.html http2.gen $(MAINPARTS)
	$(ACTION)

http3.gen: $(SRCROOT)/docs/HTTP3.md
	$(MARKDOWN) < $< > $@

http3.html: _http3.html http3.gen $(MAINPARTS)
	$(ACTION)

websocket.gen: $(SRCROOT)/docs/WEBSOCKET.md
	$(MARKDOWN) < $< > $@

websocket.html: _websocket.html websocket.gen $(MAINPARTS)
	$(ACTION)

mqtt.gen: $(SRCROOT)/docs/MQTT.md
	$(MARKDOWN) < $< > $@

mqtt.html: _mqtt.html mqtt.gen $(MAINPARTS)
	$(ACTION)

releases.html: _releases.html rel.gen $(MAINPARTS) $(ROOT)/release.t
	$(ACTION)

rel.gen: $(ROOT)/_changes.html ./relinfo.pl vuln.pm vuln0.gen
	./relinfo.pl < $< > $@

releases.csv: $(ROOT)/_changes.html ./relinfo.pl vuln.pm allvulns.gen
	./relinfo.pl --raw < $< > $@

thename.html: _thename.html $(MAINPARTS)
	$(ACTION)
