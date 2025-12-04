#!/usr/bin/env perl

# Parse markdown FAQ to generate hierarchical table of contents with numbered entries

use strict;
use warnings;

sub make_anchor {
    my $title = shift;
    my $anchor = $title;
    $anchor =~ s/\//_/g;             # forward slash to underscore
    $anchor =~ s/[^\w\s]//g;         # remove non-word chars (keep spaces)
    $anchor =~ s/\s+/_/g;            # spaces to underscores
    $anchor = substr($anchor, 0, 30); # truncate to 30 characters
    return $anchor;
}

my $input = $ARGV[0] or die "Usage: $0 <input-file>\n";

open my $in, '<', $input or die "Cannot open input file '$input': $!\n";

# First pass: collect all sections and questions
my @sections;
my $current_section;
my $current_question;

while (my $line = <$in>) {
    chomp $line;
    
    # Match ## heading (section)
    if ($line =~ /^##\s+(.+)$/) {
        my $title = $1;
        my $anchor = make_anchor($title);
        
        $current_section = {
            title => $title,
            anchor => $anchor,
            questions => []
        };
        push @sections, $current_section;
        $current_question = undef;
    }
    # Match ### heading (question)
    elsif ($line =~ /^###\s+(.+)$/ && $current_section) {
        my $title = $1;
        my $anchor = make_anchor($title);
        
        # HTML escape the title
        my $escaped_title = $title;
        $escaped_title =~ s/&/&amp;/g;
        $escaped_title =~ s/</&lt;/g;
        $escaped_title =~ s/>/&gt;/g;
        # Escape C comment delimiters for fcpp
        $escaped_title =~ s/\*\//&#42;&#47;/g;  # */
        $escaped_title =~ s/\/\*/&#47;&#42;/g;  # /*
        
        $current_question = {
            title => $escaped_title,
            anchor => $anchor,
            subquestions => []
        };
        push @{$current_section->{questions}}, $current_question;
    }
    # Match #### heading (sub-question)
    elsif ($line =~ /^####\s+(.+)$/ && $current_question) {
        my $title = $1;
        my $anchor = make_anchor($title);
        
        # HTML escape the title
        my $escaped_title = $title;
        $escaped_title =~ s/&/&amp;/g;
        $escaped_title =~ s/</&lt;/g;
        $escaped_title =~ s/>/&gt;/g;
        # Escape C comment delimiters for fcpp
        $escaped_title =~ s/\*\//&#42;&#47;/g;  # */
        $escaped_title =~ s/\/\*/&#47;&#42;/g;  # /*
        
        push @{$current_question->{subquestions}}, {
            title => $escaped_title,
            anchor => $anchor
        };
    }
}

close $in;

# Second pass: generate HTML output with linked section headings and grouped questions
my $section_num = 0;

foreach my $section (@sections) {
    $section_num++;
    
    # Output section heading as a link
    print "<h2><a href=\"#$section->{anchor}\">$section->{title}</a></h2>\n";
    
    # Start paragraph for questions
    if (@{$section->{questions}} > 0) {
        print "<p>\n";
        
        my $question_num = 0;
        foreach my $question (@{$section->{questions}}) {
            $question_num++;
            
            # Output question link
            print "<a href=\"#$question->{anchor}\">$question->{title}</a><br>\n";
            
            # Output sub-questions if any
            foreach my $subq (@{$question->{subquestions}}) {
                print "<a href=\"#$subq->{anchor}\">$subq->{title}</a><br>\n";
            }
        }
        
        print "</p>\n";
    }
}
