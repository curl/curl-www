ACTION=fcpp $(FCPP_OPTS) -I$(ROOT) -WWW -Uunix -P -H -C -V -LL $< $@
TXT2PLAIN=$(ROOT)/docs/txt2plain.pl
MARKDOWN=pandoc -f gfm
GITHUB=pandoc -f gfm
