<?php
//
// A simple PHP/CURL FTP upload to a remote site
//

$localfile = "me-and-my-dog.jpg";
$ftpserver = "ftp.mysite.com";
$ftppath   = "/path/to";
$ftpuser   = "myname";
$ftppass   = "mypass";

$remoteurl = "ftp://${ftpuser}:${ftppass}@${ftpserver}${ftppath}/${localfile}";

$ch = curl_init();

$fp = fopen($localfile, "rb");

// we upload a JPEG image
curl_setopt($ch, CURLOPT_URL, $remoteurl);
curl_setopt($ch, CURLOPT_UPLOAD, 1);
curl_setopt($ch, CURLOPT_INFILE, $fp);

// set size of the image, which isn't _mandatory_ but helps libcurl to do
// extra error checking on the upload.
curl_setopt($ch, CURLOPT_INFILESIZE, filesize($localfile));

$error = curl_exec($ch);

// check $error here to see if it did fine or not!

curl_close($ch); 
?>
