
use strict;

package latest;

our $dir="/home/dast/curl_html/download";
our $curl="/usr/local/bin/curl";

our %high;
our %file;
our %size;
our %version;

our $headver;
my $headnum;

sub storemax {
    my ($version, $size, $which)=@_;
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
        $file{$which}=$_;
        $size{$which}=$size;
        $version{$which}=$version;
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
            storemax($1, $size, "win32-nossl");
        }
        elsif($_ =~ /^curl-([0-9.]*)-win32-ssl.zip/) {
            storemax($1, $size, "win32-ssl");
        }
        elsif($_ =~ /^curl-([0-9.]*).tar.gz/) {
            storemax($1, $size, "tar.gz");
        }
        elsif($_ =~ /^curl-([0-9.]*).tar.bz2/) {
            storemax($1, $size, "tar.bz2");
        }
        elsif($_ =~ /^curl-([0-9.]*).zip/) {
            storemax($1, $size, "zip");
        }
        # curl-7.4.1-1.i386.rpm
        elsif($_ =~ /^curl-([0-9.]*)-(\d*).i386.rpm/) {
            storemax($1, $size, "i386.rpm");
        }
        # curl-7.4.1-1.ppc.rpm
        elsif($_ =~ /^curl-([0-9.]*)-(\d*).ppc.rpm/) {
            storemax($1, $size, "ppc.rpm");
        }
        # curl-7.4.1-1.src.rpm
        elsif($_ =~ /^curl-([0-9.]*)-(\d*).src.rpm/) {
            storemax($1, $size, "src.rpm");
        }
        # curl-ssl-7.4.1-1.i386.rpm
        elsif($_ =~ /^curl-ssl-([0-9.]*)-(\d*).i386.rpm/) {
            storemax($1, $size, "ssl-i386.rpm");
        }
        # curl-ssl-7.4.1-1.ppc.rpm
        elsif($_ =~ /^curl-ssl-([0-9.]*)-(\d*).ppc.rpm/) {
            storemax($1, $size, "ssl-ppc.rpm");
        }
        # curl-ssl-7.4.1-1.src.rpm
        elsif($_ =~ /^curl-ssl-([0-9.]*)-(\d*).src.rpm/) {
            storemax($1, $size, "ssl-src.rpm");
        }
    }
}

1;
