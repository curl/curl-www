<?php
/*

POST TO BLOGGER USING PHP AND CURL

Before you can use this script, you need a blogger acocunt.
They're free - go to http://blogger.com
You need to have a blog that you can post to.
You need to know the blogid of the blog you want to post to.
To get the blogid, go to blogger.com and log in to your blogger account.
There will be a list of blogs.
When you click on a blog name, it will go to a url like :
http://www.blogger.com/posts.g?blogID=1234567

The blogID portion is what you use for your $blog_id
- in the above example it is 1234567

To carry out other blogger tasks, refer to the Atom API Documentation for
Blogger: http://code.blogger.com/archives/atom-docs.html#authentication
*/

// Set the date of your post
$issued=gmdate("Y-m-d\TH:i:s\Z", time());

// Set the title of your post
$title="TEST ATOM API POST";

// Set the body text of your post.
$body="This is a test post, sent using the atom api.";

// This needs to be changed to the blogID of the blog
// you want to post to (as discussed at the top of this script)
$blog_id="1234567";

// You must know your username and password
// to be able to post to your blog.
$your_username="username";  //change this to your blogger login username
$your_password="password";  // change this to your blogger login password

// This is the xml message that contains the information you are posting
// to your blog
$content = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?>\r\n"
   . "<entry xmlns='http://purl.org/atom/ns#'>\r\n"
   . "<title mode='escaped' type='text/plain'>".$title."</title>\r\n"
   . "<issued>".$issued."</issued>\r\n"
   . "<generator url='http://www.yoursitesurlhere.com'>Your client's name
here.</generator>\r\n"
   . "<content type='application/xhtml+xml'>\r\n"
   . "<div xmlns='http://www.w3.org/1999/xhtml'>".$body."</div>\r\n"
   . "</content>\r\n"
   . "</entry>\r\n";

// This is the custom header that needs to be sent to post to your blog.
$headers  =  array( "Content-type: application/atom+xml" );

// Use curl to post to your blog.
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, "https://www.blogger.com/atom/".$blog_id);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_TIMEOUT, 4);
curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
curl_setopt($ch, CURLOPT_USERPWD, $your_username.':'.$your_password);
curl_setopt($ch, CURLOPT_POSTFIELDS, $content);

$data = curl_exec($ch);

if (curl_errno($ch)) {
 print curl_error($ch);
} else {
 curl_close($ch);
}

// $data contains the result of the post...
echo $data;

?>
