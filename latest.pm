
use strict;

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

sub scanstatus {

    opendir(DIR, $dir) || die "can't opendir $dir: $!";
    my @curls = grep { /^curl/ && -f "$dir/$_" } readdir(DIR);
    closedir DIR;

    for(@curls) {
        my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
            $atime,$mtime,$ctime,$blksize,$blocks)
            = stat("$dir/$_");
        
        # curl-7.5.1-win32-nossl.zip
        if($_ =~ /^curl-([0-9.]*)-win32-nossl.zip/) {
            storemax($_, $1, $size,
                     "win32-nossl",
                     "Windows archive, zip compressed.");
        }
        elsif($_ =~ /^curl-([0-9.]*)-win32-ssl.zip/) {
            storemax($_, $1, $size, "win32-ssl",
                     "Windows archive, zip compressed, SSL-enabled.");
        }
        elsif($_ =~ /^curl-([0-9.]*).tar.gz/) {
            storemax($_, $1, $size, "tar.gz",
                     "Source tar archive, gzip compressed.");
        }
        elsif($_ =~ /^curl-([0-9.]*).tar.bz2/) {
            storemax($_, $1, $size, "tar.bz2",
                     "Source tar archive, bzip2 compressed.");
        }
        elsif($_ =~ /^curl-([0-9.]*).zip/) {
            storemax($_, $1, $size, "zip",
                     "Source archive, zip compressed.");
        }
        # curl-7.4.1-1.i386.rpm
        elsif($_ =~ /^curl-([0-9.]*)-(\d*)(.*).i386.rpm/) {
            my $pkg="i386.rpm";
            my $desc="Linux i386 RPM package. (redhat 6.2 style)";
            if($3 eq "rh71") {
                $pkg="rh71-".$pkg;
                $desc="Linux i386 RPM package. (redhat 7.1 style)";
            }
            storemax($_, $1, $size, $pkg, $desc);
        }
        # curl-7.4.1-1.ppc.rpm
        elsif($_ =~ /^curl-([0-9.]*)-(\d*).ppc.rpm/) {
            storemax($_, $1, $size, "ppc.rpm",
                     "Linux PPC RPM package.");
        }
        # curl-7.4.1-1.src.rpm
        elsif($_ =~ /^curl-([0-9.]*)-(\d*).src.rpm/) {
            storemax($_, $1, $size, "src.rpm",
                     "Source Linux RPM archive.");
        }
        # curl-ssl-7.4.1-1.i386.rpm
        elsif($_ =~ /^curl-ssl-([0-9.]*)-(\d*)(.*).i386.rpm/) {
            my $pkg="ssl-i386.rpm";
            my $desc="Linux i386 RPM package, SSL-enabled. (redhat 6.2 style)";
            if($3 eq "rh71") {
                $pkg="rh71-".$pkg;
                $desc="Linux i386 RPM package, SSL-enabled. (redhat 7.1 style)";
            }
            storemax($_, $1, $size, $pkg, $desc);
        }
        # curl-ssl-7.4.1-1.ppc.rpm
        elsif($_ =~ /^curl-ssl-([0-9.]*)-(\d*).ppc.rpm/) {
            storemax($_, $1, $size, "ssl-ppc.rpm",
                     "Source Linux RPM archive, SSL-enabled.");
        }
        # curl-ssl-7.4.1-1.src.rpm
        elsif($_ =~ /^curl-ssl-([0-9.]*)-(\d*).src.rpm/) {
            storemax($_, $1, $size, "ssl-src.rpm",
                     "Source Linux RPM archive, SSL-enabled.");
        }
        # curl-ssl-7.8.1-sparc-8-pkg.tar.gz
        elsif($_ =~ /^curl-ssl-([0-9.]*)-sparc-8.pkg.tar.gz/) {
            storemax($_, $1, $size, "solaris8-sparc-ssl",
                     "Solaris 8 SPARC archive, SSL-enabled.");
        }
        # curl-ssl-7.9-sparc-2.6-pkg.tar.gz
        elsif($_ =~ /^curl-ssl-([0-9.]*)-sparc-2.6.pkg.tar.gz/) {
            storemax($_, $1, $size, "solaris26-sparc-ssl",
                     "Solaris 2.6 SPARC archive, SSL-enabled.");
        }
        # curl-7.8.1-vms.zip
        elsif($_ =~ /^curl-([0-9.]*)-vms\.zip/) {
            storemax($_, $1, $size, "vms-zip",
                     "OpenVMS archive, zip compressed.");
        }
        # curl-7.8.1-2-cygwin.tar.bz2
        elsif($_ =~ /^curl-([0-9.]*)-(\d*)-cygwin.tar.bz2/) {
            storemax($_, $1, $size, "cygwin-ssl",
                     "Windows archive for cygwin, bzip2, SSL-enabled");
        }
        # curl-7.8.1-3-src-cygwin.tar.bz2
        elsif($_ =~ /^curl-([0-9.]*)-(\d*)-src-cygwin.tar.bz2/) {
            storemax($_, $1, $size, "cygwin-src",
                     "Source archive for cygwin, bzip2, SSL-enabled");
        }
    }
}

1;
