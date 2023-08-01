/***********************************************************************************
*  COPYRIGHT AND PERMISSION NOTICE
*
*  Copyright (C) Daniel Stenberg, <daniel@haxx.se>, and many
*  contributors, see the THANKS file.
*
*  All rights reserved.
*
*  Permission to use, copy, modify, and distribute this software for any purpose
*  with or without fee is hereby granted, provided that the above copyright
*  notice and this permission notice appear in all copies.
*
*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN
*  NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
*  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
*  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
*  OR OTHER DEALINGS IN THE SOFTWARE.
*
*  Except as contained in this notice, the name of a copyright holder shall not
*  be used in advertising or otherwise to promote the sale, use or other dealings
*  in this Software without prior written authorization of the copyright holder.
**********************************************************************************/

// on/off switch for menu scroll breakpoint, mouseover, and button status respectively
var scrollOver100 = 0; var mousedOver = 0; var onOffButton = 0;

// Option menu DOM elements
var searchButton = document.getElementById("searchButton"); // show option dropdown
var manpageOptionMenu = document.getElementById("manpage-option-menu"); // top of DOM
var manpageOptionMenuData = manpageOptionMenu.dataset; // switch to put menu to side

// Show in full or put to side top button.
function showTopButtonInFull() {
  // Add scroll event to menu and top button.
  document.addEventListener("scroll", function() {
    // switch for scrolled down over 100
    if (document.documentElement.scrollTop > 100) { scrollOver100 = 1; }
    else { scrollOver100 = 0; } 

    // Toggle button to side and stay
    if ( // scrolled past 100px, menu is not on side, and not moused over
      scrollOver100 == 1 &&
      manpageOptionMenuData.onSide == 0 &&
      mousedOver == 0 && 
      onOffButton == 0
     ) {       
     manpageOptionMenu.dataset.onSide = 1;
      if ( searchButton.className.indexOf("searchButtonToSide") > -1 &&
           manpageOptionMenuData.toSide == 1 ) {
        // put menu to side and done          
        searchButton.dataset.toSide = 1;
      }
    } else {
      // hide top button       
      searchButton.dataset.toSide = 0; // button default
     
      // set menu to defaults
      if (document.documentElement.scrollTop < 100) {
        manpageOptionMenu.style.left = ""; // now use css styles
        manpageOptionMenu.dataset.onSide = 0;
      }
    }
  });  
}

// Show option buttons to side when menu not in view
// adding mouseover function to activate.
function buttonToSide(status, onoff) {
  // if on exit    
  if (
   ( onoff == 1 || onOffButton == 1 ) &&
     onoff != "on"
    ) { mousedOver = 1; return; }
  
  // is moused over or not. exit on mouse out  
  if ( status == 1 ) {
    mousedOver = 1;
  } else { 
    mousedOver = 0;
    // better ux with timeout
    setTimeout(function() { return; }, 500);     
  }

  if ( // scroll switch is set and menu is on side
    scrollOver100 == 1 && 
    manpageOptionMenuData.onSide == 1
   ) {     
     manpageOptionMenu.dataset.onSide = 0; // position with css
   } 
   else if ( // scroll sitch is set and menu not on side
     scrollOver100 == 1 &&
     manpageOptionMenu.dataset.onSide == 0 // left 0px with css
      ) {
     manpageOptionMenu.dataset.onSide = 1; // left -80px with css
   }
}

// Search for options in dropdown.
function searchOptions(txt) {
  let optionMenu = document.getElementById("optionMenu");
  let optionMenuLi = optionMenu.getElementsByTagName("li");
  // show or hide options when searching.
  for (let i = 0; i < optionMenuLi.length; i++) {
    let curLI = optionMenuLi[i].innerText;
    if (curLI.indexOf(txt) > -1) { // if match show
      optionMenuLi[i].style.display = "";
    } else { // else don't show
      optionMenuLi[i].style.display = "none";
    }
  }
}

