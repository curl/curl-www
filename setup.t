#define TITLEPRE  <p class="pagetitle">
#define TITLEPOST </p>

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
