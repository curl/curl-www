<?php

// 
// This sample shows how to fill in and submit data to a form that looks like:
//
//   <form enctype="multipart/form-data"
//       action="somewhere.cgi" method="post">
//   <input type="file" name="sampfile">
//   <input type="text" name="filename">
//   <input type="text" name="shoesize">
//   <input type="submit" value="upload">
//   </form>
//
// Pay attention to:
//   #1 - the input field names (name=)
//   #2 - the input field type so that you pass the upload file to the right
//        name
//   #3 - what URL to send the POST to. The action= attribute sets it.
//
// Author: Daniel Stenberg

   $uploadfile="/tmp/mydog.jpg"; 
   $ch = curl_init("http://formsite.com/somewhere.cgi");  
   curl_setopt($ch, CURLOPT_POSTFIELDS,
               array('sampfile'=>"@$uploadfile",
                     'shoesize'=>'9',
                     'filename'=>"fake name for file"));
   curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
   $postResult = curl_exec($ch);
   curl_close($ch);
   print "$postResult";
}

?>
