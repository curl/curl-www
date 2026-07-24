#!/usr/bin/env perl
# Copyright (C) Daniel Stenberg, <daniel@haxx.se>, et al.
#
# SPDX-License-Identifier: curl

use strict;
use warnings;

use File::Basename qw(basename);
use File::Find qw(find);

my @problems;
my %files;
my $nav_pages = 0;

sub problem {
    my ($file, $message) = @_;
    push @problems, "$file: $message";
}

sub match_count {
    my ($text, $pattern) = @_;
    my $count = 0;
    while($text =~ /$pattern/g) {
        $count++;
    }
    return $count;
}

sub candidate {
    my ($path) = @_;
    my $name = basename($path);
    return if $name =~ /^_/;
    return if $name !~ /\.html\z/;
    $files{$path} = 1 if -f $path;
}

my $default_scan = !@ARGV;
my @roots = @ARGV ? @ARGV : ('.');
for my $root (@roots) {
    if(-f $root) {
        candidate($root);
    }
    elsif(-d $root) {
        find({
            no_chdir => 1,
            wanted => sub {
                my $path = $File::Find::name;
                if(-d $path) {
                    $File::Find::prune = 1 if basename($path) eq '.git';
                    return;
                }
                candidate($path);
            }
        }, $root);
    }
    else {
        problem($root, 'file or directory does not exist');
    }
}

my $nav_start = qr{
    <nav\b
    (?=[^>]*\bclass\s*=\s*(?:"[^"]*\bsitenav\b[^"]*"|'[^']*\bsitenav\b[^']*'))
    [^>]*>
}ix;

my $detail_start = qr{
    <details\b
    (?=[^>]*\bclass\s*=\s*(?:"[^"]*\bsitenav-disclosure\b[^"]*"|'[^']*\bsitenav-disclosure\b[^']*'))
    [^>]*>
}ix;

my $state_id = qr{\bid\s*=\s*(?:"sitenav-state"|'sitenav-state')}i;
my $state_for = qr{\bfor\s*=\s*(?:"sitenav-state"|'sitenav-state')}i;
my $group_name = qr{\bname\s*=\s*(?:"sitenav-submenus"|'sitenav-submenus')}i;
my $open_attribute = qr{\sopen(?:\s*=\s*(?:"[^"]*"|'[^']*'|[^\s>]+))?(?=\s|/?>)}i;
my $leaked_macro = qr{\b(SITENAV_[A-Z0-9_]+|START_OF_MAIN|__NAV_T|__MENU)\b};

for my $file (sort keys %files) {
    open(my $input, '<', $file) or do {
        problem($file, "cannot read: $!");
        next;
    };
    local $/;
    my $html = <$input>;
    close($input);

    my %leaked;
    while($html =~ /$leaked_macro/g) {
        $leaked{$1} = 1;
    }
    if(%leaked) {
        problem($file, 'leaked FCPP token(s): ' .
                join(', ', sort keys %leaked));
    }

    my $nav_count = match_count($html, $nav_start);
    next if !$nav_count;
    $nav_pages++;

    my @nav_blocks = ($html =~ /($nav_start.*?<\/nav\s*>)/gis);
    if($nav_count != 1) {
        problem($file, "expected one sitenav, found $nav_count");
    }
    if(@nav_blocks != $nav_count) {
        problem($file, 'could not match every sitenav start with a closing </nav>');
    }
    next if !@nav_blocks;

    my $nav = join("\n", @nav_blocks);
    my $id_count = match_count($nav, $state_id);
    my $for_count = match_count($nav, $state_for);
    if($id_count != 1) {
        problem($file, "expected one sitenav-state id, found $id_count");
    }
    if($for_count != 1) {
        problem($file, "expected one sitenav-state label, found $for_count");
    }

    my @detail_tags = ($nav =~ /($detail_start)/g);
    my $detail_number = 0;
    for my $tag (@detail_tags) {
        $detail_number++;
        my $name_count = match_count($tag, $group_name);
        if($name_count != 1) {
            problem($file, "disclosure $detail_number has $name_count sitenav-submenus name attributes");
        }
        if($tag =~ /$open_attribute/) {
            problem($file, "disclosure $detail_number starts open");
        }
    }

    my @detail_blocks = ($nav =~ /($detail_start.*?<\/details\s*>)/gis);
    if(@detail_blocks != @detail_tags) {
        problem($file, 'could not match every navigation disclosure with a closing </details>');
    }
    $detail_number = 0;
    for my $details (@detail_blocks) {
        $detail_number++;
        if($details !~ /<a\b/i) {
            problem($file, "disclosure $detail_number contains no links");
        }
    }
}

if($default_scan && !$nav_pages) {
    problem('navcheck', 'no generated sitenav pages found; run make first');
}

if(@problems) {
    print STDERR "$_\n" for @problems;
    print STDERR 'navcheck: ', scalar(@problems), " problem(s) found\n";
    exit 1;
}

print 'navcheck: ', $nav_pages, ' navigation page(s) checked across ',
    scalar(keys %files), " generated HTML file(s)\n";
