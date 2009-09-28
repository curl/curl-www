<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <title>[if-any rootname][[][rootname]][else]ViewVC[end] [page_title]</title>
  <meta name="generator" content="ViewVC [vsn]" />
  <link rel="shortcut icon" href="http://curl.haxx.se/favicon.ico" />
#include "css.t"
  <link rel="stylesheet" href="[docroot]/styles.css" type="text/css" />
  [if-any rss_href]<link rel="alternate" type="application/rss+xml" title="RSS [[][rootname]][where]" href="[rss_href]" />[end]
</head>

#include "_menu.html"

<div class="vc_navheader">

<strong>[if-any roots_href]<a href="[roots_href]"><span class="pathdiv">/</span></a>[else]<span class="pathdiv">/</span>[end][if-any nav_path][for nav_path][if-any nav_path.href]<a href="[nav_path.href]">[end][if-index nav_path first][[][nav_path.name]][else][nav_path.name][end][if-any nav_path.href]</a>[end][if-index nav_path last][else]<span class="pathdiv">/</span>[end][end][end]</strong>

</div>

<h1 class="pagetitle">[page_title]</h1>



