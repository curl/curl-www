
struct apps {
  int fd;       /* the socket of the handler */
  CURL *easy_h; /* the curl easy handler */
  int what;     /* what to check for in this socket */
  int timeout;  /* when to timeout */
};

int nsockets; /* simple-minded but here to show */

CURLM *multi_h;

/* this callback might very well be called multiple times for a single easy
   handle. Both to change the state of the 'what' but also to make it deal
   with more than one socket. */
int curl_socket_callback(CURL *easy,      /* easy handle */
                         curl_socket_t s, /* socket */
                         int what,        /* Why i was called */
                         long ms,         /* timeout for wait */
                         void *userp);    /* "private" pointer */
{
  struct apps *my_s =(struct apps *)userp;

  /* note that this is blatantly assuming that we haven't got info about this
     particular socket before. a real implementation would need to do this
     better and differently */
  my_s[nsockets].fd = s;
  my_s[nsockets].what = what;
  my_s[nsockets].timeout = ms;
  my_s[nsockets].easy_h = easy;

  nsockets++;
  
  return 0;

} /* end of callback */

#define NSOCKETS 1000 /* suitable number, or make code that can realloc this to
                         a larger number should the need arise */

#define NEASYHANDLES 200 /* the number of simultaneous transfers we support */

void main(int argc, char **argv)
{

  struct apps my_s[NSOCKETS];
  CURL *easyh[NEASYHANDLES];

  /* setup all easy handles */
  
  easyh[0] = curl_easy_init();
  easyh[1] = curl_easy_init();
  easyh[2] = curl_easy_init();
  ...;

  /* get a multi handle */
  multi_h = curl_multi_init();

  /* add all easy handles */
  for(i=0; i <= NEASYHANDLES; i++)
    curl_multi_add_handle(multi_h, easy_h[i]);

  /* open up your own sockets, pipes, file handles and whatever you want to
     use in your app */
  
  /* start the transfers */
  curl_multi_socket_all(multi_h,
                        curl_socket_callback,
                        my_s); /* pass our array to the callback */

  /* at this point, you should have got to know about a fair amount of
     sockets from libcurl and you have your own set, wait for action */

  for(i=0; i<nsockets; i++) {
    /* Set up structs to enable waiting on action on sockets.  This could
       involve setting fd_sets for select(), or filling in pollfd structs for
       poll() or other things depending on what underlying function/system you
       intend to use */

    ...;
  }

  do {
  
    /* Wait for action(s) on sockets or timeout. The action can be on your own
       sockets or on libcurl's sockets. */

    hang_around_till_something_should_be_done();

    /* If the function returned and there is action to be done on a libcurl
       socket, you figure out what socket it was and what the related easy
       handle for it is, and you call curl_multi_socket() telling libcurl.
       You point out a callback and userp again since libcurl may very well
       update the state of its sockets for us.*/
    
    curl_multi_socket(multi_h, thissocket, thiseasyh
                      curl_socket_callback, my_s);

  } while(!done);
    
  cleanups();

  return 0; /* success! */
}
