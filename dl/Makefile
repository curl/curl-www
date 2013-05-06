
TARGET = files.html

all: $(TARGET)

$(TARGET): data/databas.db ../Makefile mktable.pl
	perl mktable.pl > $(TARGET)
