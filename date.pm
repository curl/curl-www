sub MonthLen {
    my ($month, $year) = @_; # month index (1-12)
                             # year to check (for leap)

    while($month>12) {
        $month-=12;
    }
    if($month<1) {
        $month=1;
    }

    @mlens = (31,
              28, # checked especially
              31,
              30,
              31,
              30,
              31,
              31,
              30,
              31,
              30,
              31);

    if( $month eq 2) {
        # February mean leap year troubles...
        local $len = 28;
        if( (int($year/4)*4 eq $year) &&
           (!(int($year/100)*100 eq $year) ||
            int($year/400)*400 eq $year)) {
            $len = 29;
        }
        return $len;
    }
    else {
        return $mlens[$month-1];
    }
}

# Return the month name of the index given
sub MonthName {
    my $num=$_[0];

    my @mname = ('januari',
                 'februari',
                 'mars',
                 'april',
                 'maj',
                 'juni',
                 'juli',
                 'augusti',
                 'september',
                 'oktober',
                 'november',
                 'december' );

    while( $num > 12 ) {
        $num -= 12;
    }
    if ($num < 1) {
        $num = 1;
    }
    return $mname[$num-1];

}

# Return the month name of the index given, in english
sub MonthNameEng {
    my $num=$_[0];

    my @mname = ('January',
                 'February',
                 'March',
                 'April',
                 'May',
                 'June',
                 'July',
                 'August',
                 'September',
                 'October',
                 'November',
                 'December' );

    while( $num > 12 ) {
        $num -= 12;
    }
    if ($num < 1) {
        $num = 1;
    }
    return $mname[$num-1];

}


# Return the day name of the index given
sub DayName {
    my $num=$_[0];

    my @dname = ('måndag',
                 'tisdag',
                 'onsdag',
                 'torsdag',
                 'fredag',
                 'lördag',
                 'söndag');

    while( $num > 7 ) {
        $num -= 7;
    }
    if ($num < 1) {
        $num = 1;
    }
    return $dname[$num-1];

}

# Return the english day name of the index given
sub DayNameEng {
    my $num=$_[0];

    my @dname = ('Monday',
                 'Tuesday',
                 'Wednesday',
                 'Thursday',
                 'Friday',
                 'Saturday',
                 'Sunday');

    while( $num > 7 ) {
        $num -= 7;
    }
    if ($num < 1) {
        $num = 1;
    }
    return $dname[$num-1];

}


# Display a full range of all months as listview options
# The argument number sets the one to be selected
sub MonthOptions {
    my $select = $_[0];
    my $i;
    my $result="";
    for($i=1; $i<=12; $i++) {
        my $name = MonthName($i);
        if( $i == $select) {
            $result=$result."<option value=".$i." SELECTED>$name\n";
        }
        else {
            $result=$result."<option value=".$i.">$name\n";
        }
    }
    return $result;
}

# Display a full range of all months as listview options
# The argument number sets the one to be selected
sub MonthOptionsEng {
    my $select = $_[0];
    my $i;
    my $result="";
    for($i=1; $i<=12; $i++) {
        my $name = MonthNameEng($i);
        if( $i == $select) {
            $result=$result."<option value=".$i." SELECTED>$name\n";
        }
        else {
            $result=$result."<option value=".$i.">$name\n";
        }
    }
    return $result;
}


# Display a full range of all (supported) years as listview options
# The argument number sets the one to be selected
sub YearOptions {
    my $select = $_[0];
    my $i;
    my $result="";
    my $i;
    for($i=0; $i<9; $i++) {
        my $year = 1998 + $i;
        if( $year == $select) {
            $result=$result."<option SELECTED>$year\n";
        }
        else {
            $result=$result."<option>$year\n";
        }
    }
    return $result;
}

# Display a full range of all days as listview options
# The argument number sets the one to be selected
sub DayOptions {
    my $select = $_[0];
    my $i;
    $result="";
    for($i=1; $i<32; $i++) {
        if( $i == $select) {
            $result=$result."<option SELECTED>$i\n";
        }
        else {
            $result=$result."<option>$i\n";
        }
    }
    return $result;
}

sub ThisDay {
    my $time = time();
    my @thistime=localtime($time);
    return $thistime[3];
}
sub ThisMonth {
    my $time = time();
    my @thistime=localtime($time);
    return ++$thistime[4];
}
sub ThisYear {
    my $time = time();
    my @thistime=localtime($time);
    return $thistime[5]+1900;
}

sub TodayNicely {
    return &ThisDay." ".&MonthName(&ThisMonth)." ".&ThisYear;
}

sub TodayNicelyEng {
    return &MonthNameEng(&ThisMonth)." ".&ThisDay." ".&ThisYear;
}

1;
