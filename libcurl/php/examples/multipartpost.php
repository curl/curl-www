<?php

//
// (Using a file upload box on a web page)
//
// When the user selects a file and submits the form, this code will post to
// itself, which in effect uploads the file to the web server's temp
// directory.  $sampfile contains the temporary file name in this directory.
// You then repost it by using an associative array, prefixing the name of the
// file with an @ sign.  This will post it to the server specified in $APP.
// You will then get a variable on $APP called $sampfile that will contain the
// temp file name on that server.  You could pass it around all day like this.
// Check out PHP.net under the CURL section. There isn't much useful info
// there for this type of stuff, but there is one or two very useful postings
// under the articles.
// 
// Good luck.
// Pete James
// 

  if (isset($sampfile))
  {
     $ch = curl_init($APP);  
     curl_setopt($ch, CURLOPT_POSTFIELDS, array
('sampfile'=>"@$sampfile"));
     curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
     $postResult = curl_exec($ch);
     curl_close($ch);
     print "$postResult";
  }
  else
  {
     print   "<form enctype=\"multipart/form-data\" "
                . "action=\"$PHP_SELF\" method=\"post\" >\n";

     print "</form>";
}

?>
