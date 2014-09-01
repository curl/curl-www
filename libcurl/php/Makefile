ROOT = ../..

include $(ROOT)/setup.mk
include $(ROOT)/mainparts.mk
include ../bindings.mk

FCPP_OPTS=-I..

all: index.html install.html apps.html examples.html iis.html hosting.html
	cd examples; make

index.html: _index.html $(MAINPARTS)
	$(ACTION)

install.html: _install.html $(MAINPARTS)
	$(ACTION)

apps.html: _apps.html $(MAINPARTS)
	$(ACTION)

iis.html: _iis.html $(MAINPARTS)
	$(ACTION)

hosting.html: _hosting.html $(MAINPARTS)
	$(ACTION)

examples.html: _examples.html $(MAINPARTS)
	$(ACTION)
