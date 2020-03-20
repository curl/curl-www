#include "_doctype.html"
<HTML>
<HEAD> <TITLE>curl - Project status dashboard</TITLE>
#include "css.t"
<style type="text/css">
.contents {
  max-width: 98%;
}
#ifdef COL3
img.dash {
  max-width: 30%;
}
#elif defined(COL5)
img.dash {
  max-width: 18%;
}
#endif
</style>
</HEAD>

#define CURL_DASHBOARD
#define CURL_URL dashboard.html

#include "setup.t"
#include "_menu.html"

WHERE1(Project status dashboard)
TITLE(Dashboard)
<div class="relatedbox">
<b>Related:</b>
<br><a href="/docs/">Online Docs</a>
<br><a href="/gitstats/">gitstats</a>
</div>
<p>
  Daily updated graphs showing the state of the curl project in as much detail as possible. Click the images
  for full resolution.<br>
#ifndef COL1
  [<a href="dashboard1.html">1 column</a>]
#else
  [1 column]
#endif
#ifndef COL3
  [<a href="dashboard.html">3 columns</a>]
#else
  [3 columns]
#endif
#ifndef COL5
  [<a href="dashboard5.html">5 columns</a>]
#else
  [5 columns]
#endif
<p>
#include "dash.gen"

<p>
<hr>
 The scripts for generating all these images are available
 at <a href="https://github.com/curl/stats">github.com/curl/stats</a>.

#include "_footer.html"
</BODY>
</HTML>
