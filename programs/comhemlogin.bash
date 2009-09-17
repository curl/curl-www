#!/bin/bash

# Version 2 (due to ComHem login changes at Oct 11 in the year 2000)

# Personal data (CHANGE the example!)

USERNAME="u1234567"
PASSWORD="ABcDe123"

# Path to cURL running in -silent mode and with -max transfer time 10 seconds
# (CHANGE if necessary)

CURL="/usr/local/bin/curl -s -m 10"

# This shell script was originally based on a perl script by
# Kjell.Ericson__at__haxx.se Intended use is to facilitate automatic
# logins on ComHem's (aka Telia) Internet Cable. Main tool is the
# u(r)ltimate URL processor cURL - which you'll find at
# http://curl.haxx.se or elsewhere. *NIX, Win, Amiga versions available.
#
# The script's out of the box configuration is to write log files to /var/log
# Since only root has (or should have...) write access to that directory
# I recommend running it through a root cron process, say once every 10
# minutes. As a bonus you'll prevent ComHem disconnections due to inactivity.
#
# Method used in Version 1 was to get the start page (statically declared)
# pick a hidden time stamp and then (FORM) post the necessary information.
# But since ComHem now has skipped the time stamp and changed the page locations
# a more flexible solution has been implemented. Anyway, prior to a login
# we always check whether we indeed are disconnected, or not. 
#
# Simplified, the Version 2 login technique can be explained in these steps:
#
# Ask for a redirection page (javascript at the base url http://10.0.0.6)
# Crop the directory/-ies and "page" from the FQN url (currently /sd/init)
# Tack that to the base url and ask for the login form. Do another crop to get
# rid of the working page (leaves /sd/) and add the form's ACTION string to
# that for sending our login information (gives http://10.0.0.6/sd/login) 
#
# Written by voluspa__at__bigfoot.com September/October 2000

# login1.telia.com is currently located at the private LAN address 10.0.0.6
# To avoid possible DNS trouble (Telia's servers are at 10.0.0.1 and
# 10.0.0.2 - slow and prone to crashes) while using a "real" server as the
# primary one (I use sunic.sunet.se at 192.36.125.2), we state the IP
# instead of the FQN
#
# Remember, a public DNS server knows nothing about private addresses like
# login1.telia.com and the private DNS servers can very well be down without
# you being disconnected from the external net or down while you _are_
# disconnected. Hence the use of IP-numbers.

BASEURL="http://10.0.0.6"

# Testing connectivity. First we try the external net with three ping packets
# to basun.sunet.se aka basun.umdc.umu.se at IP 130.239.8.41 (_the_ most stable
# server in Sweden?). If none are returned (exit code other than zero from ping)
# we try pinging login1.telia.com. In case that works, we initiate a login. Else
# bailing out - network is probably down.

if /bin/ping -q -c 3 130.239.8.41 >/dev/null 2>&1; then
   exit
else
   if /bin/ping -q -c 3 10.0.0.6 >/dev/null 2>&1; then
      
# Ahh... Regular Expression time :-) sed (stream editor) should be available.
# If not, try grep - and experiment. The first regexp is
# .*replace("http:\/\/.*com which ignores everything until it reaches the
# login page we are after (javascript initiated). The trailing text is then
# cut off by [\"].*
# Note: This takes care of FQN changes, like if they go from login1 to login2
# or something else in the future, but we still assume the IP remains fixed.

      LOGINPAGE=$($CURL $BASEURL | /usr/bin/sed -n -e 's/.*replace("http:\/\/.*com//p')
      LOGINPAGE=$(echo -n $LOGINPAGE | /usr/bin/sed -n -e 's/[\"].*//p')

# Error checking. No sense in continuing if nothing valid is returned. They could
# have changed the whole login procedure again...

      if [ $LOGINPAGE = "" ]; then
         echo "Could not retrieve login page information!" >/var/log/comhem.err
         exit
      fi

# Now we bring home the expected login form (or an "already logged in" status page).

      FORM=$($CURL $BASEURL$LOGINPAGE)

# Then try to isolate the form name with the regexp .*<FORM NAME=" and 
# cutting off everything trailing with the [\"].* again.

      FORMNAME=$(echo -n $FORM | /usr/bin/sed -n -e 's/.*<FORM NAME="//p')
      FORMNAME=$(echo -n $FORMNAME | /usr/bin/sed -n -e 's/[\"].*//p')

# In the past, and presently, ComHem has called their login form "pwdenter".
# We assume they still do... Version 1 of this script determined logged in
# status from the existence or nonexistence of a hidden time stamp, but now
# we have to rely on that form name. If it complies to our expectation, we
# make cURL log us in, saving the returned page.
#
# Else we shake our heads and log the error. Basun.sunet.se could have been
# down when we pinged (not likely), or the ping failure could be due to net
# congestion (more likely). Anyway, no harm done. Comhemresult.html, when
# not being an error message, is just a redirection to the Internet Cable
# home page and a way for them to launch a logout window. I (we) don't care
# about creating the logout page. Have a look at the page code and write
# your own retrieval strings if you really feel the urge/itch ;-)

      if [ $FORMNAME = "pwdenter" ]; then
    
# Regexp .*<FORM NAME="pwdenter" ACTION=" is for determining the "page" we
# should send our information to. Once again, we cut off the rest of the text
# with [\"].*

         SENDPAGE=$(echo $FORM | /usr/bin/sed -n -e 's/.*<FORM NAME="pwdenter" ACTION="//p')
         SENDPAGE=$(echo $SENDPAGE | /usr/bin/sed -n -e 's/[\"].*//p')

# And this little cutie [^\/]\{1,\}$ gives us the directory where the page should
# reside (picked from the already processed LOGINPAGE variable). Believe me, it
# will fix any depth of directories!

         DIRECTORY=$(echo -n $LOGINPAGE | /usr/bin/sed -n -e 's/[^\/]\{1,\}$//p')

# Finally, FORM posting our user information with cURL. Not checking whether the
# fields indeed are called "username" and "password" might seem somewhat risky,
# but hey! Live a little! Besides... those are standard strings and have been
# present for a long time.

         RESULT=$($CURL -d "username=$USERNAME&password=$PASSWORD" $BASEURL$DIRECTORY$SENDPAGE)

         echo -n $RESULT >/var/log/comhemresult.html
         /bin/rm -f /var/log/comhem.err
         exit
      else
         echo "Already logged in, but network congestion/error - You decide..." >/var/log/comhem.err
         exit
      fi
   else
      echo "No connection with login1.telia.com! And you're _paying_ for this..." >/var/log/comhem.err
      exit
   fi
fi
