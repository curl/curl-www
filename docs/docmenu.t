
#define HERE(l,t) <tr><td align=right><font color="#0000ff"><b>t</b></font></td></tr>
#define DOCREF(l,t) <tr><td align=right><a href=l><font color="#0000ff">t</font></a></tr>

#ifdef DOCS_BUGS
HERE(x, Bugs)
#else
DOCREF(bugs.html, Bugs)
#endif

#ifdef DOCS_CHANGES
HERE(x, Changes)
#else
DOCREF(changes.shtml, Changes)
#endif

#ifdef DOCS_COMPARISON
HERE(x, Comparison)
#else
DOCREF(comparison-table.html, Comparison)
#endif

#ifdef DOCS_CONTRIBUTE
HERE(x, Contribute)
#else
DOCREF(contribute.html, Contribute)
#endif

#ifdef DOCS_COPYRIGHT
HERE(x, Copyright)
#else
DOCREF(copyright.html, Copyright)
#endif

#ifdef DOCS_FAQ
HERE(x, FAQ)
#else
DOCREF(faq.shtml, FAQ)
#endif

#ifdef DOCS_FEATURES
HERE(x, Features)
#else
DOCREF(features.html, Features)
#endif

#ifdef DOCS_INSTALL
HERE(x, Install)
#else
DOCREF(install.html, Install)
#endif

#ifdef DOCS_INDEX
HERE(x, Index)
#else
DOCREF(./, Index)
#endif


#ifdef DOCS_INTERNALS
HERE(x, Internals)
#else
DOCREF(internals.shtml, Internals)
#endif

#ifdef DOCS_MANPAGE
HERE(x, Man Page)
#else
DOCREF(manpage.html, Man Page)
#endif

#if 0
#ifdef DOCS_README
HERE(x, README)
#else
DOCREF(readme.html, README)
#endif
#endif

#ifdef DOCS_README_CURL
HERE(x, Manual)
#else
DOCREF(readme.curl.html, Manual)
#endif

#ifdef DOCS_RESOURCES
HERE(x, Resources)
#else
DOCREF(resources.html, Resources)
#endif

#ifdef DOCS_THANKS
HERE(x, Thanks)
#else
DOCREF(thanks.html, Thanks)
#endif

#ifdef DOCS_HTTPSCRIPT
HERE(x, Tutorial)
#else
DOCREF(httpscripting.shtml, Tutorial)
#endif

#ifdef DOCS_TODO
HERE(x, TODO)
#else
DOCREF(todo.html, TODO)
#endif

#ifdef DOCS_VERSIONS
HERE(x, Versions)
#else
DOCREF(versions.html, Versions)
#endif

#ifdef DOCS_Y2K
HERE(x, Y2K)
#else
DOCREF(y2k.html, Y2K)
#endif


