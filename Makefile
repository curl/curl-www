MAINPARTS= _doctype.html _menu.html _footer.html setup.t pic.t where.t libcurl/_links.html

# today's date
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')

# the latest stable version is:
STABLE= 7.8.1
RELDATE = "20th of August 2001"
RELSIZE = "562980 bytes"
BZ2SIZE = "429624 bytes"
ZIPSIZE = "709477 bytes"

# name of the dir to tempoary unpack and build zip files in:
TEMPDIR=tempzip

# generated file with binary package stats
STAT = packstat.t

ACTION=@echo preprocessing $@; \
       rm -f $@; \
       cpp -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; \
       chmod a-w+r $@

all: index.shtml feedback.html mirrors.html cvs.html libs.html icons.html \
	help.html curlprograms.html download.html changes.html \
	version7.html bugreport.html about.html support.html \
	news.html news.shtml head.html foot.html \
	oldnews.shtml indexheader.html indexfooter.html \
	mailheader.html mailfooter.html info web-editing.html \
	latest.shtml
	cd docs; make
	cd libcurl; make
	cd mail; make
	cd mirror; make
	cd legal; make
	@echo done 
#archive/index.html

check: download/curl-$(STABLE).tar.bz2 download/curl-$(STABLE).zip 
	cd htdig; make
	cd /home/dast/htdig/common; make

download/curl-$(STABLE).tar.bz2: download/curl-$(STABLE).tar.gz
	gzip -dc $< | bzip2 - > $@

download/curl-$(STABLE).zip: download/curl-$(STABLE).tar.gz
	(rm -rf $(TEMPDIR); \
	mkdir $(TEMPDIR); \
	cd $(TEMPDIR); \
	gzip -dc ../$< | tar -xf -; \
	find . | zip out -@; \
	mv out.zip ../$@; \
	cd ..; \
	rm -rf $(TEMPDIR) )

head.html: _head.html $(MAINPARTS)
	$(ACTION)

version7.html: _version7.html $(MAINPARTS)
	$(ACTION)

web-editing.html: _web-editing.html $(MAINPARTS)
	$(ACTION)

foot.html: _foot.html $(MAINPARTS)
	$(ACTION)

index.shtml: _main.html $(MAINPARTS) $(STAT)
	$(ACTION)

news.html: _news.html $(MAINPARTS)
	$(ACTION)

news.shtml: _news2.html $(MAINPARTS)
	$(ACTION)

#oldnews.html: _oldnews.html $(MAINPARTS)
#	$(ACTION)

oldnews.shtml: _oldnews2.html $(MAINPARTS)
	$(ACTION)

info: _info packstat.t
	$(ACTION)

packstat.t: _download.html Makefile
	@echo "fixing $(STAT)"
	@echo "#define __CURR `grep -c \"^TRCURRENT\" $<`" >$(STAT)
	@echo "#define __NCURR `grep -c \"^TRNCURRENT\" $<`" >>$(STAT)
	@echo "#define __PACKS `egrep -c \"^TR(N|)CURRENT\" $<`" >>$(STAT)
	@echo "#define __STABLE $(STABLE)" >>$(STAT)
	@echo "#define __RELDATE $(RELDATE)" >>$(STAT)
	@echo "#define __RELSIZE $(RELSIZE)" >>$(STAT)
	@echo "#define __BZ2SIZE $(BZ2SIZE)" >>$(STAT)
	@echo "#define __ZIPSIZE $(ZIPSIZE)" >>$(STAT)

download.html: _download.html $(MAINPARTS) packstat.t
	$(ACTION)

changes.html: _changes.html $(MAINPARTS)
	$(ACTION)

cvs.html: _cvs.html $(MAINPARTS)
	$(ACTION)

help.html: _help.html $(MAINPARTS)
	$(ACTION)

bugreport.html: _bugreport.html $(MAINPARTS)
	$(ACTION)

curlprograms.html: _curlprograms.html $(MAINPARTS)
	$(ACTION)

mirrors.html: _mirrors.html $(MAINPARTS) mirrors.t
	$(ACTION)

icons.html: _icons.html $(MAINPARTS)
	$(ACTION)

about.html: _about.html $(MAINPARTS)
	$(ACTION)

feedback.html: _feedback.html $(MAINPARTS)
	$(ACTION)

libs.html: _libs.html $(MAINPARTS)
	$(ACTION)

latest.shtml: _latest.shtml $(MAINPARTS)
	$(ACTION)

indexheader.html: _indexheader.html $(MAINPARTS)
	$(ACTION)

indexfooter.html: _indexfooter.html $(MAINPARTS)
	$(ACTION)

mailheader.html: _mailheader.html $(MAINPARTS)
	$(ACTION)

mailfooter.html: _mailfooter.html $(MAINPARTS)
	$(ACTION)

infolxr.html: _infolxr.html $(MAINPARTS)
	$(ACTION)

support.html: _support.html $(MAINPARTS)
	$(ACTION)

#archive/index.html: mail
#	./fixit

full: all
	@cd libcurl; make

release:
	cd stuff; ls -1 *curl* >curldist.txt;
	@echo done

clean:
	rm -f *~
