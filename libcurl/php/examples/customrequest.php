<?php
//
// A very simple POST example with a custom request keyword 'FOOBAR'
//

$ch = curl_init();

curl_setopt($ch, CURLOPT_URL,"http://www.mysite.com/postit.cgi");
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS,
            "postvar1=value1&postvar2=value2&postvar3=value3");

// issue a FOOBAR request instead of POST!
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "FOOBAR");

curl_exec ($ch);
curl_close ($ch); 
?>
