<?php
//
// A simple PHP/CURL FTP upload to a remote site
//

$ch = curl_init();
$localfile = "me-and-my-dog.jpg"

$fp = fopen ($localfile, "r");

// we upload a JPEG image
curl_setopt($ch, CURLOPT_URL,
            "ftp://mynamw:mypassword@ftp.mysite.com/path/to/destination.jpg");
curl_setopt($ch, CURLOPT_UPLOAD, 1);
curl_setopt($ch, CURLOPT_INFILE, $fp);

// set size of the image, which isn't _mandatory_ but helps libcurl to do
// extra error checking on the upload.
curl_setopt($ch, CURLOPT_INFILESIZE, filesize($localfile));

$error = curl_exec ($ch);

// check $error here to see if it did fine or not!

curl_close ($ch); 
?>
