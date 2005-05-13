use POSIX qw/strftime/;

my @mname = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
             'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' );
my @dname = ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday',
             'Saturday','Sunday');
my @ord = ( "th", "st", "nd", "rd", "th",
            "th", "th", "th", "th", "th",
            "th", "th", "th", "th", "th",
            "th", "th", "th", "th", "th" );
 
my %mnum = ( Jan => 0, Feb => 1, Mar => 2, Apr => 3, May => 4, Jun => 5,
             Jul => 6, Aug => 7, Sep => 8, Oct => 9, Nov => 10, Dec => 11 );

sub reltime {
    my $then_t  = $_[0];

    my $now_t = time();
    my @now = gmtime( $now_t );
    my @yday = gmtime( $now_t - 86400 );
    my @then = gmtime( $then_t );
    my $diff = $now_t - $then_t;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = @then;

    if ( $diff > 200*86400 ) {
        # another year
        $str = strftime( "%Y-%m-%d", @then );
    }
    elsif ( $diff > 5*86400 ) {
        # not last week
        $str = sprintf( "%d%s %s %02d:%02d", 
                        $mday, $ord[ $mday % 20 ], $mname[$mon],
                        $hour, $min);
    }
    else {
        # last week
        $str = sprintf( "%s %02d:%02d", $dname[$wday], $hour, $min );
    }
    
    return $str;
}

sub reldate {
    my $then_t  = $_[0];

    my $now_t = time();
    my @now = gmtime( $now_t );
    my @yday = gmtime( $now_t - 86400 );
    my @nday = gmtime( $now_t + 86400 );
    my @then = gmtime( $then_t );
    my $diff = abs($now_t - $then_t);
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = @then;

    if ( $diff > 200*86400 ) {
        # another year
        $str = strftime( "%Y-%m-%d", @then );
    }
    elsif ( $diff > 5*86400 ) {
        # not last week
        $str = sprintf( "%d%s %s", $mday, $ord[ $mday % 20 ], $mname[$mon] );
    }
    elsif ($mday != $now[3]) {
        if ( $mday == $yday[3] ) {
            # yesterday
            $str = "yesterday";
        }
        elsif ( $mday == $nday[3] ) {
            # yesterday
            $str = "tomorrow";
        }
        else {
            # last week
            $str = $dname[$wday];
        }
    }
    else {
        # same day
        $str = "today";
    }
    
    return $str;
}

sub nicedate {
    my $indate = $_[0]; # format YYYY-MM-DD
    my $thisyear = $_[1];

    ($tyear, $tmonth, $tday)=split("-", $indate);

    $nice = sprintf("%d %s", $tday, $mname[$tmonth-1]);

#    if($tyear != $thisyear) {
#        $tyear =~ s/^19//g;
#        $nice="$nice $tyear";
#    }
    return $nice;
}
