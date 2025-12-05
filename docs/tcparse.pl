#!/usr/bin/env perl

# Parse markdown FAQ to generate hierarchical table of contents with numbered entries

use strict;
use warnings;

sub make_section_anchor {
    my ($title) = @_;
    # remove "special" letters
    $title =~ s/[^A-Za-z0-9_ ]//g;
    # make dashes for spaces
    $title =~ s/ /-/g;
    return $title;
}

sub make_anchor {
    my $title = shift;
    my $anchor = substr($title, 0, 32);
    # filter off "odd" chars
    $anchor =~ s/[^a-z0-9A-Z]/_/g;
    # filter off trailing underscores
    $anchor =~ s/_+\z//;
    # filter off initial underscores
    $anchor =~ s/^_+//;
    # filter off multiple underscores
    $anchor =~ s/_+/_/g;
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
        my $anchor = make_section_anchor($title);
        
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

# Create a lookup hash for anchors by title
my %anchor_by_title;
foreach my $section (@sections) {
    $anchor_by_title{$section->{title}} = $section->{anchor};
    foreach my $question (@{$section->{questions}}) {
        # Store with original unescaped title for matching
        my $orig_title = $question->{title};
        $orig_title =~ s/&amp;/&/g;
        $orig_title =~ s/&lt;/</g;
        $orig_title =~ s/&gt;/>/g;
        $orig_title =~ s/&#42;&#47;/\*\//g;
        $orig_title =~ s/&#47;&#42;/\/\*/g;
        $anchor_by_title{$orig_title} = $question->{anchor};
        
        foreach my $subq (@{$question->{subquestions}}) {
            my $orig_subq_title = $subq->{title};
            $orig_subq_title =~ s/&amp;/&/g;
            $orig_subq_title =~ s/&lt;/</g;
            $orig_subq_title =~ s/&gt;/>/g;
            $orig_subq_title =~ s/&#42;&#47;/\*\//g;
            $orig_subq_title =~ s/&#47;&#42;/\/\*/g;
            $anchor_by_title{$orig_subq_title} = $subq->{anchor};
        }
    }
}

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

# Third pass: output the content with modified id attributes
print "\n<!-- CONTENT WITH MODIFIED IDS -->\n\n";

open $in, '<', $input or die "Cannot reopen input file '$input': $!\n";

my @paragraph_lines = ();
my $in_paragraph = 0;

sub flush_paragraph {
    if (@paragraph_lines) {
        # Join the lines and wrap in <p> tags
        my $content = join("\n", @paragraph_lines);
        print "<p>$content</p>\n";
        @paragraph_lines = ();
    }
    $in_paragraph = 0;
}

while (my $line = <$in>) {
    chomp $line;
    
    # Skip # heading (level 1, e.g., #FAQ)
    if ($line =~ /^#\s+(.+)$/) {
        flush_paragraph();
        next;
    }
    # Match ## heading (section)
    elsif ($line =~ /^##\s+(.+)$/) {
        flush_paragraph();
        my $title = $1;
        my $anchor = $anchor_by_title{$title};
        print "<h2 id=\"$anchor\">$title</h2>\n";
    }
    # Match ### heading (question)
    elsif ($line =~ /^###\s+(.+)$/) {
        flush_paragraph();
        my $title = $1;
        my $anchor = $anchor_by_title{$title};
        print "<h3 id=\"$anchor\">$title</h3>\n";
    }
    # Match #### heading (sub-question)
    elsif ($line =~ /^####\s+(.+)$/) {
        flush_paragraph();
        my $title = $1;
        my $anchor = $anchor_by_title{$title};
        print "<h4 id=\"$anchor\">$title</h4>\n";
    }
    # Blank line ends current paragraph
    elsif ($line =~ /^\s*$/) {
        flush_paragraph();
        print "\n";
    }
    else {
        # Convert markdown angle bracket links to HTML anchors
        # Convert <https://github.com/curl/curl/issues/12345> to <a href="...">curl/curl#12345</a>
        $line =~ s/<(https?:\/\/github\.com\/curl\/curl\/issues\/(\d+))>/<a href="$1">curl\/curl#$2<\/a>/g;
        # Convert <https://github.com/curl/curl/pull/12345> to <a href="...">curl/curl#12345</a>
        $line =~ s/<(https?:\/\/github\.com\/curl\/curl\/pull\/(\d+))>/<a href="$1">curl\/curl#$2<\/a>/g;
        # Convert other GitHub links generically
        $line =~ s/<(https?:\/\/github\.com\/([^\/]+)\/([^\/]+)\/issues\/(\d+))>/<a href="$1">$2\/$3#$4<\/a>/g;
        $line =~ s/<(https?:\/\/github\.com\/([^\/]+)\/([^\/]+)\/pull\/(\d+))>/<a href="$1">$2\/$3#$4<\/a>/g;
        # Convert other angle bracket URLs to simple links
        $line =~ s/<(https?:\/\/[^>]+)>/<a href="$1">$1<\/a>/g;
        
        # Add line to current paragraph
        push @paragraph_lines, $line;
        $in_paragraph = 1;
    }
}

# Flush any remaining paragraph
flush_paragraph();

close $in;
