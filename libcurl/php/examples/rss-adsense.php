<?php
/*
Hack Name: Adsense to RSS 
Version: 1.0
Hack URI: http://frenchfragfactory.net/ozh/my-projects/track-adsense-earnings-in-rss-feed/
Description: Follow your Adsense earnings with an RSS reader
Author: Ozh
Author URI: http://planetOzh.com
*/

/************ SCRIPT CONFIGURATION ***********/
/*********************************************/

$username="you@email.com";
	// your adsense username

$password="MySuPeRpAsSwOrD"; 
	// your adsense password

$daterange = 20 ;
	// range of days to aggregate in RSS reader

$cookie="./.cookiefile";
        // a temp file name - you mostly don't care about this
        // This will create a hidden file in the current directory. If it seems to fail,
        // replace with a full physical path (i.e. /home/you/temp/cookiefile)


/************ DO NOT MODIFY BELOW ************/
/*********************************************/

$daysbefore = mktime(0, 0, 0, date("m") , date("d") - $daterange, date("Y"));
list ($d_from,$m_from,$y_from) = split(':',date("j:n:Y", $daysbefore));
list ($d_to,$m_to,$y_to) = split(':',date("j:n:Y"));


/* Following lines are based on a script found on WMW forums */
/* http://www.webmasterworld.com/forum89/5349.htm */

$destination="/adsense/report/aggregate?"
	."sortColumn=0"
	."&reverseSort=false"
	."&csv=true"
	."&product=afc"
	."&dateRange.simpleDate=today"
	."&dateRange.dateRangeType=custom"
	."&dateRange.customDate.start.day=$d_from"
	."&dateRange.customDate.start.month=$m_from"
	."&dateRange.customDate.start.year=$y_from"
	."&dateRange.customDate.end.day=$d_to"
	."&dateRange.customDate.end.month=$m_to"
	."&dateRange.customDate.end.year=$y_to"
	."&unitPref=page"
	."&reportType=property"
	."&searchField="
	."&groupByPref=date";

$postdata="destination=".urlencode($destination)."&username=".urlencode($username)."&password=".urlencode($password)."&null=Login";

$ch = curl_init(); 
curl_setopt ($ch, CURLOPT_URL,"https://www.google.com/adsense/login.do"); 
curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER, FALSE); 
curl_setopt ($ch, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)"); 
curl_setopt ($ch, CURLOPT_TIMEOUT, 20); 
curl_setopt ($ch, CURLOPT_FOLLOWLOCATION,1); 
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1); 
curl_setopt ($ch, CURLOPT_COOKIEJAR, $cookie); 
curl_setopt ($ch, CURLOPT_COOKIEFILE, $cookie); 
curl_setopt ($ch, CURLOPT_POSTFIELDS, $postdata); 
curl_setopt ($ch, CURLOPT_POST, 1); 
$result = curl_exec ($ch); 
curl_close($ch); 

$result=preg_split("/\n/",$result);
array_pop($result);
array_pop($result);
array_shift($result);
$result = array_reverse($result);

header('Content-type: text/xml');
echo '<?xml version="1.0" encoding="iso-8859-1"?>';
echo "\n";
?>
<rss version="2.0" 
	xmlns:content="http://purl.org/rss/1.0/modules/content/"
	xmlns:wfw="http://wellformedweb.org/CommentAPI/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
>
<channel>
	<title><?php echo "$daterange days of Adsense"; ?></title>
	<link>https://www.google.com/adsense/</link>
	<description>An RSS feed of my Adsense earnings for the last <?php echo $daterange ?> days</description>
	<language>en</language>
<?php

$firstday=1;

foreach ($result as $line) {
	$item = array();
	$line = str_replace("\x00",'',$line);
	$line = str_replace('"','',$line);
	list($day, $pages, $clicks, $ctr, $eCPM, $income) = preg_split("/\s/",$line);
	$item['title']= "<title>\$$income on $day</title>";
	$item['guid'] = '<guid isPermaLink="false">' . md5($username.$day) . "</guid>";
	$day = split('/',$day);
	$day = mktime(0, 0, 0, $day[1] , $day[0], $day[2]);
	if ($firstday == 1) {
		$day = date("D, d M Y H:i:s +0000");
		$firstday = 0;
	} else {
		$day = date("D, d M Y H:i:s +0000", $day);
	}
	$item['pubDate'] = "<pubDate>$day</pubDate>";
	$item['category'] = "<category>adsense</category>";
	$item['description'] = "<description>\$$income ($clicks clicks on $pages pages : CTR = $ctr - eCPM = $eCPM)</description>";
	$item['content'] = "<content:encoded><![CDATA[
	<table>
	<tr><td>Pages printed</td><td>Clicks</td><td>CTR</td><td>eCPM</td><td>Earnings</td></tr>
	<tr><td>$pages</td><td>$clicks</td><td>$ctr</td><td>$eCPM</td><td>$income</td></tr>
	</table>
	]]></content:encoded>";
	
	print "<item>\n";
	print $item['title'] ."\n";
	print $item['guid'] ."\n";
	print $item['pubDate'] ."\n";
	print $item['category'] ."\n";
	print $item['description'] ."\n";
	print $item['content'] ."\n";
	print "</item>\n";
	
	
}
?>
</channel>
</rss>
