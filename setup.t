#define TITLEPRE  <p> \
<table width="100%" cellspacing=0 cellpadding=1 bgcolor="#000000"><tr><td> \
<table width="100%" cellspacing=0 bgcolor="#e0e0ff"><tr><td> \
<font color="#0000ff" size="+2">

#define TITLEPOST </font> \
</td></tr></table></td></tr></table>

#define TITLE(title) TITLEPRE \
title \
TITLEPOST

#define SUBTITLE(title) \
<h2> \
title \
</h2>

#define DATE(date) <b>date</b>
#define CURLSIZE(size) <i>size</i>

#include "where.t"
