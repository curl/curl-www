#!/sbin/php -q
<?
/* 
        cURL Mirror script in PHP
        Setup up vars:
*/

$MirrorPath = "/home/linuxworx/web/curlmirror/";
$CurlURLDist = "http://curl.haxx.se/download/curldist.txt";
$CurlURL = "http://curl.haxx.se/download/";

/*
        Here we go ...
*/

echo "Getting File List ";
flush();
$fd = fopen($CurlURLDist,"r");
while (!feof($fd)) {
        $buffer = fgets($fd, 4096);
        $FileList .= $buffer;
        $FileArray[] = $buffer;
        echo ".";
        flush();
}
fclose ($fd);
echo "\nChecking for curldist.txt ";
if (file_exists($MirrorPath."curldist.txt")) {
        echo "Found !\n";
        if (filesize($MirrorPath."curldist.txt")!=strlen($FileList)) {
                echo "New list and old list differ in size, pulling all the files down again\n";
                exec ("rm -Rf $MirrorPath");
                exec ("mkdir $MirrorPath");
                GetFiles($FileArray);
        } else {
                echo "Lists are the same size, all done\n";
        }
} else {
        echo "Not Found.";
        $fd = fopen($MirrorPath."curldist.txt","w+");
        fputs($fd, $FileList);
        fclose ($fd);
        GetFiles($FileArray);
}

/*
        This function gets new files from the curl server.
*/
function GetFiles($FileArray) {
        GLOBAL $MirrorPath,$CurlURL;
        echo "Chaning into $MirrorPath\n";
        exec("cd $MirrorPath");
        while(list($k,$v) = each ($FileArray)) {
                exec("wget ".$CurlURL."".trim($v)." -O $MirrorPath".$v);
        }
}
?>