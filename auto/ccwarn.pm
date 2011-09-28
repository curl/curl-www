
sub initwarn {
    #
    # Read a list of regexes of patterns we ignore and will not count nor
    # show as compiler error/warnings
    #
    open(IGNORE, "<ignores") || return;

    while(<IGNORE>) {
        if($_ =~ /^\#/) {
            next;
        }
        chomp $_;
        if($_) {
            push @ig, $_;
        }
    }
    close(IGNORE);
    return 0;
}

# given an input line it returns TRUE if it is a CC compiler warning/error
sub checkwarn {
    my ($l)=@_;

    # gcc warning:
    if (($l =~ /([.\/a-zA-Z0-9]*)\.[chsy]:([0-9:]*): /) ||
        # AIX xlc warnings:
        ($l =~ /\"([_.\/a-zA-Z0-9]+)\", line/) ||
        # Tru64 DEC/Compaq C compiler:
        ($l =~ /^cc: ((Warning)|(Error)|(Severe))?: ([.\/a-zA-Z0-9]*)/) ||
        # MIPSPro C 7.3:
        ($l =~ /cc: (REMARK|WARNING|ERROR) File/) ||
        # Intel icc 8.0:
        ($l =~ /: (remark|warning|error) \#/) ||
        # Intel icc 10.1:
        ($l =~ /\(([0-9][0-9]*)\): (error)?: /) ||
        # Intel icc linker:
        ($l =~ /: warning: warning: /) ||
        # MIPS o32 compiler:
        ($l =~ /^cfe: (Warning |Error)(\d*):/) ||
        # MSVC
        ($l =~ /^[\.\\]*([.\\\/a-zA-Z0-9-]*)\.[chy]\(([0-9:]*)/) ||

        # libtool 2 prefixes lots of "normal" lines with "libool: link: " so we
        # cannot use that simple rule to detect errors. Adding "warning:" reduces
        # false positives but skip some legitimate warnings that don't contain
        # "warning:".
        ($l =~ /^libtool: \w+: warning:/) ||
        ($l =~ /^libtool: link:.*cannot find the library/) ||
        ($l =~ /^libtool: link:.*is not a valid libtool object/) ||
        ($l =~ /Warning: .* library needs some functionality/) ||
        ($l =~ /Warning: .* does not have real file for/) ||

        # curl tool detecting libcurl violating CURL_MAX_WRITE_SIZE
        ($l =~ /Warning: .* exceeds single call write limit/) ||

        # NetWare's nlmconv linker
        ($l =~ /^nlmconv:/) ||
        # GNU and MIPS ld error
        ($l =~ /^[^ ?*]*ld((32)|(64))?: /) ||
        # Wine runtime problems
        ($l =~ /^fixme:.*:.*[sS][tT][uU][bB]/) ||
        ($l =~ /^fixme:.*:.*[sS][uU][pP][pP][oO][rR][tT]/) ||
        # AC_MSG_WARN output in configure script
        ($l =~ /configure: WARNING: .*compiler options rejected/) ||
        ($l =~ /configure: WARNING: .*cannot determine strerror_r/) ||
        ($l =~ /configure: WARNING: .*cannot determine non-blocking/) ||
        # problem in runtests.pl script
        ($l =~ /runtests\.pl line/) ||
        # autoconf overquoting in configure script
        ($l =~ /configure: .*command not found/))
    {
        my $re;
        foreach $re (@ig) {
            if($l =~ /$re/) {
                # a line to ignore
                return 0;
            }
        }
        return 1;
    }

    # not a warning or error
    return 0;
}

1;
