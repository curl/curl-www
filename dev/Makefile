ROOT=..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
INTERNALS=$(DOCROOT)/internals
TESTROOT=$(SRCROOT)/tests
LIBROOT=$(SRCROOT)/lib
CURL=$(ROOT)

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html
MKRELNOTES = ./mk-release-notes.pl
MAN2HTML = roffit --bare

PAGES =			\
 advisory.html		\
 builds.html		\
 code-review.html	\
 code-style.html	\
 contribute.html	\
 deprecate.html		\
 feature-window.html	\
 foot.html		\
 head.html		\
 howto.html		\
 index.html		\
 internals.html		\
 keywords.html		\
 missing.html		\
 new-protocol.html	\
 release-notes.html	\
 release-procedure.html	\
 roadmap.html		\
 runtests.html		\
 source.html		\
 sourceactivity.html	\
 summary.html		\
 test-fileformat.html	\
 testcurl.html		\
 tests-overview.html    \
 vuln-disclosure.html

all: $(PAGES)

index.html: _index.html $(MAINPARTS) ../release.t featurewindow.t
	$(ACTION)

feature-window.html: _feature-window.html $(MAINPARTS) featurewindow.t
	$(ACTION)

new-protocol.html: _new-protocol.html $(MAINPARTS) new-protocol.gen
	$(ACTION)
new-protocol.gen: $(INTERNALS)/NEW-PROTOCOL.md
	$(MARKDOWN) < $< > $@

test-fileformat.html: _test-fileformat.html $(MAINPARTS) fileformat.gen
	$(ACTION)
fileformat.gen: $(DOCROOT)/tests/FILEFORMAT.md
	$(MARKDOWN) < $< > $@

tests-overview.html: _tests-overview.html $(MAINPARTS) testsoverview.gen
	$(ACTION)
testsoverview.gen: $(DOCROOT)/tests/TEST-SUITE.md
	$(MARKDOWN) < $< > $@

source.html: _source.html $(MAINPARTS)
	$(ACTION)

roadmap.html: _roadmap.html roadmap.gen $(MAINPARTS)
	$(ACTION)
roadmap.gen: $(SRCROOT)/docs/ROADMAP.md
	$(MARKDOWN) < $< > $@

code-style.html: _code-style.html code-style.gen $(MAINPARTS)
	$(ACTION)
code-style.gen: $(INTERNALS)/CODE_STYLE.md
	$(GITHUB) $< | sed -e 's:*:\&#42;:g' -e 's:#undef:\&#35;undef:g' \
	-e 's:#define:\&#35;define:g' \
	-e 's:#else:\&#35;else:g' \
	-e 's:#endif:\&#35;endif:g' \
	-e 's:#ifdef:\&#35;ifdef:g' > $@

testcurl.html: _testcurl.html $(MAINPARTS) testcurl.gen
	$(ACTION)
testcurl.gen: $(DOCROOT)/testcurl.md
	$(MARKDOWN) < $< > $@

runtests.html: _runtests.html $(MAINPARTS) runtests.gen
	$(ACTION)
runtests.gen: $(DOCROOT)/runtests.md
	$(MARKDOWN) < $< > $@

code-review.html: _code-review.html $(MAINPARTS) code-review.gen
	$(ACTION)
code-review.gen: $(DOCROOT)/CODE_REVIEW.md
	$(MARKDOWN) < $< > $@

contribute.html: _contribute.html $(MAINPARTS) contribute.gen
	$(ACTION)
contribute.gen: $(DOCROOT)/CONTRIBUTE.md
	$(GITHUB) $< > $@

deprecate.html: _deprecate.html $(MAINPARTS) deprecate.gen
	$(ACTION)
deprecate.gen: $(DOCROOT)/DEPRECATE.md
	$(MARKDOWN) < $< > $@

internals.html: _internals.html $(MAINPARTS) internals.gen
	$(ACTION)
internals.gen: $(DOCROOT)/INTERNALS.md
	$(MARKDOWN) < $< > $@

vuln-disclosure.html: _vuln-disclosure.html $(MAINPARTS) disclosure.gen
	$(ACTION)
disclosure.gen: $(DOCROOT)/VULN-DISCLOSURE-POLICY.md
	$(MARKDOWN) < $< > $@

advisory.html: _advisory.html $(MAINPARTS) advisory.gen
	$(ACTION)
advisory.gen: $(DOCROOT)/SECURITY-ADVISORY.md
	$(MARKDOWN) < $< > $@

foot.html: _foot.html $(MAINPARTS)
	$(ACTION)

head.html: _head.html $(MAINPARTS)
	$(ACTION)

summary.html: _summary.html $(MAINPARTS) summary.t
	$(ACTION)

sourceactivity.html: _sourceactivity.html $(MAINPARTS)
	$(ACTION)

missing.html: _missing.html $(MAINPARTS)
	$(ACTION)

release-notes.gen: $(SRCROOT)/RELEASE-NOTES $(MKRELNOTES) $(ROOT)/release.t
	$(MKRELNOTES) < $< > $@

release-notes.html: _release-notes.html release-notes.gen $(MAINPARTS)
	$(ACTION)

release-procedure.gen: $(DOCROOT)/RELEASE-PROCEDURE.md
	$(MARKDOWN) < $< > $@

release-procedure.html: _release-procedure.html release-procedure.gen $(MAINPARTS)
	$(ACTION)

howto.html: _howto.html $(MAINPARTS) _head.html
	$(ACTION)

keywords.html: _keywords.html $(MAINPARTS) _head.html keywords.txt
	$(ACTION)

builds.html: _builds.html $(MAINPARTS) table.t explainopts.t
	$(ACTION)

full: all

clean:
	rm -f $(PAGES)
