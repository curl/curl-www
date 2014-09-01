NOW=$(shell date +'-D__TODAY__=%B %d, %Y')

ACTION=fcpp $(FCPP_OPTS) -I$(ROOT) -WWW -Uunix -P -H -C -V -LL "$(NOW)" $< $@;