// Show and hide option list items.
function toggleSearchButton(showhide, onoff) {
  // responsive elements
  let manpageDiv = document.getElementsByClassName("manpage")[0];
  let manpageMenu = document.getElementsByClassName("menu")[0];  
  
  // toggle display elements
  let showItem = showhide.nextElementSibling;
  let curData = onoff.dataset;
  if (curData.onoff == 0) {
    // 1.set switch, show menu, change style, change text
    manpageOptionMenu.dataset.toSide = 0;
    curData.onoff = 1;
    showItem.style.display = "";
    onoff.style.background = "white";
    onoff.style.color = "black";
    onoff.innerHTML = onoff.innerHTML.replace("Show", "Hide");
    // 2. show the option menu.
    onoff.className = "";
    onoff.parentElement.className = 
     onoff.parentElement.className.replace(" inactive", "");
    // 3. responsive margins if screen < 770 add else remove
    if (!manpageDiv.id) { manpageDiv.id = "activeManDiv"; }
    if (!manpageMenu.id) { manpageMenu.id = "activeManMenu"; }
    // Turn button on
    onOffButton = 1;
  } else {
    // 1.set switch, hide menu, change style, change text
    manpageOptionMenu.dataset.toSide = 1;
    curData.onoff = 0;
    showItem.style.display = "none";
    onoff.style.background = "";
    onoff.style.color = "";
    onoff.innerHTML = onoff.innerHTML.replace("Hide", "Show");
    // 2. set to side when menu out of view, styling parrent with css.
    onoff.className = "searchButtonToSide";
    onoff.parentElement.className += " inactive";
    // 3. responsive margins if screen < 770 add else remove
    if (manpageDiv.id) { manpageDiv.removeAttribute("id"); }
    if (manpageMenu.id) { manpageMenu.removeAttribute("id"); }
    // put back to side if scrolled past 100.
    // Turn button off
    onOffButton = 0;
  }
}

// Add anchor when clicked.
function addOptionLinks() {
  let optionMenu = document.getElementById("optionMenu");
  let optionMenuLi = optionMenu.getElementsByTagName("li");
  let fullOptionList = document.getElementById("fullOptionList");
  
  // Define var for function use.
  var lastDec, hValue;
  
  // Remove any periods from anchor link.  
  var outPeriod = function() {    
    let hasPeriod = 1; // period still in text
    while (hasPeriod == 1) { // remove periods from text
      if (hValue.substr(hValue.indexOf("#")).lastIndexOf(".") > -1) {
        lastDec = hValue.lastIndexOf("."); // index of last period
        // Extract to last period, skip and extract rest of text.
        hValue = hValue.substr(0, lastDec) + 
         hValue.substr(Number(lastDec + 1));
       } else {
        hasPeriod = 0; // periods have been removed
       }
     }
  };
  // Always Show the ootion menu list.
  fullOptionList.style.display = "";
  
  // Select all list items in option menu
  optionMenuLi = fullOptionList.getElementsByTagName("li");
  
  for (let i = 0; i < optionMenuLi.length; i++) {
    // Add anchor link whenever list item is clicked.
    optionMenuLi[i].getElementsByTagName("a")[0]
    .addEventListener("click", function() {
      if (this.innerHTML.indexOf(",") > -1) {
        // Set the attribute value for anchor link with duplicate options.
        this.href = "#" + this.innerHTML.substr(0, this.innerHTML.indexOf(","));
        // Duplicate value in variable to check period.
        hValue = this.href;
      } else {
        // Set the attribute value for anchor link.
        this.href = "#" + this.innerHTML;
        // Duplicate value in variable to check period.
        hValue = this.href;              
      }
      // Remove periods if has period in text
      if (hValue.match(/\w\d[.]/g)) {
        outPeriod();
        this.href = hValue; // redefine attribute
      }
    });
  }
}
showTopButtonInFull();
addOptionLinks();

// Everything below is for testing and can be deleted.

