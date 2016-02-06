#ifdef DOCS_OVERVIEW
LINK("https://curl.haxx.se/libcurl/c/libcurl.html", Overview)
#else
VLINK("https://curl.haxx.se/libcurl/c/libcurl.html", Overview, Overview)
#endif

#ifdef DOCS_TUTORIAL
LINK("https://curl.haxx.se/libcurl/c/libcurl-tutorial.html", Tutorial)
#else
VLINK("https://curl.haxx.se/libcurl/c/libcurl-tutorial.html", Tutorial, Tutorial)
#endif

#ifdef DOCS_ERRORS
LINK("https://curl.haxx.se/libcurl/c/libcurl-errors.html", Errors)
#else
VLINK("https://curl.haxx.se/libcurl/c/libcurl-errors.html", Errors, Error Codes)
#endif

#ifdef LIBCURL_EXAMPLE
LINK("https://curl.haxx.se/libcurl/c/example.html", Examples)
#else
VLINK("https://curl.haxx.se/libcurl/c/example.html", Examples, libcurl C source code examples )
#endif

#ifdef DOCS_SYMBOLS
LINK("https://curl.haxx.se/libcurl/c/symbols-in-versions.html", Symbols)
#else
VLINK("https://curl.haxx.se/libcurl/c/symbols-in-versions.html", Symbols, In which versions were which symbols introduced)
#endif

#ifdef DOCS_ALLFUNCS
LINK("https://curl.haxx.se/libcurl/c/allfuncs.html", Index)
#else
VLINK("https://curl.haxx.se/libcurl/c/allfuncs.html", Index, List of all libcurl functions)
#endif

#ifdef DOCS_OVERVIEW_EASY
LINK("https://curl.haxx.se/libcurl/c/libcurl-easy.html", Easy Interface)
#else
VLINK("https://curl.haxx.se/libcurl/c/libcurl-easy.html", Easy Interface, Easy interface tutorial)
#endif

#ifdef DOCS_OVERVIEW_MULTI
LINK("https://curl.haxx.se/libcurl/c/libcurl-multi.html", Multi Interface)
#else
VLINK("https://curl.haxx.se/libcurl/c/libcurl-multi.html", Multi Interface, Multi Interface tutorial)
#endif

#ifdef DOCS_OVERVIEW_SHARE
LINK("https://curl.haxx.se/libcurl/c/libcurl-share.html", Share Interface)
#else
VLINK("https://curl.haxx.se/libcurl/c/libcurl-share.html", Share Interface, Share Interface Tutorial)
#endif

#ifdef MENU_EASYx
<br>
#ifdef DOCS_EASY_ESCAPE
LINK("https://curl.haxx.se/libcurl/c/curl_easy_escape.html", curl_easy_escape)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_escape.html", curl_easy_escape, curl_easy_escape)
#endif

#ifdef DOCS_EASY_INIT
LINK("https://curl.haxx.se/libcurl/c/curl_easy_init.html", curl_easy_init)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_init.html", curl_easy_init, curl_easy_init)
#endif

#ifdef DOCS_EASY_CLEANUP
LINK("https://curl.haxx.se/libcurl/c/curl_easy_cleanup.html", curl_easy_cleanup)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_cleanup.html", curl_easy_cleanup, curl_easy_cleanup)
#endif

#ifdef DOCS_EASY_DUPHANDLE
LINK("https://curl.haxx.se/libcurl/c/curl_easy_duphandle.html", curl_easy_duphandle)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_duphandle.html", curl_easy_duphandle, curl_easy_duphandle)
#endif

#ifdef DOCS_EASY_GETINFO
LINK("https://curl.haxx.se/libcurl/c/curl_easy_getinfo.html", curl_easy_getinfo)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_getinfo.html", curl_easy_getinfo, curl_easy_getinfo)
#endif

#ifdef DOCS_EASY_PAUSE
LINK("https://curl.haxx.se/libcurl/c/curl_easy_pause.html", curl_easy_pause)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_pause.html", curl_easy_pause, curl_easy_pause)
#endif

#ifdef DOCS_EASY_PERFORM
LINK("https://curl.haxx.se/libcurl/c/curl_easy_perform.html", curl_easy_perform)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_perform.html", curl_easy_perform, curl_easy_perform)
#endif

