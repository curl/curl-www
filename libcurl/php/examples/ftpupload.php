<?php
//
// A simple PHP/CURL FTP upload to a remote site
//

$ch = curl_init();

// we upload a JPEG image
curl_setopt($ch, CURLOPT_URL,
            "ftp://mynamw:mypassword@ftp.mysite.com/path/to/destination.jpg");
curl_setopt($ch, CURLOPT_UPLOAD, 1);
curl_setopt($ch, CURLOPT_INFILE, "me-and-my-dog.jpg");

// set size of the image, which isn't _mandatory_ but helps libcurl to do
// extra error checking on the upload. If you can tell me how to get filesize
// nicely with a PHP function then I'd like to add it here to make the example
// better!
curl_setopt($ch, CURLOPT_INFILESIZE, 3271);

$error = curl_exec ($ch);

// check $error here to see if it did fine or not!

curl_close ($ch); 
?>
