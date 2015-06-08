#ifndef ROOT__SETUP_T
#define ROOT__SETUP_T

#define TITLEPRE  <h1 class="pagetitle">
#define TITLEPOST </h1>
#define TITLE(title) TITLEPRE title TITLEPOST
#define SUBTITLE(title) <h2> title </h2>

#define DATE(date) <b>date</b>
#define CURLSIZE(size) <i>size</i>

#define LINK(l,t) <div><a href="l" class="itemselect">t</a></div>
#define VLINK(l,t,itle) <div><a href="l" class="menuitem" title="itle">t</a></div>

#include "where.t"

/* define to use after the menu */
#define START_OF_MAIN \
<input type="checkbox" id="nav-trigger" class="nav-trigger" /> \
<label for="nav-trigger"></label> \
<div class="main"> \
<div class="contents">

#endif /* ROOT__SETUP_T */
