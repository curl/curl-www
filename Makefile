MAINPARTS= _doctype.html _menu.html _footer.html setup.t pic.t where.t	\
libcurl/_links.html ad.t mirrorlinks.t searchform.t css.t sflogo.t

# today's date
NOW=$(shell gnudate +'-D__TODAY__=%B %d, %Y')

# the latest stable version is:
STABLE= 7.10.4
RELDATE = "2nd of April 2003"

# name of the dir to tempoary unpack and build zip files in:
TEMPDIR=tempzip

# generated file with binary package stats
STAT = packstat.t

# generated file with release info (STABLE and RELDATE)
RELEASE = release.t

ACTION=@echo preprocessing $@; \
       rm -f $@; \
       cpp -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; \
       chmod a-w+r $@

all: index.html \
	feedback.html mirrors.html cvs.html libs.html icons.html \
	help.html curlprograms.html download.html changes.html \
	version7.html bugreport.html about.html support.html \
	newslog.html news.html head.html foot.html press.html \
	oldnews.html indexheader.html indexfooter.html \
	mailheader.html mailfooter.html info web-editing.html \
	donation.html devel.html
	cd docs; make
	cd libcurl; make
	cd mail; make
	cd mirror; make
	cd legal; make
	cd package; make
	@echo done 
#archive/index.html

check:
	cd htdig; make
	cd /home/dast/htdig/common; make

head.html: _head.html $(MAINPARTS)
	$(ACTION)

donation.html: _donation.html $(MAINPARTS)
	$(ACTION)

version7.html: _version7.html $(MAINPARTS)
	$(ACTION)

web-editing.html: _web-editing.html $(MAINPARTS)
	$(ACTION)

foot.html: _foot.html $(MAINPARTS)
	$(ACTION)

main.html: _main.html $(MAINPARTS) $(STAT)
	$(ACTION)

index.html: main.html newslog.html
	rm -f $@
	./filter.pl < $< > $@

newslog.html: _newslog.html $(MAINPARTS)
	$(ACTION)

press.html: _press.html $(MAINPARTS)
	$(ACTION)

news2.html: _news2.html $(MAINPARTS)
	$(ACTION)

news.html: news2.html newslog.html
	rm -f $@
	./filter.pl < $< > $@

olddata.html: _oldnews.html $(MAINPARTS)
	$(ACTION)

oldnews.html: olddata.html
	rm -f $@
	./filter.pl < $< > $@

info: _info packstat.t
	$(ACTION)

$(RELEASE): Makefile
	@echo "fixing $(RELEASE)"
	@echo "#define __STABLE $(STABLE)" >>$(RELEASE)
	@echo "#define __RELDATE $(RELDATE)" >>$(RELEASE)

$(STAT): download.html Makefile
	@echo "fixing $(STAT)"
	@echo "#define __CURR `grep -c class=.latest $<`" >$(STAT)
	@echo "#define __PACKS `grep -c \"^<tr c\" $<`" >>$(STAT)

download.html: _download.html $(MAINPARTS) $(RELEASE) dl/files.html
	$(ACTION)

changes.html: _changes.html $(MAINPARTS)
	$(ACTION)

devel.html: _devel.html $(MAINPARTS)
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
	cd download; ls -1 *curl* >curldist.txt;
	@echo done

clean:
	rm -f *~