#ifdef DOCS_EASY_RECV
LINK("https://curl.haxx.se/libcurl/c/curl_easy_recv.html", curl_easy_recv)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_recv.html", curl_easy_recv, curl_easy_recv)
#endif

#ifdef DOCS_EASY_RESET
LINK("https://curl.haxx.se/libcurl/c/curl_easy_reset.html", curl_easy_reset)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_reset.html", curl_easy_reset, curl_easy_reset)
#endif

#ifdef DOCS_EASY_SEND
LINK("https://curl.haxx.se/libcurl/c/curl_easy_send.html", curl_easy_send)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_send.html", curl_easy_send, curl_easy_send)
#endif

#ifdef DOCS_EASY_SETOPT
LINK("https://curl.haxx.se/libcurl/c/curl_easy_setopt.html", curl_easy_setopt)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_setopt.html", curl_easy_setopt, curl_easy_setopt)
#endif

#ifdef DOCS_EASY_STRERROR
LINK("https://curl.haxx.se/libcurl/c/curl_easy_strerror.html", curl_easy_strerror)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_strerror.html", curl_easy_strerror, curl_easy_strerror)
#endif

#ifdef DOCS_EASY_UNESCAPE
LINK("https://curl.haxx.se/libcurl/c/curl_easy_unescape.html", curl_easy_unescape)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_easy_unescape.html", curl_easy_unescape, curl_easy_unescape)
#endif

#ifdef DOCS_FORMADD
LINK("https://curl.haxx.se/libcurl/c/curl_formadd.html", curl_formadd)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_formadd.html", curl_formadd, curl_formadd)
#endif

#ifdef DOCS_FORMFREE
LINK("https://curl.haxx.se/libcurl/c/curl_formfree.html", curl_formfree)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_formfree.html", curl_formfree, curl_formfree)
#endif

#ifdef DOCS_FREE
LINK("https://curl.haxx.se/libcurl/c/curl_free.html", curl_free)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_free.html", curl_free, curl_free)
#endif

#ifdef DOCS_GETDATE
LINK("https://curl.haxx.se/libcurl/c/curl_getdate.html", curl_getdate)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_getdate.html", curl_getdate, curl_getdate)
#endif

#ifdef DOCS_GLOBAL_CLEANUP
LINK("https://curl.haxx.se/libcurl/c/curl_global_cleanup.html", curl_global_cleanup)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_global_cleanup.html", curl_global_cleanup, curl_global_cleanup)
#endif

#ifdef DOCS_GLOBAL_INIT
LINK("https://curl.haxx.se/libcurl/c/curl_global_init.html", curl_global_init)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_global_init.html", curl_global_init, curl_global_init)
#endif

#ifdef DOCS_GLOBAL_INIT_MEM
LINK("https://curl.haxx.se/libcurl/c/curl_global_init_mem.html", curl_global_init_mem)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_global_init_mem.html", curl_global_init_mem, curl_global_init_mem)
#endif

#ifdef DOCS_SLIST_APPEND
LINK("https://curl.haxx.se/libcurl/c/curl_slist_append.html", curl_slist_append)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_slist_append.html", curl_slist_append, curl_slist_append)
#endif

#ifdef DOCS_SLIST_FREE_ALL
LINK("https://curl.haxx.se/libcurl/c/curl_slist_free_all.html", curl_slist_free_all)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_slist_free_all.html", curl_slist_free_all, curl_slist_free_all)
#endif

#ifdef DOCS_VERSION
LINK("https://curl.haxx.se/libcurl/c/curl_version.html", curl_version)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_version.html", curl_version, curl_version)
#endif

#ifdef DOCS_VERSION_INFO
LINK("https://curl.haxx.se/libcurl/c/curl_version_info.html", curl_version_info)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_version_info.html", curl_version_info, curl_version_info)
#endif

#endif /* MENU_EASY */

#ifdef MENU_MULTIx
<br>
#ifdef DOCS_MULTI_ADD_HANDLE
LINK("https://curl.haxx.se/libcurl/c/curl_multi_add_handle.html", curl_multi_add_handle)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_add_handle.html", curl_multi_add_handle, curl_multi_add_handle)
#endif

