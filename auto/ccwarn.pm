
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
        ($l =~ /cc: (REMARK|WARNING) File/) ||
        # Intel icc 8.0:
        ($l =~ /: (remark|warning) \#/) ||
        # Intel icc linker:
        ($l =~ /: warning: warning: /) ||
        # MIPS o32 compiler:
        ($l =~ /^cfe: Warning (\d*):/) ||
        # MSVC
        ($l =~ /^[\.\\]*([.\\\/a-zA-Z0-9-]*)\.[chy]\(([0-9:]*)/) ||
        # libtool error
        ($l =~ /^libtool: link: /) ||
        # NetWare's nlmconv linker
        ($l =~ /^nlmconv:/) ||
        # GNU and MIPS ld error
        ($l =~ /^[^ ?*]*ld((32)|(64))?: /))
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
