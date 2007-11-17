<?php
/* "AdSense totals sent via SMS to cellphone" 
http://www.webmasterworld.com/forum89/5349.htm

"Follow your Adsense earnings with an RSS reader" 
http://curl.askapache.com/libcurl/php/examples/rss-adsense.html 

"Auto-Login to Google Analytics to impress Clients"
http://www.askapache.com/webmaster/login-google-analytics.html */

// Uncomment to only allow from IP 1.1.1.1
// if($_SERVER['REMOTE_ADDR'] !== '1.1.1.1') die();
$username=urlencode('myemail@gmail.com');
$password="mypassword";
$gacookie="./.gacookie";

$postdata="Email=$username&Passwd=$password&GA3T=5AS_gBsvDHI&nui=15&fpui=3&askapache=http://www.askapache.com/"
."&service=adsense&ifr=true&rm=hide&itmpl=true&hl=en_US&alwf=true&continue=https://www.google.com/adsense/report/overview&null=Sign in";
$ch = curl_init();
curl_setopt ($ch, CURLOPT_URL,"https://www.google.com/accounts/ServiceLoginBoxAuth");
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
curl_setopt ($ch, CURLOPT_TIMEOUT, 60);
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt ($ch, CURLOPT_COOKIEJAR, $gacookie);
curl_setopt ($ch, CURLOPT_COOKIEFILE, $gacookie);
curl_setopt ($ch, CURLOPT_REFERER, 'https://www.google.com/adsense/report/overview');
curl_setopt ($ch, CURLOPT_POSTFIELDS, $postdata);
curl_setopt ($ch, CURLOPT_POST, 1);
$AskApache_result = curl_exec ($ch);
curl_close($ch);
echo $AskApache_result;
unlink($gacookie);
exit;
?>