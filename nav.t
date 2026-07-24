#ifndef __NAV_T
#define __NAV_T

#define SITENAV_OPEN \
<nav class="sitenav" aria-label="Primary navigation">

#define SITENAV_CONTROLS \
<input class="sitenav-state" type="checkbox" id="sitenav-state"> \
<label class="sitenav-toggle" for="sitenav-state"> \
  <span class="sitenav-toggle-icon" aria-hidden="true"></span> \
  <span>Menu</span> \
</label>

#define SITENAV_LIST_OPEN \
<ul class="sitenav-list">

#define SITENAV_LIST_CLOSE \
</ul>

#define SITENAV_CLOSE \
</nav>

#define SITENAV_GROUP_OPEN(label) \
<li class="sitenav-item"> \
  <details class="sitenav-disclosure" name="sitenav-submenus"> \
    <summary class="sitenav-summary"> \
      <span class="sitenav-label">label</span> \
    </summary> \
    <ul class="sitenav-submenu">

#define SITENAV_GROUP_CLOSE \
    </ul> \
  </details> \
</li>

#define SITENAV_OVERVIEW(url,label) \
<li><a class="sitenav-overview" href="url">label</a></li>

#define SITENAV_LINK(url,label) \
<li class="sitenav-item"><a class="sitenav-link" href="url">label</a></li>

#define SITENAV_SELECTED_LINK(url,label) \
<li class="sitenav-item"><a class="sitenav-link itemselect" href="url" aria-current="page">label</a></li>

#define SITENAV_TITLED_LINK(url,label,titletext) \
<li class="sitenav-item"><a class="sitenav-link menuitem" href="url" title="titletext">label</a></li>

#endif /* __NAV_T */
