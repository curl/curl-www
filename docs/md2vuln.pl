#!/usr/bin/env perl
# extract information from a CVE markdown into a line suitable
# to put into vuln.pm
#

use strict;
use warnings;
use Getopt::Long ();

my %months = (
    january   => "01", jan => "01",
    february  => "02", feb => "02",
    march     => "03", mar => "03",
    april     => "04", apr => "04",
    may       => "05",
    june      => "06", jun => "06",
    july      => "07", jul => "07",
    august    => "08", aug => "08",
    september => "09", sep => "09", sept => "09",
    october   => "10", oct => "10",
    november  => "11", nov => "11",
    december  => "12", dec => "12",
);

sub parsedate {
    my ($str, $default_year) = @_;
    return "" unless defined $str;
    if ($str =~ /([A-Za-z]+)\s+(\d+)(?:st|nd|rd|th)?,?(?:\s+(\d{4}))?/) {
        my ($m, $d, $y) = ($1, $2, $3 // $default_year);
        my $mnum = $months{lc($m)};
        return sprintf("%04d%02d%02d", $y, $mnum, $d) if ($mnum && $y);
    }
    return "";
}

sub deduce_cissue {
    my ($cwe, $content) = @_;
    $cwe //= "";
    $content //= "";

    if ($content =~ /(?:not considered a \*C mistake\*|\*not\* considered a \*C mistake\*|\*\*not\*\* considered a \*C mistake\*|not likely to have been avoided had we not been using C)/i) {
        return "-";
    }
    if ($cwe ne "") {
        if ($cwe =~ /CWE-(?:124|125|126)\b|Buffer Over-read|Buffer Underwrite|Buffer Underflow|Out-of-bounds Read|Improper Null Termination/i) {
            return "OVERREAD";
        }
        if ($cwe =~ /CWE-416\b|Use After Free|Use-After-Free/i) {
            return "USE_AFTER_FREE";
        }
        if ($cwe =~ /CWE-415\b|Double Free/i) {
            return "DOUBLE_FREE";
        }
        if ($cwe =~ /CWE-(?:121|122|131|680)\b|Buffer Overflow/i) {
            return "OVERFLOW";
        }
        if ($cwe =~ /CWE-590\b|Free of Memory not on the Heap/i) {
            return "BAD_FREE";
        }
        if ($cwe =~ /CWE-457\b|Uninitialized/i) {
            return "UNINIT";
        }
        if ($cwe =~ /CWE-476\b|NULL/i) {
            return "NULL_MISTAKE";
        }
    }
    return "-";
}

sub deduce_where {
    my ($content) = @_;
    $content //= "";
    $content =~ s/\*//g;

    if ($content =~ /only (?:affect(?:s|ing)?|present in|exist[s]? in) the (?:curl |wcurl )?command line tool/i ||
        $content =~ /exists in the command line tool only/i ||
        $content =~ /exists only in the curl tool/i ||
        $content =~ /curl tool but not for applications\s+using libcurl/i ||
        $content =~ /curl command line issue and does not affect libcurl/i) {
        return "tool";
    }
    if ($content =~ /(?:also affect[s]?|also exists? in|also be triggered with|also accessible using) the (?:curl )?command line tool/i ||
        $content =~ /Both curl the command line tool/i) {
        return "both";
    }
    if ($content =~ /(?:does not|cannot be|is not affected|does not exist|is not accessible).*command line tool/i ||
        $content =~ /command line tool\s+is not affected/i ||
        $content =~ /not accessible from the command line tool/i ||
        $content =~ /only libcurl/i) {
        return "lib";
    }
    return "both";
}

sub deduce_area {
    my ($title, $cwe, $content) = @_;
    if($content =~ /- Area: (.*)/) {
        return $1;
    }
    return "unknown";
}

sub scanmd {
    my ($file, %opt) = @_;
    open(my $fh, "<", $file) or die "Cannot open $file: $!\n";
    my @lines = <$fh>;
    close($fh);

    # Title is the first non-empty line
    my $title = "";
    for my $l (@lines) {
        $l =~ s/\r?\n$//;
        if ($l =~ /\S/) {
            $title = $l;
            last;
        }
    }

    my $content = join("", @lines);

    # CVE ID
    my ($cve) = ($file =~ /(CVE-\d{4}-\d+)/);
    if (!$cve && $content =~ /assigned the name\s+(CVE-\d{4}-\d+)/i) {
        $cve = $1;
    }
    if (!$cve && $content =~ /(CVE-\d{4}-\d+)/) {
        $cve = $1;
    }

    # Page (HTML filename)
    my $page = "$cve.html";

    # Affected versions
    my ($start, $stop);
    for my $l (@lines) {
        if ($l =~ /^- Affected versions:\s*[^0-9X]*([0-9.X]+)\s+to and including\s+[^0-9X]*([0-9.X]+)/i) {
            $start = $1;
            $stop = $2;
            last;
        } elsif ($l =~ /^- Affected version:\s*[^0-9X]*([0-9.X]+)/i) {
            $start = $1;
            $stop = $1;
            last;
        }
    }
    $start //= "-";
    $stop //= "-";

    # Announce date
    my $announce;
    for my $l (@lines) {
        if ($l =~ /^Project curl Security Advisory,?\s*(.*)/i) {
            $announce = parsedate($1);
            last if $announce;
        }
    }
    if (!$announce && $content =~ /released on\s+([A-Za-z]+ \d+,? \d{4})/i) {
        $announce = parsedate($1);
    }

    # Report date
    my $report;
    my $timeline_text = $content;
    if ($content =~ /TIMELINE\s*-+\s*(.*?)(?=\n[A-Z ]+\n---|\z)/s) {
        $timeline_text = $1;
    }
    $timeline_text =~ s/\[([^\]]+)\]\([^)]+\)/$1/g;
    $timeline_text =~ s/\s+/ /g;
    my ($ann_year) = ($announce && $announce =~ /^(\d{4})/) ? $1 : undef;
    if ($timeline_text =~ /(?:reported(?: \(publicly\))? (?:to the curl project |by [^.]+? )?on|first reported[ a-z]* on|reported it to us on)\s+([A-Za-z]+ \d+(?:st|nd|rd|th)?(?:,?\s+\d{4})?)/i) {
        $report = parsedate($1, $ann_year);
    }

    # CWE
    my $cwe;
    for my $l (@lines) {
        if ($l =~ /^\s*(CWE-\d+:\s*.*?)\s*$/) {
            $cwe = $1;
            last;
        }
    }

    # Bug bounty
    my $award = $opt{award};
    if (!defined $award) {
        for my $l (@lines) {
            if ($l =~ /^\s*-?\s*Bug bounty:\s*(\d+)/i) {
                $award = $1;
                last;
            }
        }
    }
    $award //= 0;

    my $area = $opt{area} // deduce_area($title, $cwe, $content);
    my $cissue = $opt{cissue} // deduce_cissue($cwe, $content);
    my $where = $opt{where} // deduce_where($content);

    # Severity
    my $severity;
    for my $l (@lines) {
        if ($l =~ /^\s*Severity:\s*(\w+)/i) {
            $severity = lc($1);
            last;
        }
    }

    # Issue / Original report link
    my $issue = $opt{issue};
    if (!$issue) {
        for my $l (@lines) {
            if ($l =~ /^\s*-?\s*Original report:\s*(https?:\/\/\S+)/i) {
                $issue = $1;
                $issue =~ s/[\s>)]+$//;
                last;
            }
        }
    }
    if (!$issue) {
        if ($content =~ /(https:\/\/hackerone\.com\/reports\/\d+)/i) {
            $issue = $1;
        }
    }

    $page //= ($cve ? "$cve.html" : "-");
    $start //= "-";
    $stop //= "-";
    $title //= "-";
    $cve //= "-";
    $announce //= "";
    $report //= "";
    $cwe //= "-";
    $award //= 0;
    $area //= "-";
    $cissue //= "-";
    $where //= "both";
    $severity //= "-";

    my @f = ($page, $start, $stop, $title, $cve, $announce, $report,
             $cwe, $award, $area, $cissue, $where, $severity);
    push @f, $issue if $issue;

    if ($opt{raw}) {
        return join("|", @f);
    }
    my $record = join("|", @f);
    $record =~ s/([\\\"\$\@])/\\$1/g;
    return sprintf("    \"%s\",", $record);
}

# Run as CLI script if executed directly
if (!caller) {
    my %cli_opts;
    Getopt::Long::GetOptions(
        'area=s'   => \$cli_opts{area},
        'award=i'  => \$cli_opts{award},
        'issue=s'  => \$cli_opts{issue},
        'cissue=s' => \$cli_opts{cissue},
        'where=s'  => \$cli_opts{where},
        'raw'      => \$cli_opts{raw},
        'help|h'   => sub {
            print "Usage: $0 [options] <cve-markdown-file> ...\n";
            print "Options:\n";
            print "  --area=<area>      Specify area (e.g. TLS, SSH, HTTP)\n";
            print "  --award=<usd>      Specify bounty award in USD (default: 0)\n";
            print "  --issue=<url>      Specify issue/report URL\n";
            print "  --cissue=<type>    Specify C-issue (e.g. -, OVERFLOW, USE_AFTER_FREE)\n";
            print "  --where=<target>   Specify tool/lib (both, lib, tool)\n";
            print "  --raw              Output raw pipe-separated format\n";
            print "  --help             Show this help message\n";
            exit 0;
        },
    ) or exit 1;

    if (!@ARGV) {
        die "Usage: $0 [options] <cve-markdown-file> ...\n";
    }

    for my $file (@ARGV) {
        print scanmd($file, %cli_opts), "\n";
    }
}

1;
