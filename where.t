#if 0
#define WHERE3(title1, link1, title2, link2, page) <br><b><a href="/">/</a> <a href=link1>title1</a> / <a href=link2>title2</a> / page</b>

#define WHERE2(title, link, page) <br><b><a href="/">/</a> <a href=link>title</a> / page</b>

#define WHERE1(page) <br><b><a href="/">/</a> page</b>

#else
#define WHERE3(title1, link1, title2, link2, page) <br><a href="/">cURL</a> <img src="/arrow.png"> <a href=link1>title1</a> <img src="/arrow.png"> <a href=link2>title2</a> <img src="/arrow.png"> <b>page</b>

#define WHERE2(title, link, page) <br><a href="/">cURL</a> <img src="/arrow.png"> <a href=link>title</a> <img src="/arrow.png"> <b>page</b>

#define WHERE1(page) <br><a href="/">cURL</a> <img src="/arrow.png"> <b>page</b>

#endif