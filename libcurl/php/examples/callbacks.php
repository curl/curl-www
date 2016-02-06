<?php
/*
Author: Keyvan Minoukadeh

This script demonstrates how you can set callback functions to receive the
HTTP response as it comes through.

The advantage of this is that you don't have to wait for the whole response
to be returned before you start work on it, you can monitor for certain
headers, start outputting while you're receiving, etc..

I wasn't aware these cURL options were available in PHP, but noticed them being
used by Alan Knowles: <http://docs.akbkhome.com/phpmole/phpmole_webfetch.html>

For more info on CURLOPT_HEADERFUNCTION and CURLOPT_WRITEFUNCTION see:
<https://curl.haxx.se/libcurl/c/curl_easy_setopt.html>
*/

$ch = curl_init();

curl_setopt($ch, CURLOPT_URL, 'http://www.php.net/');
// Set callback function for headers
curl_setopt($ch, CURLOPT_HEADERFUNCTION, 'read_header');
// Set callback function for body
curl_setopt($ch, CURLOPT_WRITEFUNCTION, 'read_body');

curl_exec($ch);

if ($error = curl_error($ch)) {
    echo "Error: $error<br />\n";
}

// define callback functions

// Notes from <https://curl.haxx.se/libcurl/c/curl_easy_setopt.html>:
// Return the number of bytes actually written or return -1 to signal error to
// the library (it will  cause it to abort the transfer with a CURLE_WRITE_ERROR
// return code). (Added in 7.7.2)
function read_header($ch, $string)
{
    $length = strlen($string);
    echo "Header: $string<br />\n";
    return $length;
}

// Notes from <https://curl.haxx.se/libcurl/c/curl_easy_setopt.html>:
// Return the number of bytes actually taken care of.  If that amount differs
// from the amount passed to your function, it'll signal an error to the library
// and it will abort the transfer and return CURLE_WRITE_ERROR.
function read_body($ch, $string)
{
    $length = strlen($string);
    echo "Received $length bytes<br />\n";
    return $length;
}

?> 