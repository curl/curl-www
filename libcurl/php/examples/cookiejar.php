<?php
/*
This script is an example of using curl in php to log into on one page and 
then get another page passing all cookies from the first page along with you.
If this script was a bit more advanced it might trick the server into 
thinking its netscape and even pass a fake referer, yo look like it surfed 
from a local page.
*/

$ch = curl_init();
curl_setopt($ch, CURLOPT_COOKIEJAR, "/tmp/cookieFileName");
curl_setopt($ch, CURLOPT_URL,"http://www.myterminal.com/checkpwd.asp");
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, "UserID=username&password=passwd");

ob_start();		// prevent any output
         curl_exec ($ch);	// execute the curl command
ob_end_clean();	// stop preventing output

curl_close ($ch);
unset($ch);
}

setcookies();

$ch = curl_init();
curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
curl_setopt($ch, CURLOPT_COOKIEFILE, "/tmp/cookieFileName");
curl_setopt($ch, CURLOPT_URL,"http://www.myterminal.com/list.asp");


$buf2 = curl_exec ($ch);

curl_close ($ch);

echo "<PRE>".htmlentities($buf2);
?>
