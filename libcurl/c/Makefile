
CURL= ../..

SRCROOT=$(CURL)/cvssource
DOCROOT=$(SRCROOT)/docs

MAINPARTS= $(CURL)/_doctype.html _menu.html ../../_footer.html ../setup.t ../pic.t doclinks.t $(CURL)/where.t ../download.t $(CURL)/ad.t
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; rm -f $@; cpp -I.. -I. -I$(CURL) -WWW -Uunix -H -C -V -LL "$(NOW)" $< $@; chmod a-w+r $@

TXT2HTML= txt2html --extract --hrule 10
MAN2HTML= man2html | sed -e 's/^$$/\&nbsp;/g' -e 's/\#/\&\#35\;/g' | uniq
TXT2PLAIN = txt2plain.pl

all: index.shtml example.shtml curl_easy_init.html \
	curl_easy_cleanup.html curl_easy_setopt.html \
	curl_easy_perform.html curl_version.html curl_getenv.html \
	curl_slist_append.html curl_slist_free_all.html \
	curl_formadd.html \
	curl_formparse.html curl_getdate.html curl_easy_getinfo.html \
	curl_formfree.html curl_escape.html curl_unescape.html \
	curl_strequal.html curl_mprintf.html libcurl.html \
	curl_global_init.html curl_global_cleanup.html \
	the-guide.html
	cd html; make

index.shtml: _index.html $(MAINPARTS)
	$(ACTION)

example.shtml: _example.html $(MAINPARTS) tinytest.html tinytest2.html curlgtk.html
	$(ACTION)

curl_easy_init.html: _curl_easy_init.html $(MAINPARTS) curl_easy_init.t
	$(ACTION)

curl_easy_init.t: $(DOCROOT)/curl_easy_init.3
	gnroff -man $(DOCROOT)/curl_easy_init.3 | $(MAN2HTML) >curl_easy_init.t

curl_easy_perform.html: _curl_easy_perform.html $(MAINPARTS) curl_easy_perform.t
	$(ACTION)

curl_easy_perform.t: $(DOCROOT)/curl_easy_perform.3
	gnroff -man $(DOCROOT)/curl_easy_perform.3 | $(MAN2HTML) >curl_easy_perform.t


curl_easy_cleanup.html: _curl_easy_cleanup.html $(MAINPARTS) curl_easy_cleanup.t
	$(ACTION)

curl_easy_cleanup.t: $(DOCROOT)/curl_easy_cleanup.3
	gnroff -man $(DOCROOT)/curl_easy_cleanup.3 | $(MAN2HTML) >curl_easy_cleanup.t


curl_easy_setopt.html: _curl_easy_setopt.html $(MAINPARTS) curl_easy_setopt.t
	$(ACTION)

curl_easy_setopt.t: $(DOCROOT)/curl_easy_setopt.3
	gnroff -man $< | $(MAN2HTML) >$@


curl_easy_getinfo.html: _curl_easy_getinfo.html $(MAINPARTS) curl_easy_getinfo.t
	$(ACTION)

curl_easy_getinfo.t: $(DOCROOT)/curl_easy_getinfo.3
	gnroff -man $< | $(MAN2HTML) >$@


curl_version.html: _curl_version.html $(MAINPARTS) curl_version.t
	$(ACTION)
curl_version.t: $(DOCROOT)/curl_version.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_escape.html: _curl_escape.html $(MAINPARTS) curl_escape.t
	$(ACTION)
curl_escape.t: $(DOCROOT)/curl_escape.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_unescape.html: _curl_unescape.html $(MAINPARTS) curl_unescape.t
	$(ACTION)
curl_unescape.t: $(DOCROOT)/curl_unescape.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_getenv.html: _curl_getenv.html $(MAINPARTS) curl_getenv.t
	$(ACTION)
curl_getenv.t: $(DOCROOT)/curl_getenv.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_getdate.html: _curl_getdate.html $(MAINPARTS) curl_getdate.t
	$(ACTION)
curl_getdate.t: $(DOCROOT)/curl_getdate.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_strequal.html: _curl_strequal.html $(MAINPARTS) curl_strequal.t
	$(ACTION)
curl_strequal.t: $(DOCROOT)/curl_strequal.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_mprintf.html: _curl_mprintf.html $(MAINPARTS) curl_mprintf.t
	$(ACTION)
curl_mprintf.t: $(DOCROOT)/curl_mprintf.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_formparse.html: _curl_formparse.html $(MAINPARTS) curl_formparse.t
	$(ACTION)
curl_formparse.t: $(DOCROOT)/curl_formparse.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_formadd.html: _curl_formadd.html $(MAINPARTS) curl_formadd.t
	$(ACTION)
curl_formadd.t: $(DOCROOT)/curl_formadd.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_formfree.html: _curl_formfree.html $(MAINPARTS) curl_formfree.t
	$(ACTION)
curl_formfree.t: $(DOCROOT)/curl_formfree.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_global_init.html: _curl_global_init.html $(MAINPARTS) curl_global_init.t
	$(ACTION)
curl_global_init.t: $(DOCROOT)/curl_global_init.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_global_cleanup.html: _curl_global_cleanup.html $(MAINPARTS) curl_global_cleanup.t
	$(ACTION)
curl_global_cleanup.t: $(DOCROOT)/curl_global_cleanup.3
	gnroff -man $< | $(MAN2HTML) >$@

libcurl.html: _libcurl.html $(MAINPARTS) libcurl.t
	$(ACTION)
libcurl.t: $(DOCROOT)/libcurl.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_slist_append.html: _curl_slist_append.html $(MAINPARTS) curl_slist_append.t
	$(ACTION)
curl_slist_append.t: $(DOCROOT)/curl_slist_append.3
	gnroff -man $< | $(MAN2HTML) >$@

curl_slist_free_all.html: _curl_slist_free_all.html $(MAINPARTS) curl_slist_free_all.t
	$(ACTION)
curl_slist_free_all.t: $(DOCROOT)/curl_slist_free_all.3
	gnroff -man $< | $(MAN2HTML) >$@

tinytest.html: tinytest.c
	$(TXT2PLAIN) < $< > $@

tinytest2.html: tinytest2.c
	$(TXT2PLAIN) < $< > $@

curlgtk.html: curlgtk.c
	$(TXT2PLAIN) < $< > $@

the-guide.html: _the-guide.html the-guide.t $(MAINPARTS)
	$(ACTION)

the-guide.t: $(DOCROOT)/libcurl-the-guide
	$(TXT2PLAIN) < $< > $@


full: all

