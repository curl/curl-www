<?php
/*
Check for Reciporical Link
Use this script to check if reciporical link agreements are being honoured.

In this simple example we are just checking for the existance of a url in
any pair of <a></a> tags on a link page.
*/

// The url that should appear on the link page
$url="http://michaelphipps.com";
// The link page that should contain the url
$link_page="http://curl.haxx.se/libcurl/php/examples/multi.html";

// Use Curl to return the raw source of a webpage to a variable called 
$result
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL,$link_page);
curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
$result=curl_exec ($ch);
curl_close ($ch);

// Search for the $url on the $link_page.
/*
Returns the result in an array called $matches
(this regular expression could probably be improved...)
*/
preg_match ("|<[aA] (.+?)".$url."(.+?)>(.+?)<\/[aA]>|i", $result, $matches);


// See if there were any matches
/*
(note preg_match only returns the first match,
use preg_match_all to return all matches)
*/

if (count($matches)>0){
 // if there are items in the array, then there was a match.
 echo "The link exists on the target website";
 print_r($matches);

 /*
 If you require very specific link text you can use the information
 returned in the $matches array to further assess if your website is
 being linked the way you want.
 */

}else{
 // if there are no items in the array, then no matches were found.
 echo "The link does not exist on the target website";
}

?>
