#!/usr/bin/env perl

# Output to stdout
my $OutManMenu = \*STDOUT;

# Make option menu current with most recent version of curl.
# Output options to file, remove first line, and make page for option menu.
my $curlPath = @ARGV[0];                   # store path to curl in variable
`$curlPath/src/curl -h all > options.txt`; # output options to text file
`sed -i 1d options.txt`;                   # remove first line in options.txt

# Store option file in variable
my $_options = "options.txt"; 

# Output opening html tags to stdout
print  $OutManMenu <<OPENMANMENUHTML
<!-- Option Search Menu -->
<div id="manpage-option-menu" class="sideStay sideStayLeft inactive" 
 data-to-side="1" data-on-side="0"> 
<!-- On Off button -->
  <button class="searchButtonToSide" id="searchButton" 
   onclick="toggleSearchButton(this.nextElementSibling, this)" data-onoff="0"
   onmouseenter="buttonToSide(1, this.dataset.onoff)" data-to-Side="1"
   onmouseleave="buttonToSide(0, this.dataset.onoff)">Show Options</button><br>
  <div style="display:none">
    <div class="searchBox">
      <label for="optionSearchField">Search Options</label><br>
      <img src="https://curl.se/logo/curl-symbol.svg" alt="curl symbol">
      <input id="optionSearchField" name="optionSearchField" placeholder="search options"
       type="search" oninput="searchOptions(this.value)">
    </div>
    <ul id="optionMenu">
      <!-- Start option list -->
      <div id="fullOptionList" style="display:none">
OPENMANMENUHTML
;

# Open options.txt to extract option names and output to _manpage-option-menu.html
open option_text, "<:encoding(UTF-8)", $_options or die $!;  

# Extract only the option text and output.
# Loop through option.txt and make "<li><a href="#">..</a></li>
while (my $row = <option_text>) {
  chomp $row;
  $row =~ s/^[[:space:]]*([^[:space:]]*-)/\1/;                   # remove starting space
  $row =~ s/^((-.*, --[^[:space:]]+)|(^--[^[:space:]]+)).*/\1/g; # remove text after option
  print $OutManMenu "        <li><a href=\"#\">$row</a></li>\n"; # append to stdout with correc indentation
}

# Close files, add closing tags, and remove files no longer needed.
close option_text;

# Output closing tags with _manpage-option-menu.html.
print $OutManMenu <<CLOSEMANMENUHTML

      </div>
    </ul>
  </div>
</div>
CLOSEMANMENUHTML
;

# Remove option file longer needed.
`rm options.txt`;
