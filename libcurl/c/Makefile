
CURL= ../..

SRCROOT=$(CURL)/cvssource
DOCROOT=$(SRCROOT)/docs
MANROOT=$(DOCROOT)/libcurl

MAINPARTS= $(CURL)/_doctype.html _menu.html $(CURL)/_footer.html ../setup.t \
../pic.t doclinks.t $(CURL)/where.t ../download.t $(CURL)/ad.t Makefile	    \
$(CURL)/mirrorlinks.t $(CURL)/searchform.t $(CURL)/css.t $(CURL)/sflogo.t \
manpage.t

NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')
ACTION=@echo preprocessing $@; \
       rm -f $@; \
       cpp -I.. -I. -I$(CURL) -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; \
       chmod a-w+r $@

TXT2HTML= txt2html --extract --hrule 10
MAN2HTML= roffit --bare --mandir=$(MANROOT)
TXT2PLAIN = txt2plain.pl

PAGES = index.html example.html curl_easy_init.html			\
	curl_easy_cleanup.html curl_easy_setopt.html			\
	curl_easy_perform.html curl_version.html curl_version_info.html	\
        curl_getenv.html curl_free.html					\
	curl_slist_append.html curl_slist_free_all.html			\
	curl_formadd.html curl_formparse.html  				\
	curl_getdate.html curl_easy_getinfo.html			\
	curl_formfree.html curl_escape.html curl_unescape.html		\
	curl_strequal.html curl_mprintf.html libcurl.html		\
	curl_global_init.html curl_global_cleanup.html			\
	the-guide.html libcurl-errors.html				\
	curl_multi_add_handle.html     curl_multi_init.html		\
	curl_multi_cleanup.html        curl_multi_perform.html		\
	curl_multi_fdset.html          curl_multi_remove_handle.html	\
	curl_multi_info_read.html      libcurl-multi.html \
	libcurl-easy.html libcurl-share.html allfuncs.html \
	curl_share_cleanup.html curl_share_init.html \
	curl_share_setopt.html curl_easy_duphandle.html

all: $(PAGES)

clean:
	 rm -f $(PAGES) curl_*.t

index.html: _index.html $(MAINPARTS)
	$(ACTION)

example.html: _example.html $(MAINPARTS) tinytest.html tinytest2.html curlgtk.html
	$(ACTION)

allfuncs.html: _allfuncs.html $(MAINPARTS)
	$(ACTION)

curl_easy_init.html: _curl_easy_init.html $(MAINPARTS) curl_easy_init.t
	$(ACTION)
curl_easy_init.t: $(MANROOT)/curl_easy_init.3
	$(MAN2HTML) < $< >$@

curl_easy_duphandle.html: _curl_easy_duphandle.html $(MAINPARTS) curl_easy_duphandle.t
	$(ACTION)
curl_easy_duphandle.t: $(MANROOT)/curl_easy_duphandle.3
	$(MAN2HTML) < $< >$@

curl_easy_perform.html: _curl_easy_perform.html $(MAINPARTS) curl_easy_perform.t
	$(ACTION)
curl_easy_perform.t: $(MANROOT)/curl_easy_perform.3
	$(MAN2HTML) < $< >$@


curl_easy_cleanup.html: _curl_easy_cleanup.html $(MAINPARTS) curl_easy_cleanup.t
	$(ACTION)
curl_easy_cleanup.t: $(MANROOT)/curl_easy_cleanup.3
	$(MAN2HTML) < $< >$@


curl_easy_setopt.html: _curl_easy_setopt.html $(MAINPARTS) curl_easy_setopt.t
	$(ACTION)
curl_easy_setopt.t: $(MANROOT)/curl_easy_setopt.3
	$(MAN2HTML) < $< >$@


curl_easy_getinfo.html: _curl_easy_getinfo.html $(MAINPARTS) curl_easy_getinfo.t
	$(ACTION)
curl_easy_getinfo.t: $(MANROOT)/curl_easy_getinfo.3
	$(MAN2HTML) < $< >$@

curl_version.html: _curl_version.html $(MAINPARTS) curl_version.t
	$(ACTION)
curl_version.t: $(MANROOT)/curl_version.3
	$(MAN2HTML) < $< >$@

curl_version_info.html: _curl_version_info.html $(MAINPARTS) curl_version_info.t
	$(ACTION)
curl_version_info.t: $(MANROOT)/curl_version_info.3
	$(MAN2HTML) < $< >$@

curl_free.html: _curl_free.html $(MAINPARTS) curl_free.t
	$(ACTION)
curl_free.t: $(MANROOT)/curl_free.3
	$(MAN2HTML) < $< >$@

curl_escape.html: _curl_escape.html $(MAINPARTS) curl_escape.t
	$(ACTION)
curl_escape.t: $(MANROOT)/curl_escape.3
	$(MAN2HTML) < $< >$@

curl_unescape.html: _curl_unescape.html $(MAINPARTS) curl_unescape.t
	$(ACTION)
curl_unescape.t: $(MANROOT)/curl_unescape.3
	$(MAN2HTML) < $< >$@

curl_getenv.html: _curl_getenv.html $(MAINPARTS) curl_getenv.t
	$(ACTION)
curl_getenv.t: $(MANROOT)/curl_getenv.3
	$(MAN2HTML) < $< >$@

curl_getdate.html: _curl_getdate.html $(MAINPARTS) curl_getdate.t
	$(ACTION)
curl_getdate.t: $(MANROOT)/curl_getdate.3
	$(MAN2HTML) < $< >$@

curl_strequal.html: _curl_strequal.html $(MAINPARTS) curl_strequal.t
	$(ACTION)
curl_strequal.t: $(MANROOT)/curl_strequal.3
	$(MAN2HTML) < $< >$@

