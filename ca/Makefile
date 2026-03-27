all: cadate.t

cadate.t: cacert.pem Makefile
	grep "updated on:" cacert.pem | cut -d: -f2- | awk '{printf("#define CA_DATE %s\n", $$0);}' > cadate.t
