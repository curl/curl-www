#!/usr/bin/perl

$root="../../cvssource";
$dir="$root/docs/examples";

opendir(DIR, $dir) || die "can't opendir $dir: $!";
my @samps = grep { /\.c\z/ && -f "$dir/$_" } readdir(DIR);
closedir DIR;

sub scanexample {
    my ($dir, $file)=@_;

    open(F, "<$dir/$file");
    while(<F>) {
        my $l = $_;
        chomp $l;
        if($l =~ /^(.*)(CURLOPT_[A-Z_0-9]*)(.*)/) {
            $usedinexample{$2}++;
            $optinexample{$2}.="$file ";
        }
    }
    close(F);
}

sub scancurlh {
    open(F, "<$root/include/curl/curl.h");
    while(<F>) {
        my $l = $_;
        chomp $l;
        if($l =~ /^  CINIT\(([A-Z_0-9]*)(.*)/) {
            if($2 =~ /DEPRECATED/) {
                # ignore deprecated options
                next;
            }
            $usedinheader{"CURLOPT_$1"}++;
        }
    }
    close(F);

}

for(@samps) {
    scanexample($dir, $_);
}
scancurlh();

print "<table><tr><th>Option</th><th>Examples</th></tr>\n";
for(sort keys %usedinheader) {
    my $ex;
    my $opt = $_;
    my @s = split (/ /, $optinexample{$opt});
    my $l=0;
    my %used;
    for(@s) {
        my $html= $_;
        $html =~ s/\.c/\.html/;
        if(!$used{$_}) {
            $ex .= sprintf("<a href=\"%s\">%s</a> ", $html, $_);
            $used{$_}++;
        }
    }
    if(!$ex) {
        $ex = "&nbsp;";
        $lacks++;
    }

    $anchor = $opt;
    $anchor =~ s/_//g; # cut off underscores
    $docs = "http://curl.haxx.se/libcurl/c/curl_easy_setopt.html#$anchor";
    printf("<a name=\"%s\"></a><tr><td><a href=\"%s\">%s</a></td><td>%s</td></tr>\n",
           $_, $docs, $_, $ex);
    $total++;
}
print "</table>";
print "<p> Out of the $total options, $lacks are not used by any example\n";
