#!/usr/bin/perl

require "./vuln.pm";

sub jsonquote {
    my ($in) = @_;

    # escape double quotes and backslashes
    $in =~ s/([\"\\])/\\$1/g;

    # trim the trail
    $in =~ s/\n+\z//g;

    # trim the start
    $in =~ s/^[ \n\t]+//;

    # newlines
    $in =~ s/\n/\\n/g;

    return $in;
}

sub modified {
    my ($cve)=@_;
    my $date;
    open(G, "git log --date=iso-strict -1 $cve.md|");
    while(<G>) {
        if(/^Date: +(.*)/) {
            $date = $1;
        }
    }
    close(G);
    return $date;
}

sub dumpobj {
    my ($cve, @json)=@_;
    open(O, ">$cve.json");
    print O @json;
    close(O);
}

sub scancve {
    my ($cve)=@_;
    my ($severity, $desc, $repby, $patchby, $fixed);
    my $inc = 0;
    open(F, "<$cve.md");
    while(<F>) {
        $_ =~ s/\r//;
        if(/^- Not affected versions.* >= (.*)/) {
            $fixed = $1;
        }
        elsif(/^- Patched-by: (.*)/i) {
            $patchby = $1;
        }
        elsif(/^- Reported-by: (.*)/i) {
            $repby = $1;
        }
        elsif(/^Severity: (.*)/i) {
            $severity = ucfirst($1);
        }
        elsif(/^VULNERABILITY/) {
            $inc = 1;
        }
        elsif(/^------/ && ($inc == 1)) {
            $inc = 2; 
        }
        elsif($inc == 2) {
            if(/^[A-Z ]+\n\z/) {
                $inc = 0;
            }
            else {
                $desc .= $_;
            }
        }
    }
    close(F);
    if(!$fixed) {
        die "could not find fixed in $cve";
    }
    return ($desc, $severity, $repby, $patchby, $fixed);
}

my @releases; #all of them, from newest to oldest
sub releases {
    open(R, "<releases.csv");
    while(<R>) {
        my @f = split(/;/, $_);
        push @releases, $f[1]; # version numbers
    }
    close(R);
}

sub vernum {
    my ($ver) = @_;
    my @v = split(/\./, $ver);
    return $v[0] * 10000 + $v[1] * 100 + $v[2];
}

sub inclusive {
    my ($first, $last, $indent) = @_;
    my $fnum = vernum($first);
    my $lnum = vernum($last);
    my $str = $indent;
    my $i=0;

    for my $e (@releases) {
        if((vernum($e) >= $fnum) &&
           (vernum($e) <= $lnum)) {
            $str .= "\"$e\", ";
            if(++$i == 7) {
                $str .= "\n$indent";
                $i = 0;
            }
        }
    }
    # remove trailing comma
    $str =~ s/,[ \n]*\z//;
    return $str;
}

releases();

my @all;
my $i=0;
push @all, "[\n";
for(@vuln) {
    my ($file, $first, $last, $name, $cve, $announce, $report,
        $cwe, $award, $area, $cissue)=split('\|');
    $announce =~ s/(\d\d\d\d)(\d\d)(\d\d)/$1-$2-$3/;
    $report =~ s/(\d\d\d\d)(\d\d)(\d\d)/$1-$2-$3/;
    $award += 0; # make sure it exists
    my $modified = modified($cve);
    my @single;

    my ($desc, $severity, $repby, $patchby, $fixed)=scancve($cve);

    push @all, ",\n" if($i);
    my $v = inclusive($first, $last, "        ");
    push @single,
        "{\n".
        "  \"id\": \"CURL-$cve\",\n".
        "  \"aliases\": [\n".
        "    \"$cve\"\n".
        "  ],\n".
        "  \"summary\": \"$name\",\n".
        "  \"modified\": \"${modified}Z\",\n".
        "  \"database_specific\": {\n".
        "    \"URL\": \"https://curl.se/docs/$cve.html\",\n".
        "    \"CWE\": \"$cwe\"\n".
        "  },\n".
        "  \"published\": \"${announce}T08:00:00Z\",\n".
        "  \"affected\": [\n".
        "    {\n".
        "      \"package\": {\n".
        "        \"name\": \"curl\",\n".
        "        \"purl\": \"pkg:generic/curl\"\n".
        "      },\n".
        "      \"ranges\": [\n".
        "        {\n".
        "           \"type\": \"SEMVER\",\n".
        "           \"events\": [\n".
        "             {\"introduced\": \"$first\"},\n".
        "             {\"last_affected\": \"$last\"},\n".
        "             {\"fixed\": \"$fixed\"}\n".
        "           ]\n".
        "        }\n".
        "      ],\n".
        "      \"versions\": [\n$v\n".
        "      ]\n".
        "    }\n".
        "  ],\n";
    if($severity) {
        my $cvss = "1.0"; # default low
        $cvss = "4.0" if($severity eq "Medium");
        $cvss = "7.0" if($severity eq "High");
        $cvss = "9.0" if($severity eq "Critical");
        push @single,
            "  \"severity\": [\n".
            "    {\n".
            "      \"type\": \"basic\",\n".
            "      \"score\": \"$severity\"\n".
            "    },\n".
            "    {\n".
            "      \"type\": \"CVSS_V3\",\n".
            "      \"score\": \"$cvss\"\n".
            "    }\n".
            "  ],\n";
    }
    push @single, "  \"credits\": [\n";
    if($repby) {
        my $c = 0;
        for my $r (split(/, /, $repby)) {
            push @single, ",\n" if($c);
            push @single,
                "    {\n".
                "      \"name\": \"$r\",\n".
                "      \"type\": \"FINDER\"\n".
                "    }";
            $c++;
        }
        push @single, "," if($patchby);
        push @single, "\n";
    }
    if($patchby) {
        push @single,
            "    {\n".
            "      \"name\": \"$patchby\",\n".
            "      \"type\": \"REMEDIATION_DEVELOPER\"\n".
            "    }\n";
    }
    push @single, "  ],\n";
    push @single, sprintf "  \"details\": \"%s\"\n".
        "}", jsonquote($desc);
    $i++;
    dumpobj($cve, @single);
    push @all, @single;
}
push @all, "\n]\n";
print @all;
