
TARGET = files.html
TARGE2 = files2.html

all: $(TARGET) $(TARGE2)

$(TARGET): data/databas.db ../Makefile mktable.pl
	perl mktable.pl > $(TARGET)

$(TARGE2): data/databas.db ../Makefile
	perl mktable2.pl > $(TARGE2)
