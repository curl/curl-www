
HTMLDIR=..

CONTENTS = $(HTMLDIR)/curl_easy_cleanup.t \
	   $(HTMLDIR)/curl_formparse.t \
	   $(HTMLDIR)/curl_formfree.t \
	   $(HTMLDIR)/curl_version.t \
	   $(HTMLDIR)/curl_escape.t \
	   $(HTMLDIR)/curl_unescape.t \
	   $(HTMLDIR)/curl_easy_getinfo.t \
	   $(HTMLDIR)/curl_getdate.t  \
	   $(HTMLDIR)/curl_easy_init.t \
	   $(HTMLDIR)/curl_getenv.t \
	   $(HTMLDIR)/curl_easy_perform.t \
	   $(HTMLDIR)/curl_slist_append.t \
	   $(HTMLDIR)/curl_easy_setopt.t \
	   $(HTMLDIR)/curl_slist_free_all.t \
	   $(HTMLDIR)/curl_strequal.t \
	   $(HTMLDIR)/curl_mprintf.t \
	   $(HTMLDIR)/curl_global_init.t \
	   $(HTMLDIR)/curl_global_cleanup.t \
	   $(HTMLDIR)/libcurl.t \
	   $(HTMLDIR)/curl_multi_add_handle.t \
	   $(HTMLDIR)/curl_multi_init.t \
	   $(HTMLDIR)/curl_multi_cleanup.t \
	   $(HTMLDIR)/curl_multi_perform.t \
	   $(HTMLDIR)/curl_multi_fdset.t \
	   $(HTMLDIR)/curl_multi_remove_handle.t \
	   $(HTMLDIR)/curl_multi_info_read.t \
	   $(HTMLDIR)/libcurl-multi.t \
	   $(HTMLDIR)/libcurl-errors.t


curl-html-docs.tar.gz: $(CONTENTS)
	rm -f $@
	cp -p $(CONTENTS) .
	./build.pl *.t
