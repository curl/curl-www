ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
TESTROOT=$(SRCROOT)/tests
LIBROOT=$(SRCROOT)/lib
CURL= $(ROOT)

MAINPARTS= $(ROOT)/_doctype.html $(CURL)/_menu.html $(CURL)/_footer.html \
  $(CURL)/setup.t $(CURL)/pic.t $(CURL)/where.t $(CURL)/css.t \
  $(ROOT)/mirrorlinks.t topline.t $(ROOT)/ad.t _menu.html
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=echo preprocessing $@; \
 rm -f $@; \
 fcpp -I.. -I. -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@;
TXT2PLAIN = $(ROOT)/docs/txt2plain.pl
MAN2HTML = roffit --bare

PAGES = foot.html head.html loghead.html howto.html summary.html	     \
	cvshistory.html							     \
	missing.html keywords.html builds.html todo-release.html	     \
	release-notes.html index.html contribute.html internals.html	     \
	testcurl.html runtests.html source.html readme-ares.html	     \
	readme-curl_off_t.html readme-curlx.html readme-encoding.html	     \
	readme-hostip.html readme-httpauth.html readme-memoryleak.html	     \
	readme-multi_socket.html readme-pingpong.html readme-pipelining.html \
	readme-http2.html security.html

all: $(PAGES)

bugbox.t:
	perl rssbugs.pl > bugbox.t

index.html: _index.html bugbox.t $(MAINPARTS)
	$(ACTION)

source.html: _source.html $(MAINPARTS)
	$(ACTION)

testcurl.html: _testcurl.html $(MAINPARTS) testcurl.dump
	$(ACTION)
testcurl.dump: $(TESTROOT)/testcurl.1
	$(MAN2HTML) < $< > $@

runtests.html: _runtests.html $(MAINPARTS) runtests.dump
	$(ACTION)
runtests.dump: $(TESTROOT)/runtests.1
	$(MAN2HTML) < $< > $@

contribute.html: _contribute.html $(MAINPARTS) contribute.t
	$(ACTION)

contribute.t: $(DOCROOT)/CONTRIBUTE $(ROOT)/docs/faqparse.pl
	$(ROOT)/docs/faqparse.pl < $< > $@

internals.html: _internals.html $(MAINPARTS) internals.t
	$(ACTION)

internals.t: $(DOCROOT)/INTERNALS
	$(TXT2PLAIN) < $< > $@

security.html: _security.html $(MAINPARTS) security.t
	$(ACTION)

security.t: $(DOCROOT)/SECURITY
	$(TXT2PLAIN) < $< > $@

foot.html: _foot.html $(MAINPARTS)
	$(ACTION)

head.html: _head.html $(MAINPARTS)
	$(ACTION)

summary.html: _summary.html $(MAINPARTS) summary.t
	$(ACTION)

cvshistory.html: _cvshistory.html $(MAINPARTS) cvs.t
	$(ACTION)

missing.html: _missing.html $(MAINPARTS)
	$(ACTION)

release-notes.txt: $(SRCROOT)/RELEASE-NOTES
	$(TXT2PLAIN) < $< > $@

release-notes.html: _release-notes.html release-notes.txt $(MAINPARTS)
	$(ACTION)

todo-release.txt: $(SRCROOT)/TODO-RELEASE
	$(TXT2PLAIN) < $< > $@

todo-release.html: _todo-release.html todo-release.txt $(MAINPARTS)
	$(ACTION)

howto.html: _howto.html $(MAINPARTS) _head.html
	$(ACTION)

keywords.html: _keywords.html $(MAINPARTS) _head.html keywords.t
	$(ACTION)

loghead.html: _loghead.html $(MAINPARTS)
	$(ACTION)

builds.html: _builds.html $(MAINPARTS) table.t explainopts.t
	$(ACTION)

README.ares.dump: $(LIBROOT)/README.ares
	$(TXT2PLAIN) < $< > $@

readme-ares.html: _readme-ares.html README.ares.dump $(MAINPARTS)
	$(ACTION)

README.curl_off_t.dump: $(LIBROOT)/README.curl_off_t
	$(TXT2PLAIN) < $< > $@

readme-curl_off_t.html: _readme-curl_off_t.html README.curl_off_t.dump $(MAINPARTS)
	$(ACTION)

README.curlx.dump: $(LIBROOT)/README.curlx
	$(TXT2PLAIN) < $< > $@

readme-curlx.html: _readme-curlx.html README.curlx.dump $(MAINPARTS)
	$(ACTION)

README.encoding.dump: $(LIBROOT)/README.encoding
	$(TXT2PLAIN) < $< > $@

readme-encoding.html: _readme-encoding.html README.encoding.dump $(MAINPARTS)
	$(ACTION)

README.hostip.dump: $(LIBROOT)/README.hostip
	$(TXT2PLAIN) < $< > $@

readme-hostip.html: _readme-hostip.html README.hostip.dump $(MAINPARTS)
	$(ACTION)

README.httpauth.dump: $(LIBROOT)/README.httpauth
	$(TXT2PLAIN) < $< > $@

readme-httpauth.html: _readme-httpauth.html README.httpauth.dump $(MAINPARTS)
	$(ACTION)

README.http2.dump: $(LIBROOT)/README.http2
	$(TXT2PLAIN) < $< > $@

readme-http2.html: _readme-http2.html README.http2.dump $(MAINPARTS)
	$(ACTION)

README.memoryleak.dump: $(LIBROOT)/README.memoryleak
	$(TXT2PLAIN) < $< > $@

readme-memoryleak.html: _readme-memoryleak.html README.memoryleak.dump $(MAINPARTS)
	$(ACTION)

README.multi_socket.dump: $(LIBROOT)/README.multi_socket
	$(TXT2PLAIN) < $< > $@

readme-multi_socket.html: _readme-multi_socket.html README.multi_socket.dump $(MAINPARTS)
	$(ACTION)

README.pingpong.dump: $(LIBROOT)/README.pingpong
	$(TXT2PLAIN) < $< > $@

readme-pingpong.html: _readme-pingpong.html README.pingpong.dump $(MAINPARTS)
	$(ACTION)

README.pipelining.dump: $(LIBROOT)/README.pipelining
	$(TXT2PLAIN) < $< > $@

readme-pipelining.html: _readme-pipelining.html README.pipelining.dump $(MAINPARTS)
	$(ACTION)

full: all

clean:
	rm -f $(PAGES)
