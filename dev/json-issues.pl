#!/usr/bin/perl -w

use strict;
use JSON;

json_page("https://api.github.com/repos/curl/curl/issues");

binmode(STDOUT, ":utf8");

sub json_page
{
  my ($json_url) = @_;
  my @j = `curl -s $json_url -A bagder/curl-issues-poller -o issues.in -z issues.in`;

  open(F, "<issues.in");
  my $content = join("", <F>);
  close(F);

  my $json = new JSON;
  my $json_text = $json->decode($content);
  
  # iterate over each issue
  my $bugs = 0;
  my @out;

  push @out, "<table>\n";
  for my $ref (@$json_text) {
      my $link = $ref->{'html_url'};
      my $title = $ref->{'title'};
      my $num = $ref->{'number'};
      push @out, sprintf("<tr valign=top><td>#%d</td><td><a href=\"%s\">%s</a></td></tr>\n",
                         $num, $link, $title);
      $bugs++; 
  }
  push @out, "</table>\n";
  print @out;
}
