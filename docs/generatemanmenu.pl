#!/usr/bin/env perl

use strict;
use warnings;
use File::Glob ':glob';

# Taking path as argument.
my $cmdlineOptions = "$ARGV[0]";

# Indent for HTML in variable.
my $htmlIndent = "      ";

# Count the number of options and output in comment
# to ensure all options output. This can be deleted.
my $optionCount = 0;

# Loop through all option files from argument.
foreach my $filename (bsd_glob("$cmdlineOptions/*.d")) {
 # either long or short
 my ($shortOpt, $longOpt) = ("", "");
 # account for options with version numbers
 my ($shortVersionOpt, $longVersionOpt) = ("", "");
 # open each file
	open my $fh, "<", $filename or die "path error: $!";
 # check for long and short in opt.d
	while (my $currentLine = <$fh>) {
   if ($currentLine =~ /^Short: (.*)/) {
     # check for options with versions
     if ($currentLine =~ /^Short: (.*)(\d+)\.(\d+)$/) {
       $shortOpt = "-$1$2.$3"; $shortVersionOpt = "-$1$2$3";     
     } else { # else only name
       $shortOpt = "-$1"; $shortVersionOpt = "-$1";
     }     
   }
   if ($currentLine =~ /^Long: (.*)/) {
     # check for options with versions
     if ($currentLine =~ /^Long: (.*)(\d+)\.(\d+)$/) {
       $longOpt = "--$1$2.$3"; $longVersionOpt = "--$1$2$3";
     } else { # else only name
       $longOpt = "--$1"; $longVersionOpt = "--$1";
     }
   }
	}
 # done with current file
	close $fh;
 
 # check the options from file
 if ($shortOpt && $longOpt) {
  print "$htmlIndent<a href=\"#$shortVersionOpt\">$shortOpt, $longOpt</a>\n"; $optionCount++;  
 } # else if long option
 elsif ($longOpt) {
   print "$htmlIndent<a href=\"#$longVersionOpt\">$longOpt</a>\n"; $optionCount++;
 } # else if short to future proof
 elsif ($shortOpt) {
   print "$htmlIndent<a href=\"#$shortVersionOpt\">$shortOpt</a>\n"; $optionCount++;
 }
 }
# Output options counted in html comment.
print "$htmlIndent<!-- $optionCount options generated -->\n";
# Close the _manpage-option-menu.html template.
print "    </div>\n";
print "  </div>\n";