/***********************************************************************************
******************* Check console output to see results of test ********************
After build open manpage.html and change the variable "testOptionAnchors" to 1 
to turn on tests. In order to test the browser must support console.log. 
   Test Instructions: 
     1. Change variable "testOptionAnchors" to 1. 
     2. Reload manpage.html 
     3. Open browser console tool. 
     4. The results will be as such: 
       A. Anchor Count = number of options in menu 
       B. Option Anchors = array with name of options in menu 
       C. Anchor Links = the href attribute assigned after click event.
       D. Test Result - Pass or fail
          - Pass - all options have href that matche innerHTML that made anchor.
          - Note - if putting an item such as <li><a href="abc">xyz</a></li>
                   outside of ul tag, test will fail.
       E. Compare Values - the href value vs the innerHTML of option.       
     5. Delete or set variable "testOptionAnchors" back to 0 to turn off test.
***********************************************************************************/
var testOptionAnchors = 0; // test is off by default

function testTheOptionAnchors() {
  var logSplit = function(x) {
    if (x == undefined) { x = 0; }
    if (x == 1) {             
      console.log("***********************************************************************"); 
      console.log("****************************STARTING TEST******************************"); 
      console.log("\n"); 
    } 
    else if (x == 2) { 
      console.log("\n"); 
      console.log("****************************FINISHED TEST******************************");       
      console.log("***********************************************************************");
    } else {
      console.log("***********************************************************************");
    }    
  };

  var theUnorderdOptionList = document.getElementById("optionMenu");
  var theOptionListItems = theUnorderdOptionList.getElementsByTagName("li");  
  var optionListItemInnerHTML = [];
  // Get option names
  for (let i = 0; i < theOptionListItems.length; i++) {
    let curItem = theOptionListItems[i].getElementsByTagName("a")[0];
    optionListItemInnerHTML.push(curItem.innerHTML);    
  }
  // Get option href value.
  var curIndex; var anchorHref = [];
  // click then get href
  var clickThenHref = function(cond) {
    curIndex = 0;
    while (curIndex < theOptionListItems.length) {
      let curItem = theOptionListItems[curIndex].getElementsByTagName("a")[0];    
      clickOption(curItem, cond);
      curIndex++;
    } 
  };
  // click or href.
  var clickOption = function(cur, cond) {
    if (cond == 1) {      
      cur.click();      
    } else {
      anchorHref.push(cur.href);    
    }    
  };
  // Click to add href value.
  clickThenHref(1);
  // Add href value to array anchorHref.
  clickThenHref(2);

  // Compare innerHTML to href.
  var testResult = 0; var compareValues = [];  
  if (optionListItemInnerHTML.length == anchorHref.length) {
    let commaRegEx = /^(.*?)(?:,|$)/; // text before comma    
    for (let i = 0; i < optionListItemInnerHTML.length; i++) {      
      let compareLines = optionListItemInnerHTML[i].match(commaRegEx)[1].trim().replace(/\./g, "");      
      let curAnchorValue = anchorHref[i].substr(anchorHref[i].indexOf("#")+1);      
      
      if (compareLines == curAnchorValue) {
        compareValues.push(compareLines + " <-> " + curAnchorValue);
        if (i == optionListItemInnerHTML.length-1) {
          testResult = "PASS";
        }
      } else {
        alert("ERROR - tThe href attribute did not match option in innerHTML.");
        testResult = "FAIL";
        break;
      }      
    }
  } else {
    alert("ERROR - the option did not generate an anchor.");
    testResult = "FAIL";
  }
  
  // Start test console composition.
  logSplit(1); 
  // Output option list item length and innerHTML
  console.log("A. Anchor Count - " + theOptionListItems.length);  
  console.log("B. Option Anchors:");
  console.log(optionListItemInnerHTML);  
  // Output option href attribute
  logSplit();
  console.log("C. Anchor Links:");
  console.log(anchorHref);
  // Make sure both lengths match and anchor uses correct option.
  logSplit();
  console.log("D. Test Result - ");
  console.log(testResult);
  console.log("E. Compare Values:");
  console.log(compareValues);
  // Close test console composition.
  logSplit(2);    
}

if (testOptionAnchors == 1) { testTheOptionAnchors(); }
