ROOT = ../..

include $(ROOT)/setup.mk
include $(ROOT)/mainparts.mk
include ../bindings.mk

FCPP_OPTS=-I..

all: index.html easy.pm.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

easy.pm.html: _easy.pm.html $(MAINPARTS)
	$(ACTION)
