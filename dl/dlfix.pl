#!/usr/bin/perl

require "../latest.pm";
require "stuff.pm";

# Ladda databasen
$db=new pbase;
$db->open($databasefilename);

&latest::scanstatus();

my $mod; # number of changes made

sub updatethis {
    my ($name, $file, $size, $version)=@_;

    my @ref = $db->find_all("re"=>"^$name\$");

    if(!@ref) {
        print "No regex in the db found for: $name at $version\n";
        return;
    }
    for(@ref) {
        my $ref = $_;
        print "Checking $name at $version, for OS ".$$ref{'os'}."\n";

        if($$ref{'file'} ne $file) {
            print "... file names differ: $$ref{'file'} vs $file\n";
            $$ref{'file'}=$file; # set the actual one
            $mod++;
        }
        if($$ref{'curl'} ne $version) {
            print "... versions differ: $$ref{'curl'} vs $version\n";
            $$ref{'curl'}=$version; # set the actual one
            $mod++;
        }
        if($$ref{'size'} ne $size) {
            print "... sizes differ: $$ref{'size'} vs $size\n";
            $$ref{'size'}=$size; # set the actual one
            $mod++;
        }
        my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
            $atime,$mtime,$ctime,$blksize,$blocks)
            = stat($latest::dir."/".$file);
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
            localtime($mtime);
        my $date = sprintf("%04d-%02d-%02d",
                           $year+1900, $mon+1, $mday);
        if($$ref{'date'} ne $date) {
            print "... dates differ: $$ref{'date'} vs $date\n";
            $$ref{'date'}=$date; # set the actual one
            $mod++;
        }

    }
    
}

for(keys %latest::file) {
    my $archive=$latest::file{$_};
    updatethis($_, $archive, $latest::size{$_}, $latest::version{$_});
}

if($mod) {
    $db->save();
    print "$mod changes saved\n";
}
else {
    print "no changes\n";
}
