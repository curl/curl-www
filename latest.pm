
#use strict;

package latest;

our $dir="/home/dast/curl_html/download";
our $curl="/usr/local/bin/curl";

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
    if($file =~ /^curl-([0-9.]*)(-([0-9]*)|)-win32-nossl.zip/) {
        return($1,
               "win32-nossl",
               "Windows archive, zip compressed.");
    }
    elsif($file =~ /^curl-([0-9.]*)(-([0-9]*)|)-win32-ssl.zip/) {
        return($1, "win32-ssl",
                 "Windows archive, zip compressed, SSL-enabled.");
    }
    elsif($file =~ /^curl-([0-9.]*)(-([0-9]*)|)-win32-ssl-devel-mingw32.zip/) {
        return($1, "win32-ssl-devel-mingw",
                 "Windows mingw devel archive, zip compressed, SSL-enabled.");
    }
    elsif($file =~ /^curl-([0-9.]*).tar.gz/) {
        return($1, "tar.gz",
               "Source tar archive, gzip compressed.");
    }
    elsif($file =~ /^curl-([0-9.]*).tar.bz2/) {
        return($1, "tar.bz2",
               "Source tar archive, bzip2 compressed.");
    }
    elsif($file =~ /^curl-([0-9.]*).zip/) {
        return($1, "zip",
               "Source archive, zip compressed.");
    }
    # curl-7.4.1-1.i386.rpm
    elsif($file =~ /^curl-([0-9.]*)-(\d*)(.*).i386.rpm/) {
        my $pkg="i386.rpm";
        my $desc="Linux i386 RPM package.";
        return($1, $pkg, $desc);
    }
    # curl-7.4.1-1.ppc.rpm
    elsif($file =~ /^curl-([0-9.]*)-(\d*).ppc.rpm/) {
        return($1, "ppc.rpm",
               "Linux PPC RPM package.");
    }
    # curl-devel-7.4.1-1.ppc.rpm
    elsif($file =~ /^curl-devel-([0-9.]*)-(\d*).ppc.rpm/) {
        return($1, "devel-ppc.rpm",
               "Linux devel PPC RPM package.");
    }
    # curl-7.4.1-1.src.rpm
    elsif($file =~ /^curl-([0-9.]*)-(\d*).src.rpm/) {
        return($1, "src.rpm",
               "Source Linux RPM archive.");
    }
    # curl-ssl-7.4.1-1.i386.rpm
    elsif($file =~ /^curl-ssl-([0-9.]*)-(\d*)(.*).i386.rpm/) {
        my $pkg="ssl-i386.rpm";
        my $desc="Linux i386 RPM package, SSL-enabled.";
        return($1, $pkg, $desc);
    }
    # curl-ssl-devel-7.9.1-1rh72.i386.rpm
    elsif($file =~ /^curl-ssl-devel-([0-9.]*)-(\d*)(.*).i386.rpm/) {
        my $pkg="ssl-devel-i386.rpm";
        my $desc="Linux devel i386 RPM package, SSL-enabled.";
        return($1, $pkg, $desc);
    }
    # curl-devel-7.9.1-1rh72.i386.rpm
    elsif($file =~ /^curl-devel-([0-9.]*)-(\d*)(.*).i386.rpm/) {
        my $pkg="devel-i386.rpm";
        my $desc="Linux devel i386 RPM package";
        return($1, $pkg, $desc);
    }
    # curl-ssl-7.4.1-1.ppc.rpm
    elsif($file =~ /^curl-ssl-([0-9.]*)-(\d*).ppc.rpm/) {
        return($1, "ssl-ppc.rpm",
               "Linux PPC RPM archive, SSL-enabled.");
    }
    # curl-ssl-devel-7.4.1-1.ppc.rpm
    elsif($file =~ /^curl-ssl-devel-([0-9.]*)-(\d*).ppc.rpm/) {
        return($1, "ssl-devel-ppc.rpm",
               "Linux devel PPC RPM archive, SSL-enabled.");
    }
    # curl-ssl-7.4.1-1.src.rpm
    elsif($file =~ /^curl-ssl-([0-9.]*)-(\d*).src.rpm/) {
        return($1, "ssl-src.rpm",
               "Source Linux RPM archive, SSL-enabled.");
    }
    # curl-ssl-7.8.1-sparc-8-pkg.tar.gz
    elsif($file =~ /^curl-ssl-([0-9.]*)-sparc-8.pkg.tar.gz/) {
        return($1, "solaris8-sparc-ssl",
               "Solaris 8 SPARC archive, SSL-enabled.");
    }
    # curl-ssl-7.8.1-sparc-8-pkg.tar.gz
    elsif($file =~ /^curl-ssl-([0-9.]*)-sparc-8.pkg.tar.bz2/) {
        return($1, "solaris8-sparc-ssl-bz2",
               "Solaris 8 SPARC archive, bzip2, SSL-enabled.");
    }
    # curl-ssl-7.9-sparc-2.6-pkg.tar.gz
    elsif($file =~ /^curl-ssl-([0-9.]*)-sparc-2.6.pkg.tar.gz/) {
        return($1, "solaris26-sparc-ssl",
               "Solaris 2.6 SPARC archive, SSL-enabled.");
    }
    # curl-7.8.1-vms.zip
    elsif($file =~ /^curl-([0-9.]*)-vms\.zip/) {
        return($1, "vms-zip",
               "OpenVMS archive, zip compressed.");
    }

    # Kevin's new formats starting with curl 7.10:
    # curl-([0-9.]*)-(d*)-cygwin-nossl.tar.bz2
    elsif($file =~ /^curl-([0-9.]*)-(\d*)-cygwin-nossl.tar.bz2/) {
        return($1, "cygwin-nossl",
               "Windows archive for cygwin, bzip2");
    }
    # ^curl-([0-9.]*)-(d*)-cygwin-src.tar.bz2
    elsif($file =~ /^curl-([0-9.]*)-(\d*)-cygwin-src.tar.bz2/) {
        return($1, "cygwin-src",
               "Source archive for cygwin, bzip2, SSL-enabled");
    }
    # ^^curl-devel-([0-9.]*)-(d*)-cygwin.tar.bz2
    elsif($file =~ /^curl-devel-([0-9.]*)-(\d*)-cygwin.tar.bz2/) {
        return($1, "cygwin-devel",
               " Windows cygwin devel tar archive, bzip2");
    }


    # curl-7.8.1-2-cygwin.tar.bz2
    elsif($file =~ /^curl-([0-9.]*)-(\d*)-cygwin.tar.bz2/) {
        return($1, "cygwin-ssl",
               "Windows archive for cygwin, bzip2, SSL-enabled");
    }
    # OLD: curl-7.8.1-2-nossl-cygwin.tar.bz2
    elsif($file =~ /^curl-([0-9.]*)-(\d*)-nossl-cygwin.tar.bz2/) {
        return($1, "cygwin-nossl",
               "Windows archive for cygwin, bzip2");
    }
    # OLD: curl-7.8.1-2-src-cygwin.tar.bz2
    elsif($file =~ /^curl-([0-9.]*)-(\d*)-src-cygwin.tar.bz2/) {
        return($1, "cygwin-src",
               "Source archive for cygwin, bzip2, SSL-enabled");
    }


    # curl-7.9.3-sparc-whatever-linux.tar.gz
    elsif($file =~ /^curl-([0-9.]*)-sparc-whatever-linux.tar.gz/) {
        return($1, "linux-sparc",
               "Linux SPARC, gzipped");
    }
}

sub scanstatus {

    opendir(DIR, $dir) || die "can't opendir $dir: $!";
    my @curls = grep { /^curl/ && -f "$dir/$_" } readdir(DIR);
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
