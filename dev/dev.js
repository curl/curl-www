/*
COPYRIGHT AND PERMISSION NOTICE

Copyright (c) 2014, Daniel Fandrich, <dan@coneharvesters.com>.

All rights reserved.

Permission to use, copy, modify, and distribute this software for any purpose
with or without fee is hereby granted, provided that the above copyright
notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN
NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
OR OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of a copyright holder shall not
be used in advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization of the copyright holder.
*/

/* Functions used by the build filtering functions on the builds page */

/* Executed on page load */
function showFilter() {
    /* Forms are made invisible in CSS by default, and only made visible
       if JavaScript is available and therefore the feature is usable by
       the user */
    var forms = document.getElementsByClassName("filteroptions");
    for (var i=0; i<forms.length; i++) {
        forms[i].style.display = "";
    }

    /* Explicitly set the selected filter to "All" on page load to override
       any previous filter selected by the user before reloading the page */
    var selects = document.getElementsByClassName("filterinput");
    for (var i=0; i<selects.length; i++) {
        selects[i].selectedIndex = 0;
    }
}

var linefilter = "";
var linefiltername = "";

/* Hide all rows on the build page that don't match the given options */
function filterBuilds(selected) {
    /* The build filter invalidates the line filters */
    linefilter = "";
    linefiltername = "";

    /* Select the chosen option on all filter forms on the page */
    var selects = document.getElementsByClassName("filterinput");
    for (var i=0; i<selects.length; i++) {
       selects[i].selectedIndex = selected.selectedIndex;
    }

    /* Get the regular expression with which to filter */
    var filter = selected.options[selected.selectedIndex].value;
    var filterRE = new RegExp(filter);

    /* Loop around all days of log tables */
    var buildTables = document.getElementsByClassName("compile");
    for (var t=0; t<buildTables.length; t++) {
        var buildRows = buildTables[t].getElementsByTagName("tr");
        for (var i=0; i<buildRows.length; i++) {
            var buildCells = buildRows[i].getElementsByTagName("td");
            /* Ignore the first row holding the table heading */
            if (buildCells.length > 5) {
                if (filterRE.test(buildCells[3].childNodes[0].data)) {
                    /* Show matching */
                    buildRows[i].style.display = "";
                } else {
                    /* Hide non-matching */
                    buildRows[i].style.display = "none";
                }
            }
        }
    }
}

function filterLine() {
    var selected;

    /* Alternate between showing all and showing just this build */
    if (linefilter) {
        linefilter = "";
        selected = 0;   /* All */
    }
    else {
        linefilter = "none";
        selected = -1;  /* invalid */
    }
    linefiltername = ""

    /* Invalidate all filter forms on the page (or set to All,
       as appropriate). This allows the user to use the build filter form
       and get the results he expects. */
    var selects = document.getElementsByClassName("filterinput");
    for (var i=0; i<selects.length; i++) {
       selects[i].selectedIndex = selected;
    }

    /* Start by hiding everything */
    var rows = document.getElementsByClassName("even");
    for (var i=0; i<rows.length; i++) {
        rows[i].style.display = linefilter;
    }
    rows = document.getElementsByClassName("odd");
    for (var i=0; i<rows.length; i++) {
        rows[i].style.display = linefilter;
    }
    /* Get this line's build code */
    var buildcode;
    var buildrow = this.parentNode;
    for (var i=0; i<buildrow.classList.length; i++) {
        if (buildrow.classList[i].match(/^buildcode-/)) {
          buildcode = buildrow.classList[i];
          break;
        }
    }
    /* Show just those lines matching this build code */
    rows = document.getElementsByClassName(buildcode);
    for (var i=0; i<rows.length; i++) {
        rows[i].style.display = "";
    }
}

function filterLineName() {
    var selected;

    /* Alternate between showing all and showing just this build */
    if (linefiltername) {
        linefiltername = "";
        selected = 0;   /* All */
    }
    else {
        linefiltername = "none";
        selected = -1;  /* invalid */
    }
    linefilter = ""

    /* Invalidate all filter forms on the page (or set to All,
       as appropriate). This allows the user to use the build filter form
       and get the results he expects. */
    var selects = document.getElementsByClassName("filterinput");
    for (var i=0; i<selects.length; i++) {
       selects[i].selectedIndex = selected;
    }

    /* Get this line's builder name */
    var builderName = this.childNodes[0].data;

    /* Loop around all days of log tables */
    var buildTables = document.getElementsByClassName("compile");
    for (var t=0; t<buildTables.length; t++) {
        var buildRows = buildTables[t].getElementsByTagName("tr");
        for (var i=0; i<buildRows.length; i++) {
            var buildCells = buildRows[i].getElementsByTagName("td");
            /* Ignore the first row holding the table heading */
            if (buildCells.length > 5) {
                if (buildCells[5].childNodes[0].data == builderName) {
                    /* Show matching */
                    buildRows[i].style.display = "";
                } else {
                    /* Hide non-matching (or show, if toggled) */
                    buildRows[i].style.display = linefiltername;
                }
            }
        }
    }
}

function installLineFilters() {
    var rows = document.getElementsByClassName("even");
    /* Set an onclick handler for the build description */
    for (var i=0; i<rows.length; i++) {
        /* TODO: use a special class for the description TD element
           to future proof this */
        var buildCols = rows[i].getElementsByTagName("td");
        buildCols[4].onclick = filterLine;
        buildCols[5].onclick = filterLineName;
    }
    rows = document.getElementsByClassName("odd");
    for (var i=0; i<rows.length; i++) {
        var buildCols = rows[i].getElementsByTagName("td");
        buildCols[4].onclick = filterLine;
        buildCols[5].onclick = filterLineName;
    }

}

function setUp() {
        showFilter();
        installLineFilters();
}

window.onload = setUp;
