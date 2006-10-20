;# dtime.pm
;#
;# Usage:
;#	$time = timelocal($sec,$min,$hours,$mday,$mon,$year);
;#	$time = timegm($sec,$min,$hours,$mday,$mon,$year);

;# These routines are quite efficient and yet are always guaranteed to agree
;# with localtime() and gmtime().  We manage this by caching the start times
;# of any months we've seen before.  If we know the start time of the month,
;# we can always calculate any time within the month.  The start times
;# themselves are guessed by successive approximation starting at the
;# current time, since most dates seen in practice are close to the
;# current date.  Unlike algorithms that do a binary search (calling gmtime
;# once for each bit of the time value, resulting in 32 calls), this algorithm
;# calls it at most 6 times, and usually only once or twice.  If you hit
;# the month cache, of course, it doesn't call it at all.

;# timelocal is implemented using the same cache.  We just assume that we're
;# translating a GMT time, and then fudge it when we're done for the timezone
;# and daylight savings arguments.  The timezone is determined by examining
;# the result of localtime(0) when the package is initialized.  The daylight
;# savings offset is currently assumed to be one hour.

;# Both routines return -1 if the integer limit is hit. I.e. for dates
;# after the 1st of January, 2038 on most machines.

CONFIG: {
    local($[) = 0;
    @epoch = localtime(0);
    $tzmin = $epoch[2] * 60 + $epoch[1];	# minutes east of GMT
    if ($tzmin > 0) {
	$tzmin = 24 * 60 - $tzmin;		# minutes west of GMT
	$tzmin -= 24 * 60 if $epoch[5] == 70;	# account for the date line
    }

    $SEC = 1;
    $MIN = 60 * $SEC;
    $HR = 60 * $MIN;
    $DAYS = 24 * $HR;
    $YearFix = ((gmtime(946684800))[5] == 100) ? 100 : 0;
    1;
}

###########################################################################
#
# week( YEAR, MONTH, DAY)
#
# Returns the ISO 8601 week number of the specified date. Or -1 if the date
# is illegal.
#
# YEAR  = four digit year
# MONTH = 1 - 12
# DAY   = 1 - 28,29,30,31 (according to which month it concerns)
#
# RETURNS
#
# week number, and day-of-the-week number (1-7)

sub week {
    my $year = $_[0];
    my $mon = $_[1];
    my $day = $_[2];

    my $time = timelocal(0,0 ,0, $day, $mon-1, $year-1900);

    if($time < 0) {
	return -1;
    }

    my ($tsec,$tmin,$thour,$tmday,$tmon,$tyear,$twday,$tyday,$tisdst);

    my $weekno;
    my $firstweek;

    ($tsec,$tmin,$thour,$tmday,$tmon,$tyear,$twday,$tyday,$tisdst) =
	localtime($time);

#    print "$tyear $tmon $tmday $twday\n";

    if($mon -1 != $tmon) {
	return -1;
    }

    # struct tm stores yday 0 based, we need it 1 based
    $tyday++;

    # silly americans begin the week on sundays. ISO doesn't
    if( 0 == $twday ) {
	# it it IS a sunday, make it sunday!
	$twday = 7;
    }

    $weekno =    int($tyday / 7);
    $firstweek = $tyday % 7;
    
    $firstweek -= $twday;
    if( ($firstweek <= 0) && ($weekno > 0) ) {
	# break up one week and add the days to FirstWeek_I 
	$weekno--;
	$firstweek += 7;
    }

    if ( $firstweek > -4 ) {
	$weekno++;
    }    

    if ( $firstweek > 3 ) {
	$weekno++;
    }

    if ( 0 == $weekno ) {
	# same as previous year's last day
	($weekno, $nope)= &week($year-1, 12, 31);
    }
    elsif ($weekno > 52) {
	# the last days of the year
#	if(($twday < 4) &&
#	   ($day > 28) ) {
#	    # Three or less days of this year in 53 makes it week 1 instead! 
#	    $weekno = 1;
#	}
        if(($day - $twday) >= 28) {
            $weekno = 1;
        }
    }

    return $weekno, $twday;
}

###########################################################################
#
# week2date( YEAR, WEEK)
#
# Returns the date of monday in the specified ISO 8601 week
#
# YEAR  = four digit year
# WEEK  = 1-52,53 (depending on year)
#
# RETURNS
#
# year, month, day of the given week.

sub week2date {
    my $year = $_[0];
    my $week = $_[1];

   # Mission: we have year and week number. What date does that week
   # start with? (i.e what's the date monday that week)

    my $day=15;
    my $getweek;
    my $getday;

    while($week>53) {
	$week-=53;
    }

    my $month = int(11 * $week/53) + 1; # assume 53 weeks a year

  try:

#    print "== check for week $week at date: $year $month $day\n"; 
    ($getweek, $getday) = &week($year, $month, $day);
#    print "  it proved to be week $getweek\n";	
    if($getweek == -1) {
	$month++;
	$day=1;
	goto try;
    }
    if(($getweek > $week-3) &&
       ($getweek < $week+3)) {
	# correct week and its a monday!
	if(($getweek == $week) &&
	   ($getday == 1)) {
	    ;
	}
	elsif($getweek<$week) {
	    if($week-$getweek>1) {
		$day+=7;
	    }
	    else {
		$day+=(8-$getday);
	    }
	    goto try;
	}
	else {
	    if($getweek-$week>1) {
		$day -= 7;
	    }
	    elsif($getweek==$week) {
		$day -= $getday-1;
	    }
	    else {
		$day -= $getday+6;
	    }
	    if($day <= 0) {
		$day=28;
		$month--;
                if($month == 0) {
                    $month = 12;
                    $year--;
                    $day = 31;
                }
	    }
	    goto try;
	}
    }
    elsif(++$month > 12) {
	$day=0;
	$month=0;
    }
    else {
	goto try;
    }

    return $year, $month, $day;
}




sub timegm {
    local($[) = 0;
    $ym = pack(C2, @_[5,4]);
    $cheat = $cheat{$ym} || &cheat;
    return -1 if $cheat<0;
    $cheat + $_[0] * $SEC + $_[1] * $MIN + $_[2] * $HR + ($_[3]-1) * $DAYS;
}

sub timelocal {
    local($[) = 0;
   $time = &main'timegm + $tzmin*$MIN;
    return -1 if $cheat<0;
    @test = localtime($time);
    $time -= $HR if $test[2] != $_[2];
    $time;
}

sub cheat {
    my $year = $_[5];
    my $month = $_[4];

    if($month < 0) {
        $month += 11+1;
        $year--;
        $_[5]--;
        $_[4]+=12;
    }
    if($month > 11) {
        $month -= 11;
        $year++;
    }
    die "Day out of range 1..31 in dtime.pm\n" 
	if $_[3] > 31 || $_[3] < 1;
    die "Hour out of range 0..23 in dtime.pm\n"
	if $_[2] > 23 || $_[2] < 0;
    die "Minute out of range 0..59 in dtime.pm\n"
	if $_[1] > 59 || $_[1] < 0;
    die "Second out of range 0..59 in dtime.pm\n"
	if $_[0] > 59 || $_[0] < 0;
    $guess = $^T;
    @g = gmtime($guess);
    $year += $YearFix if $year < $epoch[5];
    $lastguess = "";
    while ($diff = $year - $g[5]) {
	$guess += $diff * (363 * $DAYS);
	@g = gmtime($guess);
	if (($thisguess = "@g") eq $lastguess){
	    return -1; #date beyond this machine's integer limit
	}
	$lastguess = $thisguess;
    }
    while ($diff = $month - $g[4]) {
	$guess += $diff * (27 * $DAYS);
	@g = gmtime($guess);
	if (($thisguess = "@g") eq $lastguess){
	    return -1; #date beyond this machine's integer limit
	}
	$lastguess = $thisguess;
    }
    @gfake = gmtime($guess-1); #still being sceptic
    if ("@gfake" eq $lastguess){
	return -1; #date beyond this machine's integer limit
    }
    $g[3]--;
    $guess -= $g[0] * $SEC + $g[1] * $MIN + $g[2] * $HR + $g[3] * $DAYS;
    $cheat{$ym} = $guess;
}

1;
