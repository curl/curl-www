ROOT = ../..

include $(ROOT)/mainparts.mk
include $(ROOT)/setup.mk

MAINPARTS += _menu.html

all: index.html schedule.html roadmap.html api.html app.html

index.html: _index.html $(MAINPARTS)
	$(ACTION)

schedule.html: _schedule.html $(MAINPARTS)
	$(ACTION)

roadmap.html: _roadmap.html $(MAINPARTS)
	$(ACTION)

api.html: _api.html api.t $(MAINPARTS)
	$(ACTION)
api.t: API
	$(TXT2PLAIN) < $< > $@

app.html: _app.html app.t $(MAINPARTS)
	$(ACTION)
app.t: app.c
	$(TXT2PLAIN) < $< > $@
