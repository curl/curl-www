<?php
//
// HTTP PUT to a remote site
// Author: Julian Bond
//

$url = "http://some.server.com/put_script";
$localfile = "localfile.csv";

$fp = fopen ($localfile, "r");
$ch = curl_init();
curl_setopt($ch, CURLOPT_VERBOSE, 1);
curl_setopt($ch, CURLOPT_USERPWD, 'user:password');
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_PUT, 1);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_INFILE, $fp);
curl_setopt($ch, CURLOPT_INFILESIZE, filesize($localfile));

$http_result = curl_exec($ch);
$error = curl_error($ch);
$http_code = curl_getinfo($ch ,CURLINFO_HTTP_CODE);

curl_close($ch);
fclose($fp);

print $http_code;
print "<br /><br />$http_result";
if ($error) {
   print "<br /><br />$error";
}

?>
