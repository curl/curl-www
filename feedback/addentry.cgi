#!/usr/bin/perl

use feedback;

Top();
&where("Feedback", "/feedback/", "Add Suggestion");
Header("Post A Suggestion");

print <<POO

<p> Feel free to submit a suggestion or an idea about what you think should be
improved, added, changed, fixed or corrected... Do not use this form to file
<a href="/bugreport.html">bug reports</a>.

<p>
 <b>HTML is not allowed</b> in the suggestion text! Tags will become visible.
<p>
 The password field is there to allow you to add a remark to your suggestion
 at a later time. The suggested password may be changed at will. <b>You will
 not see it again, remember it!</b> You cannot change the suggestion after it
 has been posted. Stay polite and focused.

POO
;

@words1 = ('a','e','o','u','y','i','u');
@words2 = ('b','c','d','f','g','k','l','m','t','q','r','s');

$passwd = sprintf("%s%s%s%s%s%d",
                  $words2[rand()*$#words2],
                  $words1[rand()*$#words1],
                  $words2[rand()*$#words2],
                  $words2[rand()*$#words2],
                  $words1[rand($#words1+1)],
                  rand(100));

@allcats = &GetCategories;
for(@allcats) {
    $cats .= "<option>$_</option>";
}

print <<ENTER
<p><b>Fill in your suggestion/idea:</b>
ENTER
    ;

&ShowInput;
Footer;
