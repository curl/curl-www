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

WHERE2(Development, "/dev/", Project status dashboard)
TITLE(Dashboard)
<div class="relatedbox">
<b>Related:</b>
<br><a href="https://github.com/curl/stats/issues/new?title=bug%20in%20graph" target="_new">File a bug about a graph</a>
<br><a href="/docs/">Online Docs</a>
<br><a href="/gitstats/">gitstats</a>
</div>
<p>
  Daily updated graphs showing the state of the curl project in as much detail as possible.

#if !defined(DASHDATA) && !defined(COL1)
Click the images for full resolution.
#endif

<br>
#ifndef COL1
  [<a href="dashboard1.html">1 column</a>]
#else
  [1 column]
#endif
#if !defined(COL3) || defined(DASHDATA)
  [<a href="dashboard.html">3 columns</a>]
#else
  [3 columns]
#endif
#if !defined(COL5) || defined(DASHDATA)
  [<a href="dashboard5.html">5 columns</a>]
#else
  [5 columns]
#endif
#ifndef DASHDATA
  [<a href="dashboardd.html">data view</a>]
#else
  [data view]
#endif
<p>

#ifdef DASHDATA

Each image below links to the corresponding CSV file with recently updated
source data. The first and last lines of data is shown on the right.

#endif
#include "dash.gen"

<p>
<hr>
 The scripts for generating all these images are available
 at <a href="https://github.com/curl/stats">github.com/curl/stats</a>.

#include "_footer.html"
</BODY>
</HTML>