curl_mprintf.html: _curl_mprintf.html $(MAINPARTS) curl_mprintf.t
	$(ACTION)
curl_mprintf.t: $(MANROOT)/curl_mprintf.3
	$(MAN2HTML) < $< >$@

curl_formadd.html: _curl_formadd.html $(MAINPARTS) curl_formadd.t
	$(ACTION)
curl_formadd.t: $(MANROOT)/curl_formadd.3
	$(MAN2HTML) < $< >$@

curl_formparse.html: _curl_formparse.html $(MAINPARTS) curl_formparse.t
	$(ACTION)
curl_formparse.t: $(MANROOT)/curl_formparse.3
	$(MAN2HTML) < $< >$@

curl_formfree.html: _curl_formfree.html $(MAINPARTS) curl_formfree.t
	$(ACTION)
curl_formfree.t: $(MANROOT)/curl_formfree.3
	$(MAN2HTML) < $< >$@

curl_global_init.html: _curl_global_init.html $(MAINPARTS) curl_global_init.t
	$(ACTION)
curl_global_init.t: $(MANROOT)/curl_global_init.3
	$(MAN2HTML) < $< >$@

curl_global_cleanup.html: _curl_global_cleanup.html $(MAINPARTS) curl_global_cleanup.t
	$(ACTION)
curl_global_cleanup.t: $(MANROOT)/curl_global_cleanup.3
	$(MAN2HTML) < $< >$@

libcurl.html: _libcurl.html $(MAINPARTS) libcurl.t
	$(ACTION)
libcurl.t: $(MANROOT)/libcurl.3
	$(MAN2HTML) < $< >$@

curl_slist_append.html: _curl_slist_append.html $(MAINPARTS) curl_slist_append.t
	$(ACTION)
curl_slist_append.t: $(MANROOT)/curl_slist_append.3
	$(MAN2HTML) < $< >$@

curl_slist_free_all.html: _curl_slist_free_all.html $(MAINPARTS) curl_slist_free_all.t
	$(ACTION)
curl_slist_free_all.t: $(MANROOT)/curl_slist_free_all.3
	$(MAN2HTML) < $< >$@

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

libcurl-multi.html: _libcurl-multi.html $(MAINPARTS) libcurl-multi.t
	$(ACTION)
libcurl-multi.t: $(MANROOT)/libcurl-multi.3
	$(MAN2HTML) < $< >$@

libcurl-easy.html: _libcurl-easy.html $(MAINPARTS) libcurl-easy.t
	$(ACTION)
libcurl-easy.t: $(MANROOT)/libcurl-easy.3
	$(MAN2HTML) < $< >$@

libcurl-share.html: _libcurl-share.html $(MAINPARTS) libcurl-share.t
	$(ACTION)
libcurl-share.t: $(MANROOT)/libcurl-share.3
	$(MAN2HTML) < $< >$@

libcurl-errors.html: _libcurl-errors.html $(MAINPARTS) libcurl-errors.t
	$(ACTION)
libcurl-errors.t: $(MANROOT)/libcurl-errors.3
	$(MAN2HTML) < $< >$@

curl_multi_add_handle.html: _curl_multi_add_handle.html $(MAINPARTS) curl_multi_add_handle.t
	$(ACTION)
curl_multi_add_handle.t: $(MANROOT)/curl_multi_add_handle.3
	$(MAN2HTML) < $< >$@

curl_multi_cleanup.html: _curl_multi_cleanup.html $(MAINPARTS) curl_multi_cleanup.t
	$(ACTION)
curl_multi_cleanup.t: $(MANROOT)/curl_multi_cleanup.3
	$(MAN2HTML) < $< >$@

curl_multi_fdset.html: _curl_multi_fdset.html $(MAINPARTS) curl_multi_fdset.t
	$(ACTION)
curl_multi_fdset.t: $(MANROOT)/curl_multi_fdset.3
	$(MAN2HTML) < $< >$@

curl_multi_info_read.html: _curl_multi_info_read.html $(MAINPARTS) curl_multi_info_read.t
	$(ACTION)
curl_multi_info_read.t: $(MANROOT)/curl_multi_info_read.3
	$(MAN2HTML) < $< >$@

curl_multi_init.html: _curl_multi_init.html $(MAINPARTS) curl_multi_init.t
	$(ACTION)
curl_multi_init.t: $(MANROOT)/curl_multi_init.3
	$(MAN2HTML) < $< >$@

curl_multi_perform.html: _curl_multi_perform.html $(MAINPARTS) curl_multi_perform.t
	$(ACTION)
curl_multi_perform.t: $(MANROOT)/curl_multi_perform.3
	$(MAN2HTML) < $< >$@

curl_multi_remove_handle.html: _curl_multi_remove_handle.html $(MAINPARTS) curl_multi_remove_handle.t
	$(ACTION)
curl_multi_remove_handle.t: $(MANROOT)/curl_multi_remove_handle.3
	$(MAN2HTML) < $< >$@

curl_share_cleanup.html: _curl_share_cleanup.html $(MAINPARTS) curl_share_cleanup.t
	$(ACTION)
curl_share_cleanup.t: $(MANROOT)/curl_share_cleanup.3
	$(MAN2HTML) < $< >$@

curl_share_init.html: _curl_share_init.html $(MAINPARTS) curl_share_init.t
	$(ACTION)
curl_share_init.t: $(MANROOT)/curl_share_init.3
	$(MAN2HTML) < $< >$@

curl_share_setopt.html: _curl_share_setopt.html $(MAINPARTS) curl_share_setopt.t
	$(ACTION)
curl_share_setopt.t: $(MANROOT)/curl_share_setopt.3
	$(MAN2HTML) < $< >$@

full: all

