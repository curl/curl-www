#ifndef ROOT__SETUP_T
#define ROOT__SETUP_T

#define TITLEPRE  <h1 class="pagetitle">
#define TITLEPOST </h1>
#define TITLE(title) TITLEPRE title TITLEPOST
#define SUBTITLE(title) <h2> title </h2>

#define DATE(date) <b>date</b>
#define CURLSIZE(size) <i>size</i>

#define LINK(l,t) <a href="l" class="itemselect">t</a>
#define VLINK(l,t,itle) <a href="l" class="menuitem" title="itle">t</a>

#include "where.t"

#define START_OF_MAIN \
<div class="contents">

#endif /* ROOT__SETUP_T */
