use curl;

$curl = new Curl;

$doc = $curl->get("http://curl.haxx.se/");

print "Length: ".length($doc)."\n";

#print $doc;
