# curl-www

This is (most of) the curl.se website contents. It mostly builds static
HTML files that are preprocessed.

## Prerequisites

The website is a on old custom made setup that mostly builds static HTML
files from a set of source files using (GNU) `make`. The sources files are
preprocessed with what is basically a souped-up C preprocessor called `fcpp`
and a set of `perl` scripts. The manpages get converted to HTML with
`roffit`.

Markdown is converted to HTML with `pandoc`.

Make sure the following tools are in your $PATH.

 - curl
 - [fcpp](https://daniel.haxx.se/projects/fcpp/)
 - GNU date
 - GNU enscript
 - GNU make
 - pandoc
 - perl (with CPAN packages: CGI, HTML::Entities)
 - [roffit](https://daniel.haxx.se/projects/roffit/)
 - zip

## Build

Once you have cloned the Git repo the first time, invoke `sh bootstrap.sh` once
to get a symlink and some initial local files setup, and then you can build the
website locally by invoking make in the source root tree.

Note that this does not make you a complete website mirror, as some scripts
and files are only available on the real actual site, but should give you
enough to let you load most HTML pages locally.

## Edit the web

[Web editing guidelines](https://curl.se/web-editing.html)

# curl.local

To run a local copy of the curl website, have a local Apache or python
to serve `curl.local` on `127.0.0.1`. Add this line to `/etc/hosts`:

    127.0.0.1 curl.local

## Apache httpd config

A config file for apache2 to run a virtual server for `curl.local` on your
local machine might look like this:

~~~
<VirtualHost *:80>
    ServerName curl.local
    ServerAdmin [my email address]
    DocumentRoot [full path to the curl-www build]

    ErrorLog ${APACHE_LOG_DIR}/curllocal-error.log
    CustomLog ${APACHE_LOG_DIR}/curllocal-access.log combined
</VirtualHost>

<Directory [full path to the curl-www build]>
   Options Indexes Includes FollowSymLinks ExecCGI
   AllowOverride All
   AddHandler cgi-script .cgi
   Require all granted
</Directory>
~~~

## Python3

From the directory containing the website, run:

    python3 -m http.server --cgi -b curl.local 8000
