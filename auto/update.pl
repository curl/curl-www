#!/usr/bin/perl

opendir(DIR, "inbox");
my @logs = grep { /^inbox/ } readdir(DIR);
closedir DIR;

map {$logfile{$_}="p";} (@logs);

if(open(MD5, "<md5")) {
    while(<MD5>) {
        if(/([^ ]*)  .*\/(.*)/) {
            $logfile{$2}="c";
        }
    }
    close(MD5);
}

# if there's a logfile named 'p' now, it is new!
my $new=0;
for(keys %logfile) {
    if($logfile{$_} eq "p") {
        $new=1;
        last;
    }
}

#print "new: $new\n";

if(!$new) {
    my $res = system("md5sum -c md5 >/dev/null 2>&1");

    $res >>= 8;

#    print "res: $res\n";
    if(!$res) {
        # unmodified
        $new = 0;
    }
    else {
        $new = 1;
    }
}

if($new) {
    # first remove oldies
    system('find inbox -mtime +15 -exec rm {} \;');

    # build md5 checksum file
    system("md5sum inbox/inbox* > md5");

    # build the summary
    system("nice ./summarize.pl");
}

# get latest cvs data
my $cwd=`pwd`; 
chomp $cwd;
chdir "curl";
system("$cwd/last5commits.pl > $cwd/dump 2>/dev/null");

chdir "tests";
system("./keywords.pl > $cwd/keywords.t 2>/dev/null");
chdir "$cwd";

if ( -s "dump") {
    # create html table
    open(OUT, ">cvs.t");
    open(DUMP, "./cvs2html.pl dump|");
    while(<DUMP>) {
        # convert the begining of a "C comment" to a html code to prevent the
        # cpp to barf
        $_ =~ s/\/\*/&\#47;*/g;
        print OUT $_;
    }
    close(OUT);
    close(DUMP);
}

# rebuild the HTML
system("make -k >/dev/null 2>&1");

