<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html lang="en">
<head>
<title><MM-List-Name> Info Page</title>
<link rel="STYLESHEET" type="text/css" href="http://curl.haxx.se/curl.css">
</head>

<body>
 <h1 class="pagetitle"><MM-List-Name> -- <MM-List-Description></h1>
<div class="relatedbox">
<b>Related:</b>
<br><a href="http://curl.haxx.se/">curl web site</a>
<br><a href="http://curl.haxx.se/mail/list.cgi?list=<MM-List-Name>"><MM-List-Name> archives</a>
<br><a href="http://curl.haxx.se/mail/">Mailing Lists</a>
</div>

<P class="ingres"> <MM-List-Info>
<p>
<h2>Using <MM-List-Name></h2>

<p> To post a message to all the <MM-List-Name> list members, send email to <A
 HREF="mailto:<MM-Posting-Addr>"><MM-Posting-Addr></A>. You <b>must</b> be
 subscribed before you post, as otherwise your mail will simply be silently
 discarded.

<p>You can subscribe to the list, or change your existing subscription, in the
 sections below.

<h2>Subscribing to <MM-List-Name></h2>

<P> Subscribe to <MM-List-Name> by filling out the following form.  You will
 be sent email requesting confirmation. The list of members is only visible to
 admins.

 <ul>
 <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
 <TR>
   <TD BGCOLOR="#dddddd">Your email address:</TD>
   <TD><MM-Subscribe-Box></TD>
 </TR>
   <tr>
   <td bgcolor="#dddddd">Your name (optional):</td>
   <td><mm-fullname-box></td>
   </tr>

 <TR>
   <TD BGCOLOR="#dddddd">Pick a password:</TD>
   <TD><MM-New-Password-Box></TD>
 </TR>
 <TR> 
   <TD BGCOLOR="#dddddd">Reenter password to confirm:</TD>
   <TD><MM-Confirm-Password></TD>
 </TR>

 <mm-digest-question-start>
 <tr>
   <td>Receive list mail batched in a daily digest?</td>
   <td><MM-Undigest-Radio-Button> No
       <MM-Digest-Radio-Button>  Yes
   </td>
 </tr>
 <mm-digest-question-end>
 <tr>
   <td colspan="2">
   <center><MM-Subscribe-Button></P></center>
   </td>
 </tr>
 </TABLE>
 <MM-Form-End>
 </ul>

 <a name="subscribers"></a>
 <h2><MM-List-Name> preferences</h2>
 <MM-Options-Form-Start>
 <MM-Editing-Options>
 <MM-Form-End>
<p>
<a href="/cgi-bin/mailman/admin/<MM-List-Name>">admin interface</a>
</BODY>
</HTML>
