<?php
/*
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'   File:	                ebay_login.php
'
'   Description:            This script Login you on Ebay.com website using curl in php.
'
'   Written by:             Imran Khalid imranlink@hotmail.com
'
'   Languages:              PHP + CURL
'
'   Date Written:           March 23, 2004
'
'   Version:            	V.1.0
'
'   Platform:               Windows 2000 / IIS / Netscape 7.1
'
'   Copyright:              Open Sorce Code (GPL)
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
*/	

// 1-Get First Login Page http://signin.ebay.com/aw-cgi/eBayISAPI.dll?SignIn
// This page will set some cookies and we will use them for Posting in Form data.

	$ebay_user_id = "XXXX"; // Please set your Ebay ID
	$ebay_user_password = "YYYYY"; // Please set your Ebay Password
	$cookie_file_path = "crawler\ebay_login\cook"; // Please set your Cookie File path
	
	$LOGINURL = "http://signin.ebay.com/aw-cgi/eBayISAPI.dll?SignIn";
	$agent = "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.4) Gecko/20030624 Netscape/7.1 (ax)";
    $ch = curl_init(); 
    curl_setopt($ch, CURLOPT_URL,$LOGINURL);
	curl_setopt($ch, CURLOPT_USERAGENT, $agent);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); 
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
	curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file_path);
	curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_file_path);
    $result = curl_exec ($ch);
    curl_close ($ch);

// 2- Post Login Data to Page http://signin.ebay.com/aw-cgi/eBayISAPI.dll

	$LOGINURL = "http://signin.ebay.com/aw-cgi/eBayISAPI.dll";
	$POSTFIELDS = 'MfcISAPICommand=SignInWelcome&siteid=0&co_partnerId=2&UsingSSL=0&ru=&pp=&pa1=&pa2=&pa3=&i1=-1&pageType=-1&userid='. $ebay_user_id .'&pass='. $ebay_user_password;
    $reffer = "http://signin.ebay.com/aw-cgi/eBayISAPI.dll?SignIn";

	$ch = curl_init(); 
    curl_setopt($ch, CURLOPT_URL,$LOGINURL);
	curl_setopt($ch, CURLOPT_USERAGENT, $agent);
    curl_setopt($ch, CURLOPT_POST, 1); 
    curl_setopt($ch, CURLOPT_POSTFIELDS,$POSTFIELDS); 
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); 
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
	curl_setopt($ch, CURLOPT_REFERER, $reffer);
	curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file_path);
	curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_file_path);
    $result = curl_exec ($ch);
    curl_close ($ch); 
	print 	$result;	

?>