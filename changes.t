#define CHG <li>
#define BGF <li>

#ifdef CURL_CHANGES_IN_VERSION
#define RELEASEVIDEO(ver,vid) \
<div class="video"><a href=vid>ver</a> </div>\
<div class="vulnbox"><a href=/docs/vuln-ver.html>ver</a></div> \
<div style="clear: both;">&nbsp;</div>

#define VULNBOX(ver) \
<div class="vulnbox"><a href=/docs/vuln-ver.html>ver</a></div> \
<div style="clear: both;">&nbsp;</div>

#define THISBOX(x)

#else

#define RELEASEVIDEO(ver,vid) \
<div class="video"><a href=vid>ver</a> </div>\
<div class="vulnbox"><a href=/docs/vuln-ver.html>ver</a></div> \
<div class="thisver"><a href=/ch/ver.html>ver</a> changes only</div> \
<div style="clear: both;">&nbsp;</div>

#define VULNBOX(ver) \
<div class="vulnbox"><a href=/docs/vuln-ver.html>ver</a></div> \
<div class="thisver"><a href=/ch/ver.html>ver</a> changes only</div> \
<div style="clear: both;">&nbsp;</div>

#define THISBOX(ver) \
<div class="thisver"><a href=/ch/ver.html>ver</a> changes only</div> \
<div style="clear: both;">&nbsp;</div>
#endif
