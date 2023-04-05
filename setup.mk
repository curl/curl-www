ACTION=fcpp $(FCPP_OPTS) -I$(ROOT) -WWW -Uunix -P -H -C -V -LL $< $@ \
 && sed -i 's/\.\.\/cvssource\///g' $@
TXT2PLAIN=$(ROOT)/docs/txt2plain.pl
MARKDOWN=echo "<p><a href=\"https://github.com/curl/curl/edit/master/"$<"\">Edit this page on GitHub</a></p>" > $@.href.inc && pandoc -B $@.href.inc -f gfm
GITHUB=pandoc -f gfm
