
#define HERE LINK
#define DOCREF VLINK

DOCREF(/, Front Page)

#ifdef DOCS_INDEX
HERE(x, Docs Index)
#else
DOCREF(./, Docs Index)
#endif

#ifdef DOCS_BUGS
HERE(x, Bugs)
#else
DOCREF(bugs.html, Bugs)
#endif

#ifdef DOCS_CAEXTRACT
HERE(x, CA Extract)
#else
DOCREF(caextract.html, CA Extract)
#endif

#ifdef DOCS_CHANGES
HERE(x, Changelog)
#else
DOCREF(changes.html, Changelog)
#endif

#ifdef DOCS_COMPANIES
HERE(x, Companies)
#else
DOCREF(companies.html, Companies)
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
DOCREF(faq.html, FAQ)
#endif

#ifdef DOCS_FEATURES
HERE(x, Features)
#else
DOCREF(features.html, Features)
#endif

#ifdef DOCS_HISTORY
HERE(x, History)
#else
DOCREF(history.html, History)
#endif

#ifdef DOCS_INSTALL
HERE(x, Install)
#else
DOCREF(install.html, Install)
#endif

#ifdef DOCS_INTERNALS
HERE(x, Internals)
#else
DOCREF(internals.html, Internals)
#endif

#ifdef DOCS_KNOWNBUGS
HERE(x, Known Bugs)
#else
DOCREF(knownbugs.html, Known Bugs)
#endif

#ifdef DOCS_MANPAGE
HERE(x, Man Page)
#else
DOCREF(manpage.html, Man Page)
#endif

#ifdef DOCS_MANUAL
HERE(x, Manual)
#else
DOCREF(manual.html, Manual)
#endif

#ifdef DOCS_OS_DISTRIBUTIONS
HERE(x, OSes)
#else
DOCREF(osdistribs.html, OSes)
#endif

#ifdef DOCS_PRESS
HERE(x, Press)
#else
DOCREF(press.html, Press)
#endif

#ifdef DOCS_RELATED_TOOLS
HERE(x, Related Tools)
#else
DOCREF(relatedtools.html, Related Tools)
#endif

#ifdef DOCS_RESOURCES
HERE(x, Resources)
#else
DOCREF(resources.html, Resources)
#endif

#ifdef DOCS_SSLCERTS
HERE(x, SSL Certs)
#else
DOCREF(sslcerts.html, SSL Certs)
#endif

#ifdef DOCS_THANKS
HERE(x, Thanks)
#else
DOCREF(thanks.html, Thanks)
#endif

#ifdef DOCS_HTTPSCRIPT
HERE(x, Tutorial)
#else
DOCREF(httpscripting.html, Tutorial)
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


