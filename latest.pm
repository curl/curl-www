
#use strict;

package latest;

# only used when run in the site
our $dir="/sites/curl.haxx.se/download";
our $curl="curl";

# they're all hashed on 'type'
our %high;
our %file;
our %size;
our %version;
our %desc;

our $headver;
my $headnum;

sub storemax {
    my ($filename, $version, $size, $which, $desc)=@_;
    my $num=0;
    if($version =~ /^(\d*)\.(\d*)$/) {
        $num = $1*1000+$2*100;
    }
    elsif($version =~ /^(\d*)\.(\d*)\.(\d*)$/) {
        $num = $1*1000+$2*100+$3;
    }
    else {
        print "Illegal version string: $version\n";
        return;
    }
    if($num > $high{$which}) {
        $high{$which}=$num;
        $file{$which}=$filename;
        $size{$which}=$size;
        $version{$which}=$version;
        $desc{$which}=$desc;
    }
    if($num > $headnum) {
        $headnum=$num;
        $headver=$version;
    }

}

# return Version, Short-Type, Description

sub gettype {
    my ($file)=@_;

    # curl-7.5.1-win32-nossl.zip
    if($file =~ /^curl-([0-9.]*)(-([0-9]*)|)-win32-nossl.zip$/) {
        return($1,
               "win32-nossl",
               "Windows, zip");
    }
    # curl-7.5.1-win64-nossl.zip
    elsif($file =~ /^curl-([0-9.]*)(-([0-9]*)|)-win64-nossl.zip$/) {
        return($1,
               "win64-nossl",
               "Windows 64bit, zip");
    }
    # curl-7.5.1-win64-ssl-sspi.zip
    elsif($file =~ /^curl-([0-9.]*)-win64-ssl-sspi.zip$/) {
        return($1,
               "win64-ssl-sspi",
               "Windows 64bit, zip, SSL-enabled, SSPI-enabled");
    }
    elsif($file =~ /^curl-([0-9.]*)(-([0-9]*)|)-win32-nossl-sspi.zip$/) {
        return($1,
               "win32-nossl-sspi",
               "Windows, zip. SSPI-enabled");
    }
    elsif($file =~ /^curl-([0-9.]*)(-([0-9]*)|)-win32-ssl.zip$/) {
        return($1, "win32-ssl",
                 "Windows, zip, SSL-enabled");
    }
    elsif($file =~ /^curl-([0-9.]*)(-([0-9]*)|)-win32-ssl-sspi.zip$/) {
        return($1, "win32-ssl-sspi",
                 "Windows, zip, SSL-enabled, SSPI-enabled");
    }
    elsif($file =~ /^curl-([0-9.]*)(-([0-9]*)|)-win32-ssl-devel-mingw32.zip$/) {
        return($1, "win32-ssl-devel-mingw",
                 "Windows mingw devel, zip, SSL-enabled");
    }

    # MSVC libcurl devel package: libcurl-7.13.1-win32-msvc.zip
    elsif($file =~ /^libcurl-([0-9.]*)(-([0-9]*)|)-win32-msvc.zip$/) {
        return($1, "win32-devel-msvc",
               "Windows MSVC libcurl devel, zip");
    }
    # MSVC libcurl SSL devel package: libcurl-7.19.3-win32-ssl-msvc.zip
    elsif($file =~ /^libcurl-([0-9.]*)(-([0-9]*)|)-win32-ssl-msvc.zip$/) {
        return($1, "win32-ssl-devel-msvc",
               "Windows MSVC libcurl devel, zip, SSL-enabled");
    }

    elsif($file =~ /^curl-([0-9.]*).tar.gz$/) {
        return($1, "tar.gz",
               "Generic source tar, gzip");
    }
    elsif($file =~ /^curl-([0-9.]*).tar.bz2$/) {
        return($1, "tar.bz2",
               "Generic source tar, bzip2");
    }
    elsif($file =~ /^curl-([0-9.]*).tar.lzma$/) {
        return($1, "tar.lzma",
               "Generic source tar, lzma");
    }
    elsif($file =~ /^curl-([0-9.]*).zip$/) {
        return($1, "zip",
               "Generic source, zip");
    }
    # curl-7.4.1-1.i386.rpm
    elsif($file =~ /^curl-([0-9.]*)-(\d*)(.*).i386.rpm$/) {
        my $pkg="i386.rpm";
        my $desc="Linux i386 RPM.";
        return($1, $pkg, $desc);
    }
    # curl-7.4.1-1.ppc.rpm
    elsif($file =~ /^curl-([0-9.]*)-(\d*).ppc.rpm$/) {
        return($1, "ppc.rpm",
               "Linux PPC RPM");
    }
    # curl-devel-7.4.1-1.ppc.rpm
    elsif($file =~ /^curl-devel-([0-9.]*)-(\d*).ppc.rpm$/) {
        return($1, "devel-ppc.rpm",
               "Linux PPC devel RPM");
    }
    # curl-7.4.1-1.src.rpm
    elsif($file =~ /^curl-([0-9.]*)-(\d*).src.rpm$/) {
        return($1, "src.rpm",
               "Linux source RPM");
    }
    # curl-ssl-7.4.1-1.ppc.rpm
    elsif($file =~ /^curl-ssl-([0-9.]*)-(\d*).ppc.rpm$/) {
        return($1, "ssl-ppc.rpm",
               "Linux PPC RPM, SSL-enabled");
    }
    # curl-ssl-devel-7.4.1-1.ppc.rpm
    elsif($file =~ /^curl-ssl-devel-([0-9.]*)-(\d*).ppc.rpm$/) {
        return($1, "ssl-devel-ppc.rpm",
               "Linux PPC devel RPM, SSL-enabled");
    }

    # curl-ssl-7.8.1-sparc-8-pkg.tar.gz
    elsif($file =~ /^curl-ssl-([0-9.]*)-sparc-8.pkg.tar.gz/) {
        return($1, "solaris8-sparc-ssl",
               "Solaris 8 SPARC, gzip, SSL-enabled");
    }
    # curl-ssl-7.8.1-sparc-8-pkg.tar.gz
    elsif($file =~ /^curl-ssl-([0-9.]*)-sparc-8.pkg.tar.bz2$/) {
        return($1, "solaris8-sparc-ssl-bz2",
               "Solaris 8 SPARC, bzip2, SSL-enabled");
    }
    # curl-ssl-7.9-sparc-2.6-pkg.tar.gz
    elsif($file =~ /^curl-ssl-([0-9.]*)-sparc-2.6.pkg.tar.gz$/) {
        return($1, "solaris26-sparc-ssl",
               "Solaris 2.6 SPARC, SSL-enabled");
    }

    # curl-7.8.1-vms-vax.zip
    elsif($file =~ /^curl-([0-9.]*)-vms-vax\.zip$/) {
        return($1, "vms-vax-zip",
               "OpenVMS VAX, zip");
    }
    # curl-7.8.1-vms-ia64.zip
    elsif($file =~ /^curl-([0-9.]*)-vms-ia64\.zip$/) {
        return($1, "vms-ia64-zip",
               "OpenVMS ia64, zip");
    }
    # curl-7.8.1-vms-axp.zip
    elsif($file =~ /^curl-([0-9.]*)-vms-axp\.zip$/) {
        return($1, "vms-axp-zip",
               "OpenVMS Alpha, zip");
    }
    elsif($file =~ /^curl-([0-9.]*)-arm\.tar\.gz$/) {
        return($1, "linux-arm-nossl",
               "Linux ARM, SSL disabled, tar+gz");
    }

    # curl-([0-9.]*)-(d*)-cygwin-nossl.tar.bz2
    elsif($file =~ /^curl-([0-9.]*)-(\d*)-cygwin-nossl.tar.bz2$/) {
        return($1, "cygwin-nossl",
               "Windows cygwin, bzip2");
    }
    # ^curl-([0-9.]*)-(d*)-cygwin-src.tar.bz2
    elsif($file =~ /^curl-([0-9.]*)-(\d*)-cygwin-src.tar.bz2$/) {
        return($1, "cygwin-src",
               "Windows cygwin source, bzip2, SSL-enabled");
    }
    # ^^curl-devel-([0-9.]*)-(d*)-cygwin.tar.bz2
    elsif($file =~ /^curl-devel-([0-9.]*)-(\d*)-cygwin.tar.bz2$/) {
        return($1, "cygwin-devel",
               "Windows cygwin devel tar, bzip2");
    }

    # curl-7.8.1-2-cygwin.tar.bz2
    elsif($file =~ /^curl-([0-9.]*)-(\d*)-cygwin.tar.bz2$/) {
        return($1, "cygwin-ssl",
               "Windows cygwin, bzip2, SSL-enabled");
    }

    # curl-7.9.3-sparc-whatever-linux.tar.gz
    elsif($file =~ /^curl-([0-9.]*)-sparc-whatever-linux.tar.gz$/) {
        return($1, "linux-sparc",
               "Linux SPARC, tar gzip");
    }

    # Itanium packages
    elsif($file =~ /^curl-ssl-([0-9.]*)-(\d*).ia64.rpm$/) {
        return($1, "ssl-linux-ia64",
               "Linux IA64, RPM, SSL-enabled");
    }
    elsif($file =~ /^curl-ssl-devel-([0-9.]*)-(\d*).ia64.rpm$/) {
        return($1, "ssl-devel-linux-ia64",
               "Linux IA64 devel, RPM, SSL-enabled");
    }
    elsif($file =~ /^curl-([0-9.]*)-(\d*).ia64.rpm$/) {
        return($1, "linux-ia64",
               "Linux IA64, RPM");
    }
    elsif($file =~ /^curl-devel-([0-9.]*)-(\d*).ia64.rpm$/) {
        return($1, "devel-linux-ia64",
               "Linux IA64 devel, RPM");
    }
    # libcurl3-7.12.2-1.i386.rpm
    elsif($file =~ /^libcurl\d-([\d\.]*)-(\d*).i386.rpm$/) {
        return($1, "i386-libcurl-rpm",
               "Linux libcurl i386, RPM");
    }
    # libcurl3-devel-7.12.2-1.i386.rpm
    elsif($file =~ /^libcurl\d-devel-([\d\.]*)-(\d*).i386.rpm$/) {
        return($1, "devel-i386-libcurl-rpm",
               "Linux libcurl devel i386, RPM");
    }
    # libcurl-7.15.0-win32-nossl-sspi.zip
    elsif($file =~ /^libcurl-([0-9.]*)-win32-nossl-sspi.zip$/) {
        return($1, "win32-devel-sspi",
               "Windows libcurl devel SSPI-enabled");
    }
    # libcurl-7.15.0-win32-nossl.zip
    elsif($file =~ /^libcurl-([0-9.]*)-win32-nossl.zip$/) {
        return($1, "win32-devel",
               "Windows libcurl devel");
    }
    # libcurl-7.15.0-win32-ssl-sspi.zip
    elsif($file =~ /^libcurl-([0-9.]*)-win32-ssl-sspi.zip$/) {
        return($1, "win32-devel-ssl-sspi",
               "Windows libcurl devel SSPI-enabled SSL-enabled");
    }
    # libcurl-7.15.0-win32-ssl.zip
    elsif($file =~ /^libcurl-([0-9.]*)-win32-ssl.zip$/) {
        return($1, "win32-devel-ssl",
               "Windows libcurl devel SSL-enabled");
    }
    
}

sub scanstatus {

    opendir(DIR, $dir) || die "can't opendir $dir: $!";
    my @curls = grep { /^(lib|)curl/ && -f "$dir/$_" } readdir(DIR);
    closedir DIR;

    for(@curls) {
        my $file = $_;

        my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
            $atime,$mtime,$ctime,$blksize,$blocks)
            = stat("$dir/$_");

        my ($version, $short, $full)=gettype($_);

        if($version) {
            storemax($file, $version, $size, $short, $full);
        }
    }
}

1;
