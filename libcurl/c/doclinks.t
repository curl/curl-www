#if 0
#define THIS(x) <td><font color="#9f7171" size=+1><b>x</b></font></td>
#define DOC(x,y) <td><a href="y"><font color="#9f7171" size=-1>x</font></a></td>
#else
#undef THIS
#undef DOC
#define THIS(t) <tr><td align=right><font color="#705050"><b>t</b></font></td></tr>
#define DOC(t,l) <tr><td align=right><a href=/libcurl/c/l><font color="#705050">t</font></a></tr>
#endif

#ifdef DOCS_INDEX
THIS(index)
#else
DOC(index, .)
#endif

#ifdef DOCS_EASY_INIT
THIS(curl_easy_init)
#else
DOC(curl_easy_init, curl_easy_init.html)
#endif

#ifdef DOCS_EASY_CLEANUP
THIS(curl_easy_cleanup)
#else
DOC(curl_easy_cleanup, curl_easy_cleanup.html)
#endif

#ifdef DOCS_EASY_SETOPT
THIS(curl_easy_setopt)
#else
DOC(curl_easy_setopt, curl_easy_setopt.html)
#endif

#ifdef DOCS_EASY_PERFORM
THIS(curl_easy_perform)
#else
DOC(curl_easy_perform, curl_easy_perform.html)
#endif

#ifdef DOCS_EASY_GETINFO
THIS(curl_easy_getinfo)
#else
DOC(curl_easy_getinfo, curl_easy_getinfo.html)
#endif

#ifdef DOCS_ESCAPE
THIS(curl_escape)
#else
DOC(curl_escape, curl_escape.html)
#endif

#ifdef DOCS_FORMADD
THIS(curl_formadd)
#else
DOC(curl_formadd, curl_formadd.html)
#endif

#ifdef DOCS_FORMPARSE
THIS(curl_formparse)
#else
DOC(curl_formparse, curl_formparse.html)
#endif

#ifdef DOCS_FORMFREE
THIS(curl_formfree)
#else
DOC(curl_formfree, curl_formfree.html)
#endif

#ifdef DOCS_GETDATE
THIS(curl_getdate)
#else
DOC(curl_getdate, curl_getdate.html)
#endif

#ifdef DOCS_GETENV
THIS(curl_getenv)
#else
DOC(curl_getenv, curl_getenv.html)
#endif

#ifdef DOCS_GLOBAL_CLEANUP
THIS(curl_global_cleanup)
#else
DOC(curl_global_cleanup, curl_global_cleanup.html)
#endif

#ifdef DOCS_GLOBAL_INIT
THIS(curl_global_init)
#else
DOC(curl_global_init, curl_global_init.html)
#endif


#ifdef DOCS_MPRINTF
THIS(curl_mprintf)
#else
DOC(curl_mprintf, curl_mprintf.html)
#endif

#ifdef DOCS_SLIST_APPEND
THIS(curl_slist_append)
#else
DOC(curl_slist_append, curl_slist_append.html)
#endif

#ifdef DOCS_SLIST_FREE_ALL
THIS(curl_slist_free_all)
#else
DOC(curl_slist_free_all, curl_slist_free_all.html)
#endif

#ifdef DOCS_STREQUAL
THIS(curl_strequal)
#else
DOC(curl_strequal, curl_strequal.html)
#endif

#ifdef DOCS_UNESCAPE
THIS(curl_unescape)
#else
DOC(curl_unescape, curl_unescape.html)
#endif

#ifdef DOCS_VERSION
THIS(curl_version)
#else
DOC(curl_version, curl_version.html)
#endif
