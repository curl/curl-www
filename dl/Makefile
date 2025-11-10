TARGET = files.html

all: $(TARGET)

$(TARGET): data/databas.db ../Makefile mktable.pl
	./mktable.pl > $(TARGET)
