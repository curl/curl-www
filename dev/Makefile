ROOT = ..

SRCROOT=$(ROOT)/cvssource
DOCROOT=$(SRCROOT)/docs
TESTROOT=$(SRCROOT)/tests
LIBROOT=$(SRCROOT)/lib
CURL= $(ROOT)

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html
MKRELNOTES = ./mk-release-notes.pl
MAN2HTML = roffit --bare

PAGES = foot.html head.html howto.html summary.html cvshistory.html	\
	missing.html keywords.html builds.html release-notes.html	\
	index.html contribute.html internals.html testcurl.html		\
	runtests.html source.html secprocess.html roadmap.html		\
	sourceactivity.html release-procedure.html code-style.html      \
        deprecate.html

all: $(PAGES)

index.html: _index.html bugbox.t $(MAINPARTS) ../release.t
	$(ACTION)

source.html: _source.html $(MAINPARTS)
	$(ACTION)

roadmap.html: _roadmap.html roadmap.gen $(MAINPARTS)
	$(ACTION)
roadmap.gen: $(SRCROOT)/docs/ROADMAP.md
	$(MARKDOWN) < $< > $@

code-style.html: _code-style.html code-style.gen $(MAINPARTS)
	$(ACTION)
code-style.gen: $(SRCROOT)/docs/CODE_STYLE.md
	$(GITHUB) $< | sed -e 's:*:\&#42;:g' -e 's:#undef:\&#35;undef:g' \
	-e 's:#define:\&#35;define:g' \
	-e 's:#else:\&#35;else:g' \
	-e 's:#endif:\&#35;endif:g' \
	-e 's:#ifdef:\&#35;ifdef:g' > $@

testcurl.html: _testcurl.html $(MAINPARTS) testcurl.gen
	$(ACTION)
testcurl.gen: $(TESTROOT)/testcurl.1
	$(MAN2HTML) < $< > $@

runtests.html: _runtests.html $(MAINPARTS) runtests.gen
	$(ACTION)
runtests.gen: $(TESTROOT)/runtests.1
	$(MAN2HTML) < $< > $@

contribute.html: _contribute.html $(MAINPARTS) contribute.gen
	$(ACTION)
contribute.gen: $(DOCROOT)/CONTRIBUTE.md
	$(MARKDOWN) < $< > $@

deprecate.html: _deprecate.html $(MAINPARTS) deprecate.gen
	$(ACTION)
deprecate.gen: $(DOCROOT)/DEPRECATE.md
	$(MARKDOWN) < $< > $@

internals.html: _internals.html $(MAINPARTS) internals.gen
	$(ACTION)
internals.gen: $(DOCROOT)/INTERNALS.md
	$(MARKDOWN) < $< > $@

secprocess.html: _security.html $(MAINPARTS) security.gen
	$(ACTION)
security.gen: $(DOCROOT)/SECURITY-PROCESS.md
	$(MARKDOWN) < $< > $@

foot.html: _foot.html $(MAINPARTS)
	$(ACTION)

head.html: _head.html $(MAINPARTS)
	$(ACTION)

summary.html: _summary.html $(MAINPARTS) summary.t
	$(ACTION)

cvshistory.html: _sourceactivity.html $(MAINPARTS) cvs.t
	$(ACTION)

sourceactivity.html: _sourceactivity.html $(MAINPARTS) cvs.t
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