#ifdef DOCS_MULTI_ASSIGN
LINK("https://curl.haxx.se/libcurl/c/curl_multi_assign.html", curl_multi_assign)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_assign.html", curl_multi_assign, curl_multi_assign)
#endif

#ifdef DOCS_MULTI_CLEANUP
LINK("https://curl.haxx.se/libcurl/c/curl_multi_cleanup.html", curl_multi_cleanup)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_cleanup.html", curl_multi_cleanup, curl_multi_cleanup)
#endif

#ifdef DOCS_MULTI_FDSET
LINK("https://curl.haxx.se/libcurl/c/curl_multi_fdset.html", curl_multi_fdset)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_fdset.html", curl_multi_fdset, curl_multi_fdset)
#endif

#ifdef DOCS_MULTI_INFO_READ
LINK("https://curl.haxx.se/libcurl/c/curl_multi_info_read.html", curl_multi_info_read)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_info_read.html", curl_multi_info_read, curl_multi_info_read)
#endif

#ifdef DOCS_MULTI_INIT
LINK("https://curl.haxx.se/libcurl/c/curl_multi_init.html", curl_multi_init)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_init.html", curl_multi_init, curl_multi_init)
#endif

#ifdef DOCS_MULTI_PERFORM
LINK("https://curl.haxx.se/libcurl/c/curl_multi_perform.html", curl_multi_perform)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_perform.html", curl_multi_perform, curl_multi_perform)
#endif

#ifdef DOCS_MULTI_REMOVE_HANDLE
LINK("https://curl.haxx.se/libcurl/c/curl_multi_remove_handle.html", curl_multi_remove_handle)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_remove_handle.html", curl_multi_remove_handle, curl_multi_remove_handle)
#endif

#ifdef DOCS_MULTI_SETOPT
LINK("https://curl.haxx.se/libcurl/c/curl_multi_setopt.html", curl_multi_setopt)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_setopt.html", curl_multi_setopt, curl_multi_setopt)
#endif

#ifdef DOCS_MULTI_SOCKET
LINK("https://curl.haxx.se/libcurl/c/curl_multi_socket.html", curl_multi_socket)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_socket.html", curl_multi_socket, curl_multi_socket)
#endif

#ifdef DOCS_MULTI_SOCKET_ACTION
LINK("https://curl.haxx.se/libcurl/c/curl_multi_socket_action.html", curl_multi_socket_action)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_socket_action.html", curl_multi_socket_action, curl_multi_socket_action)
#endif

#ifdef DOCS_MULTI_STRERROR
LINK("https://curl.haxx.se/libcurl/c/curl_multi_strerror.html", curl_multi_strerror)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_strerror.html", curl_multi_strerror, curl_multi_strerror)
#endif

#ifdef DOCS_MULTI_TIMEOUT
LINK("https://curl.haxx.se/libcurl/c/curl_multi_timeout.html", curl_multi_timeout)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_timeout.html", curl_multi_timeout, curl_multi_timeout)
#endif

#ifdef DOCS_MULTI_WAIT
LINK("https://curl.haxx.se/libcurl/c/curl_multi_wait.html", curl_multi_wait)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_multi_wait.html", curl_multi_wait, curl_multi_wait)
#endif

#endif /* MENU_MULTI */

#ifdef MENU_SHAREx
<br>
#ifdef DOCS_SHARE_CLEANUP
LINK("https://curl.haxx.se/libcurl/c/curl_share_cleanup.html", curl_share_cleanup)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_share_cleanup.html", curl_share_cleanup, curl_share_cleanup)
#endif

#ifdef DOCS_SHARE_INIT
LINK("https://curl.haxx.se/libcurl/c/curl_share_init.html", curl_share_init)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_share_init.html", curl_share_init, curl_share_init)
#endif

#ifdef DOCS_SHARE_SETOPT
LINK("https://curl.haxx.se/libcurl/c/curl_share_setopt.html", curl_share_setopt)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_share_setopt.html", curl_share_setopt, curl_share_setopt)
#endif

#ifdef DOCS_SHARE_STRERROR
LINK("https://curl.haxx.se/libcurl/c/curl_share_strerror.html", curl_share_strerror)
#else
VLINK("https://curl.haxx.se/libcurl/c/curl_share_strerror.html", curl_share_strerr, curl_share_strerr)
#endif


#endif /* MENU_SHARE */
