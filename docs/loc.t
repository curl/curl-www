#include "_doctype.html"
<HTML>
<HEAD> <TITLE>cURL - Lines Of Code</TITLE>
#include "css.t"
</HEAD>

#define CURL_DOCS
#define DOCS_LOC
#define CURL_URL docs/loc.html

#include "_menu.html"
#include "setup.t"

WHERE2(Docs, "/docs/", LOC)

TITLE(Lines of Code in curl and libcurl)
<p>
 By counting every line of all .c and .h files in the curl release archives
(including generated code and example code), starting with curl 4.8 (dated
late August 1998) and ending with the 7.10.7 package (August 2003), we have
produced a graph showing how the amount has changed over time.
<p>
 <a href="loc.png"><img border="0" src="loc-mini.png"></a>
<p>
 Interestingly, the growth has not decreased over time, but seems to be at a
steady rate of 8000 new lines of code every year... Since the size of the
generated code and the amount of examples increase, we can assume that the
growth rate of actual curl and libcurl code declines a little over time, but
not very much.

#include "_footer.html"

</BODY>
</HTML>
