#if 0
#define THIS(x) <td><font color="#9f7171" size=+1><b>x</b></font></td>
#define DOC(x,y) <td><a href="y"><font color="#9f7171" size=-1>x</font></a></td>
#else
#undef THIS
#undef DOC
#define THIS(t) <tr><td align=right><font color="#705050"><b>t</b></font></td></tr>
#define DOC(t,l) <tr><td align=right><a href=l><font color="#705050">t</font></a></tr>
#endif

#ifdef DOCS_INDEX
THIS(index)
#else
DOC(index, .)
#endif

#ifdef DOCS_GUIDE
THIS(error codes)
#else
DOC(error codes, libcurl-errors.html)
#endif

#ifdef DOCS_GUIDE
THIS(tutorial)
#else
DOC(tutorial, the-guide.html)
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

THIS(<hr>)

#ifdef DOCS_OVERVIEW_MULTI
THIS(multi overview)
#else
DOC(multi overview, libcurl-multi.html)
#endif

#ifdef DOCS_MULTI_ADD_HANDLE
THIS(curl_multi_add_handle)
#else
DOC(curl_multi_add_handle, curl_multi_add_handle.html)
#endif

#ifdef DOCS_MULTI_CLEANUP
THIS(curl_multi_cleanup)
#else
DOC(curl_multi_cleanup, curl_multi_cleanup.html)
#endif

#ifdef DOCS_MULTI_FDSET
THIS(curl_multi_fdset)
#else
DOC(curl_multi_fdset, curl_multi_fdset.html)
#endif

#ifdef DOCS_MULTI_INFO_READ
THIS(curl_multi_info_read)
#else
DOC(curl_multi_info_read, curl_multi_info_read.html)
#endif

#ifdef DOCS_MULTI_INIT
THIS(curl_multi_init)
#else
DOC(curl_multi_init, curl_multi_init.html)
#endif

#ifdef DOCS_MULTI_PERFORM
THIS(curl_multi_perform)
#else
DOC(curl_multi_perform, curl_multi_perform.html)
#endif

#ifdef DOCS_MULTI_REMOVE_HANDLE
THIS(curl_multi_remove_handle)
#else
DOC(curl_multi_remove_handle, curl_multi_remove_handle.html)
#endif
