#include "_doctype.html"
<html>
<head> <title>curl - Project status dashboard</title>
#include "css.t"
<style type="text/css">
.contents {
  max-width: 98%;
}

#ifdef COL3
.gr {
    width: 33%;
    float: left;
}

#elif defined(COL2)
.gr {
    width: 50%;
    float: left;
}

#elif defined(COL5)
.gr {
    width: 20%;
    float: left;
}
#endif
</style>
</head>

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
Columns:
#ifndef COL1
  <a href="dashboard1.html">1</a>
#else
  <b>1</b>
#endif
  &middot;
#if !defined(COL2) || defined(DASHDATA)
  <a href="dashboard2.html">2</a>
#else
  <b>2</b>
#endif
  &middot;
#if !defined(COL3) || defined(DASHDATA)
  <a href="dashboard.html">3</a>
#else
  <b>3</b>
#endif
  &middot;
#if !defined(COL5) || defined(DASHDATA)
  <a href="dashboard5.html">5</a>
#else
  <b>5</b>
#endif
 |
#ifndef DASHDATA
 <a href="dashboardd.html">data view</a>
#else
 <b>data view</b>
#endif
<p>

#ifdef DASHDATA

Each image below links to the corresponding CSV file with recently updated
source data. The first and last lines of data is shown on the right.

#endif
#include "dash.gen"
<hr style="margin-top: 3em;">
<p>
 The scripts for generating all these images are available
 at <a href="https://github.com/curl/stats">github.com/curl/stats</a>.

#include "_footer.html"
</body>
</html>
