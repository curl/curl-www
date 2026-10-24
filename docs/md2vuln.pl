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
    my ($str) = @_;
    return "" unless defined $str;
    if ($str =~ /([A-Za-z]+)\s+(\d+)(?:st|nd|rd|th)?,?\s+(\d{4})/) {
        my ($m, $d, $y) = ($1, $2, $3);
        my $mnum = $months{lc($m)};
        return sprintf("%04d%02d%02d", $y, $mnum, $d) if $mnum;
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
    if ($content =~ /(?:is considered a \*C mistake\*|likely to have been avoided had we not been using C)/i) {
        if ($cwe =~ /CWE-(?:125|126)\b|Buffer Over-read|Out-of-bounds Read/i) {
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
        $content =~ /exists in the command line tool only/i) {
        return "tool";
    }
    if ($content =~ /(?:also affect[s]?|also exists? in|also be triggered with|also accessible using) the (?:curl )?command line tool/i ||
        $content =~ /Both curl the command line tool/i) {
        return "both";
    }
    if ($content =~ /(?:does not|cannot be|is not affected|does not exist|is not accessible).*command line tool/i ||
        $content =~ /not accessible from the command line tool/i ||
        $content =~ /only libcurl/i) {
        return "lib";
    }
    return "both";
}

sub deduce_area {
    my ($title, $cwe, $content) = @_;
    $title //= "";
    $cwe //= "";
    $content //= "";

    my $t = lc($title);
    my $c = lc($content);

    if ($t =~ /websocket/) { return "WebSocket"; }
    if ($t =~ /cookies/) { return "cookies"; }
    if ($t =~ /cookie/) { return "cookie"; }
    if ($t =~ /hsts/) { return "HSTS"; }
    if ($t =~ /http\/2/ || $t =~ /\bh2\b/) { return "HTTP/2"; }
    if ($t =~ /http\/3/ || $t =~ /\bquic\b/) { return "HTTP/3"; }
    if ($t =~ /sftp/) { return "SFTP"; }
    if ($t =~ /tftp/) { return "TFTP"; }
    if ($t =~ /ftp/) { return "FTP"; }
    if ($t =~ /ssh|scp|knownhost/) { return "SSH"; }
    if ($t =~ /ldap/) { return "LDAP"; }
    if ($t =~ /imap/) { return "IMAP"; }
    if ($t =~ /smtp/) { return "SMTP"; }
    if ($t =~ /smb/) { return "SMB"; }
    if ($t =~ /netrc/) { return "netrc"; }
    if ($t =~ /mime/) { return "mime"; }
    if ($t =~ /sigv4/) { return "sigv4"; }
    if ($t =~ /pingpong/) { return "pingpong"; }
    if ($t =~ /negotiate/) { return "Negotiate"; }
    if ($t =~ /digest/) { return "Digest"; }
    if ($t =~ /sasl/) { return "SASL"; }
    if ($t =~ /asn\.?1/) { return "ASN1"; }
    if ($t =~ /telnet/) { return "TELNET"; }
    if ($t =~ /gzip/) { return "gzip"; }
    if ($t =~ /dns/) { return "DNS"; }
    if ($t =~ /proxy/) { return "proxy"; }
    if ($t =~ /conn(?:ection)? reuse|reus(?:e|ing) connection/) { return "connreuse"; }
    if ($title =~ /\bURL\b|unescape/ || $t =~ /\burl\b/) { return "URL"; }
    if ($t =~ /openssl/) { return "OpenSSL"; }
    if ($t =~ /tls|ssl|schannel|wolfssl|gnutls|mbedtls|cert|ocsp/) { return "TLS"; }
    if ($t =~ /http/) { return "HTTP"; }
    if ($t =~ /\btool\b|--write-out|-j /) { return "tool"; }

    # Fallback to checking advisory body
    if ($c =~ /schannel|gnutls|wolfssl|openssl|mbedtls|polarssl/) { return "TLS"; }
    if ($c =~ /conn(?:ection)? reuse/) { return "connreuse"; }
    if ($c =~ /cookies?/) { return "cookie"; }
    return "internal";
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
    my $page;
    if ($content =~ /\[Permalink\]\(https:\/\/curl\.se\/docs\/([^)]+)\)/i) {
        $page = $1;
    } elsif ($cve) {
        $page = "$cve.html";
    }

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
    my $report_text = $content;
    $report_text =~ s/\[([^\]]+)\]\([^)]+\)/$1/g;
    $report_text =~ s/\s+/ /g;
    if ($report_text =~ /(?:reported to the curl project on|first reported[ a-z]* on)\s+([A-Za-z]+ \d+(?:st|nd|rd|th)?,?\s+\d{4})/i) {
        $report = parsedate($1);
    }

    # CWE
    my $cwe;
    for my $l (@lines) {
        if ($l =~ /^\s*(CWE-\d+:\s*.*?)\s*$/) {
            $cwe = $1;
            last;
        }
    }

    my $award = $opt{award} // 0;
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

    # Issue link
    my $issue = $opt{issue};
    if (!$issue) {
        if ($content =~ /(https:\/\/hackerone\.com\/reports\/\d+)/i) {
            $issue = $1;
        } elsif ($content =~ /(https:\/\/github\.com\/curl\/curl\/issues\/\d+)/i) {
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
