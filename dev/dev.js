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

/* Forms are made invisible in CSS by default, and only enabled if JavaScript
   is available and therefore the feature is usable by the user */
function showFilter() {
    var forms = document.getElementsByClassName("filteroptions");
    for (var i=0; i<forms.length; i++) {
        forms[i].style.display = "";
    }
}
window.onload = showFilter;

/* Hide all rows on the build page that don't match the given options */
function filterBuilds() {
    var filterOption = document.getElementsByName("filter")[0];
    /* the regular expression to filter by */
    var filter = filterOption.options[filterOption.selectedIndex].value;
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
                    /* Hide non-matching */
                    buildRows[i].style.display = "";
                } else {
                    /* Show matching */
                    buildRows[i].style.display = "none";
                }
            }
        }
    }
}
