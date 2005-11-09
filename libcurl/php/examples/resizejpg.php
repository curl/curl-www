/*
  you can use it in your webpage like this:
  <img src=resizejpg.php?size=60&filename=http://anydomain.com/anyimage.jpg>

  Hope the code helps you! / Michael

*/

<?php
function LoadJpeg ($imgname) {
$im = @ImageCreateFromJPEG ($imgname); /* Attempt to open */
if (!$im) { /* See if it failed */
  $im = ImageCreate (150, 30); /* Create a blank image */
  $bgc = ImageColorAllocate ($im, 255, 255, 255);
  $tc = ImageColorAllocate ($im, 0, 0, 0);
  ImageFilledRectangle ($im, 0, 0, 150, 30, $bgc);
  /* Output an errmsg */
  ImageString ($im, 1, 5, 5, "Error $imgname", $tc);
}
  return $im;
}

$id=$filename;
$sz=$size;
$savefile="tempimg/".time().".jpg";

$ch = curl_init ($id);
$fp = fopen ($savefile, "w");
curl_setopt ($ch, CURLOPT_FILE, $fp);
curl_setopt ($ch, CURLOPT_HEADER, 0);
curl_exec ($ch);
curl_close ($ch);
fclose ($fp);

$im=LoadJpeg($savefile);

// output
$im_width=imageSX($im);
$im_height=imageSY($im);

// work out new sizes
if($im_width >= $im_height)
{
  $factor = $sz/$im_width;
  $new_width = $sz;
  $new_height = $im_height * $factor;
}
else
{
  $factor = $sz/$im_height;
  $new_height = $sz;
  $new_width = $im_width * $factor;
}

// resize
$new_im=ImageCreate($new_width,$new_height);
ImageCopyResized($new_im,$im,0,0,0,0,
                 $new_width,$new_height,$im_width,$im_height);

// output
Header("Content-type: image/jpeg");
header( "Content-Disposition:attachment;filename=$filename" );
header( "Content-Description:PHP Generated Image" );
Imagejpeg($new_im,'',75); // quality 75

// cleanup
ImageDestroy($im);
ImageDestroy($new_im);
unlink($savefile);
?> 
