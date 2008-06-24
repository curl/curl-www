MAINPARTS= _doctype.html _menu.html _footer.html setup.t pic.t where.t	\
libcurl/_links.html ad.t mirrorlinks.t css.t sflogo.html textlinks.t

# today's date
NOW=$(shell gnudate +'-D__TODAY__=%B %e, %Y')

# the latest stable version is:
STABLE= 7.18.2
RELDATE = "4th of June 2008"

# name of the dir to tempoary unpack and build zip files in:
TEMPDIR=tempzip

# how to convert txt to "plain" html
TXT2PLAIN = txt2plain.pl

# generated file with binary package stats
STAT = packstat.t

# generated file with release info (STABLE and RELDATE)
RELEASE = release.t

ACTION=@echo preprocessing $@; \
       rm -f $@; \
       cpp -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@; \

all: index.html feedback.html mirrors.html cvs.html libs.html		\
 help.html download.html changes.html bugreport.html about.html		\
 support.html newslog.html news.html head.html foot.html oldnews.html	\
 info web-editing.html ad.html donation.html devel.html			\
 competition.html search.html index2.html download2.html sflogo.html
	cd docs; make
	cd libcurl; make
	cd mail; make
	cd mirror; make
	cd legal; make
	cd lxr; make
	cd rfc; make
	cd feedback; make
	@echo done 
#archive/index.html

head.html: _head.html $(MAINPARTS) css.t
	$(ACTION)

donation.html: _donation.html $(MAINPARTS)
	$(ACTION)

version7.html: _version7.html $(MAINPARTS)
	$(ACTION)

search.html: _search.html $(MAINPARTS) sitesearch.t
	$(ACTION)

web-editing.html: _web-editing.html $(MAINPARTS)
	$(ACTION)

foot.html: _foot.html $(MAINPARTS)
	$(ACTION)

main.html: _main.html $(MAINPARTS) $(STAT) $(RELEASE) poll.t recentmail.t \
	sflogo-main.html
	@echo preprocessing $@; \
	cpp -WWW -Uunix -DINDEX_HTML -P -H -C -V -LL "$(NOW)" $< $@;

index.html: main.html newslog.html
	rm -f $@
	./filter.pl < $< > $@

main2.html: _main2.html $(MAINPARTS) $(STAT) $(RELEASE) poll2.t sflogo2.t
	$(ACTION)

index2.html: main2.html newslog.html
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
	@echo "#define __STABLE $(STABLE)" >$(RELEASE)
	@echo "#define __RELDATE $(RELDATE)" >>$(RELEASE)

$(STAT): download.html Makefile
	@echo "fixing $(STAT)"
	@echo "#define __CURR "`grep -c "^.tr.class=.latest" $<` >$(STAT)
	@echo "#define __PACKS `grep -c \"^<tr c\" $<`" >>$(STAT)

download.html: _download.html $(MAINPARTS) $(RELEASE) dl/files.html
	$(ACTION)

download2.html: _download2.html $(MAINPARTS) $(RELEASE) dl/files.html
	$(ACTION)

dl/files.html: dl/data/databas.db
	cd dl; make

changes.html: _changes.html $(MAINPARTS)
	$(ACTION)

devel.html: _devel.html $(MAINPARTS)
	$(ACTION)

competition.html: _competition.html $(MAINPARTS) competition.raw
	$(ACTION)

competition.raw: competition.t
	$(TXT2PLAIN) < $< > $@

cvs.html: _cvs.html $(MAINPARTS)
	$(ACTION)

help.html: _help.html $(MAINPARTS)
	$(ACTION)

bugreport.html: _bugreport.html $(MAINPARTS)
	$(ACTION)

mirrors.html: _mirrors.html $(MAINPARTS)
	$(ACTION)

about.html: _about.html $(MAINPARTS)
	$(ACTION)

feedback.html: _feedback.html $(MAINPARTS)
	$(ACTION)

libs.html: _libs.html $(MAINPARTS)
	$(ACTION)

infolxr.html: _infolxr.html $(MAINPARTS)
	$(ACTION)

support.html: _support.html $(MAINPARTS)
	$(ACTION)

ad.html: _ad.html ad.t
	$(ACTION)

sflogo.html : sflogo.t
	$(ACTION)

sflogo-main.html : sflogo.t textlinks.t
	@echo preprocessing $@; \
	cpp -WWW -Uunix -DINDEX_HTML -P -H -C -V -LL "$(NOW)" $< $@;

#archive/index.html: mail
#	./fixit

full: all
	@cd libcurl; make

release:
	cd download; ls -1 *curl* >curldist.txt;
	@echo done

clean:
	rm -f *~
