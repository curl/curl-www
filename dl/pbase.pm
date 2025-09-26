#        _
#  _ __ | |__   __ _ ___  ___
# | '_ \| '_ \ / _` / __|/ _ \
# | |_) | |_) | (_| \__ \  __/
# | .__/|_.__/ \__,_|___/\___|
# |_|
#
# A simple database in pure perl.
#
# Main author: Kjell.Ericson@haxx.se
#
# Non-commercial use: Do whatever you want with it. If you add something
# useful then send me a copy of it so I can replace the current version.
#
# Commercial use: Send me an email and tell me that you use it.
#
# pbase has borrowed main functionality, the database file format and some
# other ideas of "dbase" made by Bjorn.Stenberg@haxx.se. dbase is an
# executable standalone database handler, while pbase is a perl-included
# version.
#
# How it works:
#  The principle with pbase is hash-arrays. The whole database is stored
# as one array of hash-arrays (named $Database). One hash-array corresponds
# to one row of a database table. Each field of a database table corresponds
# to an item of the hash-array.
#  The database is loaded only once. The user can decide to select parts of
# the database into selections. You can always get back an old selection if
# you have stored the current selection with the "clone_selection"-function.
#  Every function (except delete) only acts on the current selection.
#
#  Each row of the database selection is numbered from 0 to size()-1. The user
# must use this index number to retrieve data (or the ID of the row).
#
#  Each row of the database has a field called "__id" that is uniq and saved
# with the database.
#
#  When the user gets a row, he actually gets a reference to a hash-array. This
# could be used for direct changes or copied to a temporary local hash-array.
# I do not care.
#
#  The format of the database is compatible to "Frexx dbase" by Bjorn Stenberg.
# First line is "- 0123456789ABCDEF" where the numbers build the ID of the row.
# Second line is "fieldname:length:" and then comes lines of maximum 70 chars
# containing the data, with \n, \r, \t escaped to readable form.
#
#  A template file is used (if existing) to be able to decide which fields you
# database shall have. If no template (*.tem) file is found, then all fields
# are accepted and treated as strings. The template file shall have the same
# name as the database except ending with ".tem" instead of ".db".
#  The format of the template file is like this:
# -----------------------------------
#  [field name]:[type]
#
# The field name may only contain characters [A-Za-z0-9]
# The type is one of these three:
#  * int    - standard 32/64-bit integer
#  * string - character string, where NL is the only control character allowed
#  * bin    - binary data - anything goes (not supported in pbase)
#
# Lines beginning with # or whitespace are ignored
# -----------------------------------
#
#  Large database files can be parsed with the parse-functions.
#
#  A database file is locked when opened, and unlocked when closed. So only one
# user can access a database. Remember to keep your actions small and fast.
#
# ==============================
# History:
#
# v0.10 1999-Mar-07  Kjell Ericson - first version
# v0.11 1999-Mar-30  Kjell Ericson - added open/close and parse-functions
# v0.12 1999-Apr-01  Kjell Ericson - added selection possibility to parse_next
# v0.20 1999-Apr-04  Kjell Ericson - major updating, added version
# v0.21 1999-May-21  Kjell Ericson - Forgot to remove all \n and \r
# v0.22 1999-Jul-01  Kjell Ericson - Added modify()
#                                    Added 'append'-parameter to save()
#                                    Added get_all_id().
# v1.0 1999-Jul-05   Kjell Ericson - Changed "change", "modify", "delete" and "get"
#                                    to accept a taglist like ("pos", 52, ...) or
#                                    ("id", 1234567, ...) to get a better interface.
# v1.2 1999-Dec-14  Kjell Ericson - made it possible to select with greater or less
#                                    than, using "<" or ">" (see "-").
# v1.3 2000-Jan-24  Kjell Ericson - Added find()
# v1.4 2000-Jan-24  Kjell Ericson - sort("-...") did not work.
# v1.5 2000-Feb-29  Björn Stenberg - removed some warnings.
# v1.6 2000-Mar-02  Kjell Ericson - removed more warnings (not all).
# v1.7 2000-Mar-11  Kjell Ericson - Adding more comments.
# v1.8 2000-Jun-28  Kjell Ericson - Added "<" at open()-calls
# v1.9 2001-Nov-19  Kjell Ericson - Fixed save-append
# v1.10 2003-Mar-14 Kjell Ericson - Added find_all
# v1.12 2003-Mar-17 Kjell Ericson - Fast get("id")
# v1.12 2003-Mar-17 Kjell Ericson - Bugfix av get("id")
# v1.13 2003-Mar-27 Kjell Ericson - Do not save empty items.
# ==============================


#                                 _
#   _____  ____ _ _ __ ___  _ __ | | ___ ___
#  / _ \ \/ / _` | '_ ` _ \| '_ \| |/ _ Y __|
# |  __/>  < (_| | | | | | | |_) | |  __|__ \
#  \___/_/\_\__,_|_| |_| |_| .__/|_|\___|___/
#                          |_|
# I let these example talk for themselves.
#
# ## First a little example how to open and print a whole database.
#
# $db=new pbase;
# $db->open("databasename");
# for ($i=0; $i<$db->size(); $i++) {
#   %row=%{$db->get($i)};
#   print $row{"name"}
# }
# $db->close();
#
#
# ## Example of adding a row
#
# $db->open("file");
# $db->add("name", "kjell", "sex", "male");
# $db->save();
#
#
# ## Example of parsing a database
#
# $db2->parse_open("db2");
# while (!$db2->parse_eof()) {
#    %row=$db2->parse_next("number", "28|26");
#    while (($id,$val)=each %row) {
#        print "$id=$val\n";
#    }
# }
# $db2->parse_close();
#
# ...more advanced examples can be found in "test.pl"
#

#  ____
# / ___|  ___  _   _ _ __ ___ ___
# \___ \ / _ \| | | | '__/ __/ _ \
#  ___) | (_) | |_| | | | (_|  __/
# |____/ \___/ \__,_|_|  \___\___|

use FileHandle;

# Package name:
package pbase;

# Let's define the file lock possibilities.
$LOCK_SH = 1;# Shared
$LOCK_EX = 2;# Exclusive
$LOCK_NB = 4;# Do not block when locking
$LOCK_UN = 8;# Unlock
$use_lock = 1; #set to 1 if locks shall be used
$version="1.13";

return 1;

#>add
#            _     _
#   __ _  __| | __| |
#  / _` |/ _` |/ _` |
# | (_| | (_| | (_| |
#  \__,_|\__,_|\__,_|
#
# Add a row to the database and the current selection
# Input: hash array
# Output: id of the created row
# Example:
#   $db->add("name", "kjell", "sex", "male");
#
#
sub add
{
    my($self, %input)=@_;
    local $count;
    local $id;
    local $last_dataindex=$#{$self->{Database}}+1;

    $id=time().(int rand(10000)); # make an ID
    while (exists $self->{database_id}{$id}) {
        $id=$id+1;
    }
    $input{"__id"}=$id;
    %{$self->{Database}[$last_dataindex]}=%input;
    $self->{database_id}{$id}=$last_dataindex;

    $self->{selectionlist}[$self->{selection}][$self->size()]=$last_dataindex;
    return $id;
}

#>change
#       _
#   ___| |__   __ _ _ __   __ _  ___
#  / __| '_ \ / _` | '_ \ / _` |/ _ \
# | (__| | | | (_| | | | | (_| |  __/
#  \___|_| |_|\__,_|_| |_|\__, |\___|
#                         |___/
# Input: id - ID of the item to update ("id", 1234)
#             or position i database ("pos",$number).
#        hash - data to store
# Output: id we used
#
# Note: If id is "", then the ID is taken from the data.
# Note: An add() will be performed if the id is invalid
# Examples:
#   $db->change("id", 123456, "name", "kjell", "sex", "male");
#   $db->change("pos", 0, "name", "Willy");
#
sub change
{
    my($self, $id, @rest)=@_;
    local $count;
    local $dataindex=$#{$self->{Database}}+1;
    local %input;

    if ($id eq "id") {
        $id=shift(@rest);
    }
    if ($id eq "pos") {
        $id=$self->{Database}[$self->{selectionlist}[$self->{selection}][shift(@rest)]]{"__id"};
        return -1 if ($id eq "");
    }
    %input=@rest;
    if ($id eq "") {
        $id=$input{"__id"};
        if ($id eq "") {
            return $self->add(%input);
        }
    }
    $dataindex=$self->find_id_in_database($id);
    if ($dataindex == -1) {
        return $self->add(%input);
    }
    $input{"__id"}=$id;
    %{$self->{Database}[$dataindex]}=%input;
    return $id;
}

#>clear
#      _
#  ___| | ___  __ _ _ __
# / __| |/ _ \/ _` | '__|
#| (__| |  __/ (_| | |
# \___|_|\___|\__,_|_|
# Clear (empties) the whole database
# Input: nothing
# Output: nothing
sub clear
{
    my($self)=@_;
    %{$self->{database_id}}=();
    $self->{selection}=0;
    $#{$self->{selectionlist}}=0;
    @{$self->{selectionlist}[0]}=();
    @{$self->{Database}}=();
    $self->{use_template}=0;
    %{$self->{template}}=();
    $self->reset();
}

#>clone_selection
#       _                               _           _   _
#   ___| | ___  _ __   ___     ___  ___| | ___  ___| |_(_) ___  _ __
#  / __| |/ _ \| '_ \ / _ \   / __|/ _ \ |/ _ \/ __| __| |/ _ \| '_ \
# | (__| | (_) | | | |  __/   \__ \  __/ |  __/ (__| |_| | (_) | | | |
#  \___|_|\___/|_| |_|\___|___|___/\___|_|\___|\___|\__|_|\___/|_| |_|
#                        |_____|
# Clone the current selection and set the clone as the active selection.
# Input: none
# Output: number of the old selection
#
sub clone_selection
{
    my($self)=@_;
    local $old_selection=$self->{selection};
    @{$self->{selectionlist}[++$#{$self->{selectionlist}}]}=@{$self->{selectionlist}[$self->{selection}]};
    $self->{selection}=$#{$self->{selectionlist}};
    return $old_selection;
}

#>close
#       _
#   ___| | ___  ___  ___
#  / __| |/ _ \/ __|/ _ \
# | (__| | (_) \__ \  __/
#  \___|_|\___/|___/\___|
# Closes the lock on the database file.
# You can call this function and still use the database object to read from.
# You should not change or save it (unspecified behaviour).
#
# Input: nothing
# Output: nothing
sub close
{
    my($self)=@_;
    if ($self->{Database_filename} ne "") {
        flock($self->{database_file}, $LOCK_UN) if ($use_lock);
        CORE::close $self->{database_file} ;
    }
    $self->{Database_filename}="";
}

#>delete
#      _      _      _
#   __| | ___| | ___| |_ ___
#  / _` |/ _ \ |/ _ \ __/ _ \
# | (_| |  __/ |  __/ ||  __/
#  \__,_|\___|_|\___|\__\___|
# Delete a row of the database and current selection
# Input: ID of the row to delete ("id", 1234), or position ("pos", $number)
#        for databaseindex.
# Output: 0 if we found what to delete, nonzero otherwise
# Examples:
#        $db->delete("id", $idnumber);
#        $db->delete("pos", 0);
sub delete
{
    my($self, @p)=@_;
    local $id=$p[0]; #first arg is ID to remove
    local $count;
    local $returnval=-1;
    local $dbindex=-1;
    local $selectioncount;

    if ($id eq "pos") {
        $id=$self->{Database}[$self->{selectionlist}[$self->{selection}][$p[1]]]{"__id"};
        return -1 if ($id eq "");
    }
    if ($id eq "id") {
        $id=$p[1];
        return -1 if ($id eq "");
    }

    for ($selectioncount=0; $selectioncount<=$#{$self->{selectionlist}}; $selectioncount++) {
        for ($count=0; $count<=$#{$self->{selectionlist}[$selectioncount]}; $count++) {
            if ($self->{Database}[$self->{selectionlist}[$selectioncount][$count]]{"__id"} eq $id) {
                $dbindex=$self->{selectionlist}[$selectioncount][$count];
                splice(@{$self->{selectionlist}[$selectioncount]}, $count, 1);
                $count--;
                $returnval=0;
            }
        }
    }
    if ($dbindex>=0) {
        $self->{Database}[$dbindex]{"__deleted"}="yes";
    }
    return $returnval;
}

#     _          _
#  __| | ___ ___| |_ _ __ ___  _   _
# / _` |/ _ Y __| __| '__/ _ \| | | |
#| (_| |  __|__ \ |_| | | (_) | |_| |
# \__,_|\___|___/\__|_|  \___/ \__, |
#                              |___/
# Perl destructor.
#
sub DESTROY {
    my($self)=@_;
    $self->close();
}

#                           _
#  ___ _ __ _ __ ___  _ __ | | ___   __ _
# / _ \ '__| '__/ _ \| '__|| |/ _ \ / _` |
#|  __/ |  | | | (_) | |   | | (_) | (_| |
# \___|_|  |_|  \___/|_|___|_|\___/ \__, |
#                     |_____|       |___/
# If anything goes wrong, then it shall be written in
# a log file called "pbase_error.log"
sub error_log
{
    my($self, $text)=@_;
    if (CORE::open(pbase_error_file, ">>pbase_error.log")) {
        local $tim=localtime(time());
        print pbase_error_file $tim," - ";
        print pbase_error_file $text,"\n";
        CORE::close pbase_error_file;
    }
}

#>find
#   __ _           _
#  / _(_)_ __   __| |
# | |_| | '_ \ / _` |
# |  _| | | | | (_| |
# |_| |_|_| |_|\__,_|
# Find first row of the current selection that fit the criteria
# Input: Hasharray containing the field-name and a regex-pattern that it must
#        match. A minus-sign in front of a field name will negate the match
# Output: reference to a hash-array containing the row or -1 for error
# Example:
#        $ref=$db->find("name", "Bob");
#        print $ref{"name"} if ($ref != -1);
sub find
{
    my($self, @p)=@_;
    local $count;
    local @resultlist;

    for (@{$self->{selectionlist}[$self->{selection}]}) {
        local $num=$_;
        local $result=1;
        for ($count=0; $count<$#p && $result==1; $count+=2) {
            local $match=$p[$count];
            if ($match =~ s/^-//) {
                $result=0 if ($self->{Database}[$num]{$match} =~ m/$p[$count+1]/i);
            } elsif ($match =~ s/^<//) {
                $result=0 if (0<($self->{Database}[$num]{$match} cmp $p[$count+1]));
            } elsif ($match =~ s/^>//) {
                $result=0 if (0>($self->{Database}[$num]{$match} cmp $p[$count+1]));
            } else {
                $result=0 if ($self->{Database}[$num]{$match} !~ m/$p[$count+1]/i);
            }
        }
        if ($result==1) {
            return $self->{Database}[$num];
        }
    }
    return -1;
}

#>find_all
#   __ _           _
#  / _(_)_ __   __| |
# | |_| | '_ \ / _` |
# |  _| | | | | (_| |
# |_| |_|_| |_|\__,_|
# Find first row of the current selection that fit the criteria
# Input: Hasharray containing the field-name and a regex-pattern that it must
#        match. A minus-sign in front of a field name will negate the match
# Output: array of references to a hash-array-rows
# Example:
#        @ref=$db->find_all("name", "Bob");
#        print $ref{"name"} if ($ref != -1);
# See also: find
sub find_all
{
    my($self, @p)=@_;
    my @ret;
    local $count;
    local @resultlist;

    for (@{$self->{selectionlist}[$self->{selection}]}) {
        local $num=$_;
        local $result=1;
        for ($count=0; $count<$#p && $result==1; $count+=2) {
            local $match=$p[$count];
            if ($match =~ s/^-//) {
                $result=0 if ($self->{Database}[$num]{$match} =~ m/$p[$count+1]/i);
            } elsif ($match =~ s/^<//) {
                $result=0 if (0<($self->{Database}[$num]{$match} cmp $p[$count+1]));
            } elsif ($match =~ s/^>//) {
                $result=0 if (0>($self->{Database}[$num]{$match} cmp $p[$count+1]));
            } else {
                $result=0 if ($self->{Database}[$num]{$match} !~ m/$p[$count+1]/i);
            }
        }
        if ($result==1) {
            push @ret, $self->{Database}[$num];
        }
    }
    return @ret;
}

#>find_id
#   __ _           _     _     _
#  / _(_)_ __   __| |   (_) __| |
# | |_| | '_ \ / _` |   | |/ _` |
# |  _| | | | | (_| |   | | (_| |
# |_| |_|_| |_|\__,_|___|_|\__,_|
#                  |_____|
# Find the array-position of an row-ID so you know what's above and below.
# Input: id - ID to find the array-position of
# Output: array-position or -1 for error
# Example:
#        $ref=$db->find_id($id_number);
#        print $ref{"name"} if ($ref != -1);
sub find_id
{
    my($self, $id)=@_;
    local $count;
    for ($count=$self->size()-1; $count>=0; $count--) {
        if (! exists $self->{Database}[$self->{selectionlist}[$self->{selection}][$count]]{"__deleted"} &&
            $self->{Database}[$self->{selectionlist}[$self->{selection}][$count]]{"__id"} eq $id) {
            return $count;
        }
    }
    return -1;
}

#
# Internal function to find an ID in the Database (full selection)
sub find_id_in_database
{
    my($self, $id)=@_;
    local $count;
    for ($count=$#{$self->{Database}}; $count>=0; $count--) {
        if (! exists $self->{Database}[$count]{"__deleted"} &&
            $self->{Database}[$count]{"__id"} eq $id) {
            return $count;
        }
    }
    return -1;
}

#>get
#             _
#   __ _  ___| |_
#  / _` |/ _ \ __|
# | (_| |  __/ |_
#  \__, |\___|\__|
#  |___/
# Get a row
# Input: row position to get
# Output: reference to a hash-array containing the row
# Example: $ref=$db->get(10);
sub get
{
    my($self, $item, $extra)=@_;

    if ($item eq "id") {
#        $item=$self->find_id($extra);
        if ($extra eq "" || $self->{database_id}{$extra} eq "") {
            return "";
        }
        return $self->{Database}[$self->{database_id}{$extra}];
    } elsif ($item eq "pos") {
        $item=$extra;
    }
    if ($item < $self->size() && $item>=0) {
        return $self->{Database}[$self->{selectionlist}[$self->{selection}][$item]];
    }
    return ("");
}

#             _            _ _     _     _
#   __ _  ___| |_     __ _| | |   (_) __| |
#  / _` |/ _ \ __|   / _` | | |   | |/ _` |
# | (_| |  __/ |_   | (_| | | |   | | (_| |
#  \__, |\___|\__|___\__,_|_|_|___|_|\__,_|
#  |___/        |_____|      |_____|
# Get all id:s from a selection in an array.
#
# Input: Nothing or selection to use (default current selection)
# Output: Array containing all id:s.
#
sub get_all_id
{
    my($self, $use_selection)=@_;
    local (@result, $count, $size);

    $use_selection=$self->{selection} if ($use_selection <= $#{$self->{selectionlist}} && $use_selection>=0 && $use_selection ne "");

    $size=$#{$self->{selectionlist}[$use_selection]}+1;
    for ($count=0; $count<$size; $count++) {
        $returnval++;
        $result[++$#result]=$self->{Database}[$self->{selectionlist}[$use_selection][$count]]{"__id"};
    }
    return @result;
}

#             _       _     _
#   __ _  ___| |_    (_) __| |
#  / _` |/ _ \ __|   | |/ _` |
# | (_| |  __/ |_    | | (_| |
#  \__, |\___|\__|___|_|\__,_|
#  |___/        |_____|
# Get a row by its ID
# Input: ID of the row to get
# Output: reference to a hash-array containing the row
#
sub get_id
{
    my($self, $id)=@_;

    $self->error_log("use of old function 'get_id()', use 'get(\"id\", \$id)'.");

    return $self->get($self->find_id($id));
}


#            _      _
#  __ _  ___| |_   | |_ _   _ _ __   ___
# / _` |/ _ \ __|  | __| | | | '_ \ / _ \
#| (_| |  __/ |_   | |_| |_| | |_) |  __/
# \__, |\___|\__|___\__|\__, | .__/ \___|
# |___/        |_____|  |___/|_|
#
# Get the type of a fieldname.
# Returns 'string', 'int' or 'bin' if the field exist.
# Returns an empty string ("") if the field does not exist.
#
# Input: fieldname
# Output: typename
#
sub get_type
{
    my($self, $name)=@_;
    return "string" if (!$self->{use_template});
    return $self->{template}{$name};
}

#
# used for internal use to specify if a row shall be selected
sub internal_selection_match
{
    my($self, $row, $selection_pattern)=@_;
    local ($count, $result=1);
    for ($count=0; $count<$#{@$selection_pattern}; $count+=2) {
        local $match=$$selection_pattern[$count];
        if ($match =~ s/^-//) {
            $result=0 if ($$row{$match} =~ m/$$selection_pattern[$count+1]/i);
        } else {
            $result=0 if (!($$row{$match} =~ m/$$selection_pattern[$count+1]/i));
        }
    }
    return $result;
}

#
# only for internal use of the sort()-function
sub internal_sort_function
{
    my($self, $num1, $num2)=@_;
    local ($result, $count);
    local $ref1;

    for $ref1 (@{$self->{sort_args}}) {
        local $ref=$ref1;
        $ref=~s/^-//;
        if (!$self->{use_template} || $self->{template}{$ref} eq "string") {
            $result=$self->{Database}[$num1]{$ref} cmp $self->{Database}[$num2]{$ref};
        } else {
            $result=$self->{Database}[$num1]{$ref} <=> $self->{Database}[$num2]{$ref};
        }
        $result*=-1 if ($ref1 =~ m/^-/);
        return $result if ($result != 0);
    }
    return 0;
}


#  _                 _
# | | ___   __ _  __| |
# | |/ _ \ / _` |/ _` |
# | | (_) | (_| | (_| |
# |_|\___/ \__,_|\__,_|
# backward compatibility - so far... See open()
# Will produce a row in the pbase_error.log file.
# Input: filename
# Output: Database size or -1 for error
#
sub load
{
    my($self, $filename)=@_;
    $self->error_log("use of old function 'load()'");
    return $self->open($filename);
}

# _                 _    _                       _       _
#| | ___   __ _  __| |  | |_ ___ _ __ ___  _ __ | | __ _| |_ ___
#| |/ _ \ / _` |/ _` |  | __/ _ \ '_ ` _ \| '_ \| |/ _` | __/ _ \
#| | (_) | (_| | (_| |  | ||  __/ | | | | | |_) | | (_| | ||  __/
#|_|\___/ \__,_|\__,_|___\__\___|_| |_| |_| .__/|_|\__,_|\__\___|
#                   |_____|               |_|
# Internal function that load the template file (if existing)
# If a template file is found, the object-global variable $self->{use_template}
# is set to '1'. The %template hasharray is set with the names
# and corresponding types. No type-checking is done.
#
# Input: filename
# Output: 0 if no template file is found.
sub load_template
{
    my($self, $filename)=@_;
    my $fh=FileHandle->new();

    $self->{use_template}=0;

    # Delete the template file
    foreach $key (keys %{$self->{template}}) {
        delete $self->{template}{$key};
    }
    $self->{use_template}=0;

    $filename =~ s/\.db//;
    if (CORE::open $fh, "<".$filename.".tem") {
        $self->{use_template}=1;
        while (<$fh>) {
            # lines starting with space or # are comments.
            if (!m/^[ #]/) {
                s/[\n\r]//g;
                local @parts=split(/:/, $_);
                if ($#parts==1) { # only accept if two items
                    $self->{template}{$parts[0]}=$parts[1];
                }
            }
        }
        CORE::close $fh;
    }
    return $self->{use_template};
}

#                      _ _  __
#  _ __ ___   ___   __| (_)/ _|_   _
# | '_ ` _ \ / _ \ / _` | | |_| | | |
# | | | | | | (_) | (_| | |  _| |_| |
# |_| |_| |_|\___/ \__,_|_|_|  \__, |
#                              |___/
# Modify a row, appending or changing some items.
#
# Input: id - ID of the item to update, or ("pos",$number, ...) to specify
#             database position.
#        data - hasharray to add
# Output: Used id
#
# Note: An add() will be performed if the id is invalid
# Example: modify($id, "name", "kjell", "sex", "male");
#
sub modify
{
    my($self, $id, @rest)=@_;
    local $count;
    local $dataindex=$#{$self->{Database}}+1;
    local ($kid, $val);

    if ($id eq "id") {
        $id=shift(@rest);
    }
    if ($id eq "pos") {
        $id=$self->{Database}[$self->{selectionlist}[$self->{selection}][shift(@rest)]]{"__id"};
        return -1 if ($id eq "");
    }
    %input=@rest;

    $dataindex=$self->find_id_in_database($id);
    if ($dataindex == -1 || $id eq "") {
        return $self->add(%input);
    }

    while (($kid,$val)=each %input) {
        $self->{Database}[$dataindex]{$kid}=$val;
    }
    $self->{Database}[$dataindex]{"__id"}=$id;
    return $id;
}


#  _ __   _____      __
# | '_ \ / _ \ \ /\ / /
# | | | |  __/\ V  V /
# |_| |_|\___| \_/\_/
# called when instantiating a new pbase object
sub new
{
    my($class,$initializer) = @_;
    my $self = {};
    bless $self,ref $class || $class;
    $self->clear();
    $self->{database_file}=new FileHandle->new();
    $self->{parse_file}=new FileHandle->new();
    $self->{Database_filename}="";
    return $self;
}

#  ___  _ __   ___ _ __
# / _ \| '_ \ / _ \ '_ \
#| (_) | |_) |  __/ | | |
# \___/| .__/ \___|_| |_|
#      |_|
# Open a database for read and write. The whole database is read into memory.
# A new file will be created if the database does not exist.
# The database file will be locked for security until a call to close() is
# made. You can make a direct call to close() and still be able to read
# from the database object. But do not try to change or save the database then.
#
# Input: filename
# Output: Database size or -1 for error
#
sub open
{
    my($self, $filename)=@_;
    local $returnval=-1;

    $self->clear();
    $filename =~ s/\.db$//;
    $self->{Database_filename}=$filename;
    if (CORE::open($self->{database_file}, "+<".$filename.".db")) {
        flock($self->{database_file},$LOCK_EX) if ($use_lock);
        $returnval=0;
    } elsif (CORE::open($self->{database_file}, "<".$filename.".db")) {
        $returnval=0;
    }
    if ($returnval==0) {
        local ($val, $id, $name, $length);
        local %substitute=("\\n","\n", "\\r","\r", "\\t","\t", "\\\\","\\");
        local $items=-1;
        local $fh=$self->{database_file};

        $self->load_template($filename);
        while (<$fh>) {
            if (m/^-/) {
                $items++;
                ($val, $id)=split(" ", $_);
                $id=~s/[\n\r ]//g;
                $self->{Database}[$items]{"__id"}=$id;
                $self->{database_id}{$id}=$items;
            } elsif ($items>=0) {
                if (m/:[0-9]*:/) {
                    ($name, $length, $val)=split(":", $_);
                    local $result="";
                    if ($val =~ m/[0-9]/) {
                        $result=$val;
                    } else {
                        do {
                            $val=<$fh>;
                            $val =~ s/^://;
                            $val =~ s/[\n\r]//g;
                            $length-=length($val);
                            $result=$result.$val;
                        } while ($length>0 && length($val));
                        $result =~ s/(\\.)/$substitute{$1}/eg;
                    }
                    if (!$self->{use_template} || exists($self->{template}{$name})) {
                        $self->{Database}[$items]{$name}=$result;
                    }
                }
            }
        }
        $#{$self->{selectionlist}}=0;
        @{$self->{selectionlist}[0]}=();
        $self->{selection}=0;
        $self->reset();
        $returnval=$items+1;

#        $returnval=$self->internal_read_database($filename);
    }
    return $returnval;
}


#                    _
#  _ __ ___ ___  ___| |_
# | '__/ _ Y __|/ _ \ __|
# | | |  __|__ \  __/ |_
# |_|  \___|___/\___|\__|
# Reset the current selection to contain the whole database.
# Input: none
# Output: none
#
sub reset
{
    my($self)=@_;
    local ($count, $datacount=0);
    for ($count=$#{$self->{Database}}; $count>=0; $count--) {
        if (! exists $self->{Database}[$self->{selectionlist}[$self->{selection}][$count]]{"__deleted"}) {
            $self->{selectionlist}[$self->{selection}][$datacount++]=$count;
        }
    }

}

#                                   _
# _ __   __ _ _ __ ___  ___     ___| | ___  ___  ___
#| '_ \ / _` | '__/ __|/ _ \   / __| |/ _ \/ __|/ _ \
#| |_) | (_| | |  \__ \  __/  | (__| | (_) \__ \  __/
#| .__/ \__,_|_|  |___/\___|___\___|_|\___/|___/\___|
#|_|                      |_____|
# Close this parsing session
# Input: nothing
# Output: nothing
sub parse_close
{
    my($self)=@_;
    if ($self->{parsing}) {
        flock($self->{parse_file},$LOCK_UN) if ($use_lock);
        CORE::close $self->{parse_file};
        $self->{parsing}=0;
    }
}

#                                          __
# _ __   __ _ _ __ ___  ___     ___  ___  / _|
#| '_ \ / _` | '__/ __|/ _ \   / _ \/ _ \| |_
#| |_) | (_| | |  \__ \  __/  |  __/ (_) |  _|
#| .__/ \__,_|_|  |___/\___|___\___|\___/|_|
#|_|                      |_____|
# Check if the end of the database file is reached.
# Input: nothing
# Output: true if the parsing is over, false otherwise
sub parse_eof
{
    my($self)=@_;

    return eof($self->{parse_file});
}

#                                               _
# _ __   __ _ _ __ ___  ___     _ __   _____  _| |_
#| '_ \ / _` | '__/ __|/ _ \   | '_ \ / _ \ \/ / __|
#| |_) | (_| | |  \__ \  __/   | | | |  __/>  <| |_
#| .__/ \__,_|_|  |___/\___|___|_| |_|\___/_/\_\\__|
#|_|                      |_____|
# Gets the next row of the parsing database file
# Input: An array of selection rules or nothing to accept everything
# Output: A hasharray contaioning a database row
# See also: parse-functions, select()
sub parse_next
{
    my($self, @selectlist)=@_;
    local ($line, $val, $id);
    local ($name, $length);
    local %substitute=("\\n","\n", "\\r","\r", "\\t","\t", "\\\\","\\");
    local $fh=$self->{parse_file};

    while (1) { # Yes, an infinite loop
        local %row=();
        # find the next ID
        while ($self->{parse_next_id} eq "") {
            return if (eof($self->{parse_file}));
            $line=<$fh>;
            $self->{parse_next_id}=$line if ($line =~ m/^-/);
        }
        ($val, $id)=split(/ /, $self->{parse_next_id});
        $id=~s/[\n\r ]//g;
        $row{"__id"}=$id;
        $self->{parse_next_id}="";

      PARSE:
        while (<$fh>) {
            if (m/^-/) {
                # We found next ID, return what we found so far and
                # remember the next ID we have
                $self->{parse_next_id}=$_;
                last PARSE;
            } elsif (m/:[0-9]*:/) {
                ($name, $length, $val)=split(":", $_);
                local $result="";
                if ($val =~ m/[0-9]/) {
                    $result=$val;
                } else {
                    do {
                        $val=<$fh>;
                        $val =~ s/^://;
                        $val =~ s/[\n\r]//;
                        $length-=length($val);
                        $result=$result.$val;
                    } while ($length>0 && length($val));
                    $result =~ s/(\\.)/$substitute{$1}/eg;
                }
                if (!$self->{use_template} || exists($self->{template}{$name})) {
                    $row{$name}=$result;
                }
            }
        }
        return %row if ($self->internal_selection_match(\%row, \@selectlist));
    }
}

# _ __   __ _ _ __ ___  ___     ___  _ __   ___ _ __
#| '_ \ / _` | '__/ __|/ _ \   / _ \| '_ \ / _ \ '_ \
#| |_) | (_| | |  \__ \  __/  | (_) | |_) |  __/ | | |
#| .__/ \__,_|_|  |___/\___|___\___/| .__/ \___|_| |_|
#|_|                      |_____|   |_|
# Open a new database to parse. Use parse_next() to get one database row
# returned in sequence. This is good to have when the database is very
# large and you only want to calculate some statistic.
# Shall have a corresponding call to parse_close().
# Input: database name
# Output: -1 for not existing, -2 for error, >0 OK.
# See also: parse-functions.
sub parse_open
{
    my($self, $filename)=@_;
    local $returnval=-1;
    $filename =~ s/\.db$//;
    $self->{parsing}=0;
    if (-e $filename.".db") {
        $self->{parsing}=1 if (open($self->{parse_file}, "<$filename.db"));
        $returnval=0 if ($self->{parse_file});
    } else {
        $self->{parsing}=1 if (CORE::open($self->{parse_file}, "<$filename.db"));
    }
    $self->{parse_next_id}="";
    if ($self->{parsing}) {
        $self->load_template($filename);
        flock($self->{parse_file},$LOCK_EX) if ($use_lock);
    }
    return $returnval;
}



#  ___  __ ___   _____
# / __|/ _` \ \ / / _ \
# \__ \ (_| |\ V /  __/
# |___/\__,_| \_/ \___|
#
# Input: database filename or "" to save under the same name as loaded as.
#        append - optional parameter, 0 to overwrite, 1 to append.
# Output: -1 for error
#
# Note: If you append to the database might you get two rows containing the
#       same id. When opening the database again will only the latest remain.
#       This can though be useful for large databases where you do not want to
#       rewrite the whole database file when only changing one row.
#
sub save
{
    my($self, $filename, $append)=@_;
    local ($val, $id);
    local $count;
    local %substitute=("\n","\\n", "\r","\\r", "\t","\\t", "\\","\\\\");
    local $returnval=-1;
    local $temp="";
    my $file=FileHandle->new();

    if ($filename eq "" && $self->{Database_filename} ne "") {
        $filename=$self->{Database_filename};
    }

    $filename=~s/\.db$//;
    $temp=">$filename.db";
    $temp=">".$temp if ($append>0);

    if (open($file, $temp)) {
        $returnval=0;
        for ($count=0; $count<$self->size(); $count++) {
            $returnval++;
            $id=$self->{Database}[$self->{selectionlist}[$self->{selection}][$count]]{"__id"};
            if (! exists $self->{Database}[$self->{selectionlist}[$self->{selection}][$count]]{"__deleted"} &&
                $id ne "") {
                print $file "- ",$id,"\n";
                while (($id,$val)=each %{$self->{Database}[$self->{selectionlist}[$self->{selection}][$count]]}) {
                    # never save internal codes starting with two underscores
                    if (!($id =~ m/^__/)) {
                        local $type="string";
                        if ($self->{use_template} == 1) {
                            $type=$self->{template}{$id};
                        }
                        if ($type=~m/string/i) {
                            if ($self->{use_template} == 1 || $val ne "") {
                                $val =~ s/([\n\r\t\\])/$substitute{$1}/eg;
                                print $file "$id:",length($val),":\n";
                                do {
                                    print $file ":",substr($val, 0, 70),"\n";
                                    if (length($val)>70) {
                                        $val=substr($val, 70);
                                    } else {
                                        $val="";
                                    }
                                } while (length($val));
                            }
                        } elsif ($type=~m/int/i) {
                            print $file "$id:",length($val),":",$val+0,"\n";
                        }
                    }
                }
            }
        }
        CORE::close $file;
    }
    return $returnval;
}

#           _           _
#  ___  ___| | ___  ___| |_
# / __|/ _ \ |/ _ \/ __| __|
# \__ \  __/ |  __/ (__| |_
# |___/\___|_|\___|\___|\__|
# Remove rows of the current selection that does not fit the criteria
# Input: Hasharray containing the field-name and a regex-pattern that it must
#        match. A minus-sign in front of a field name will negate the match
# Output: Size of the current selection
#
sub select
{
    my($self, @p)=@_;
    local $count;
    local @resultlist;

    for (@{$self->{selectionlist}[$self->{selection}]}) {
        local $num=$_;
        local $result=1;
        for ($count=0; $count<$#p; $count+=2) {
            local $match=$p[$count];
            if ($match =~ s/^-//) {
                $result=0 if ($self->{Database}[$num]{$match} =~ m/$p[$count+1]/i);
            } elsif ($match =~ s/^<//) {
                $result=0 if (0<($self->{Database}[$num]{$match} cmp $p[$count+1]));
            } elsif ($match =~ s/^>//) {
                $result=0 if (0>($self->{Database}[$num]{$match} cmp $p[$count+1]));
            } else {
                $result=0 if ($self->{Database}[$num]{$match} !~ m/$p[$count+1]/i);
            }
        }
        $resultlist[++$#resultlist]=$num if ($result==1);
    }
    @{$self->{selectionlist}[$self->{selection}]}=@resultlist;
    return $#resultlist+1;
}

#           _           _           _
#  ___  ___| | ___  ___| |_     ___| |__
# / __|/ _ \ |/ _ \/ __| __|   / __| '_ \
# \__ \  __/ |  __/ (__| |_   | (__| |_) |
# |___/\___|_|\___|\___|\__|___\___|_.__/
#                         |_____|
# Remove rows of the current selection with help of a callback function
# Input: Reference to a callback-function that shall take a reference to
#        a hash-array and return 1 if the row shall stay in the selection.
#        Return 0 if not.
#        match. A minus-sign in front of a field name will negate the match
# Output: Size of the current selection
#
# Example: $db->select_cb(\&function)
#          sub function
#          {
#            local $ref1=@_[0];
#            return 1 if ( $$ref1{"name"} =~ m/Kjell/);
#            return 0;
#          }
#
sub select_cb
{
    my($self, $callback)=@_;
    local @resultlist;

    for (@{$self->{selectionlist}[$self->{selection}]}) {
        local $ref=$_;
        $resultlist[++$#resultlist]=$ref if (&$callback($self->{Database}[$ref])==1);
    }
    @{$self->{selectionlist}[$self->{selection}]}=@resultlist;
    return $#resultlist+1;
}


#           _                _           _   _
#  ___  ___| |_     ___  ___| | ___  ___| |_(_) ___  _ __
# / __|/ _ \ __|   / __|/ _ \ |/ _ \/ __| __| |/ _ \| '_ \
# \__ \  __/ |_    \__ \  __/ |  __/ (__| |_| | (_) | | | |
# |___/\___|\__|___|___/\___|_|\___|\___|\__|_|\___/|_| |_|
#             |_____|
# Change to a different selection.
# Input: number of selection to use
# Output: number of the old selection
#
sub set_selection
{
    my($self, $use_selection)=@_;
    local $old_selection=$self->{selection};
    $self->{selection}=$use_selection if ($use_selection <= $#{$self->{selectionlist}} && $use_selection>=0);
    return $old_selection;
}


#          _      _
# ___  ___| |_   | |_ _   _ _ __   ___
#/ __|/ _ \ __|  | __| | | | '_ \ / _ \
#\__ \  __/ |_   | |_| |_| | |_) |  __/
#|___/\___|\__|___\__|\__, | .__/ \___|
#            |_____|  |___/|_|
#
# Define what kind of type a fieldname is ('string', 'int' or 'bin').
#
# Input: fieldname
#        type ('string', 'int' or 'bin')
# Output: nothing
sub set_type
{
    my($self, $name, $type)=@_;
    $self->{use_template}=1;
    $self->{template}{$name}=$type;
}

#      _
#  ___(_)_______
# / __| |_  / _ \
# \__ \ |/ /  __/
# |___/_/___\___|
#
# Input: nothing
# Output: size of current selection
#
sub size
{
    my($self)=@_;

    return $#{$self->{selectionlist}[$self->{selection}]}+1;
}




#                 _
#  ___  ___  _ __| |_
# / __|/ _ \| '__| __|
# \__ \ (_) | |  | |_
# |___/\___/|_|   \__|
# Sort the current selection
# Input: array of which fields to sort on. A minus-sign infront of
#        the field-name will revert the sort order.
# Output: nothing
#
# Example: $db->sort("name", "-girlfriend", "city");
#
sub sort
{
    my ($self)=@_;
    shift @_;
    @{$self->{sort_args}}=@_;
    @{$self->{selectionlist}[$self->{selection}]} =
        sort {
            $self->internal_sort_function($a, $b)
            } @{$self->{selectionlist}[$self->{selection}]};
}


#                 _           _
#  ___  ___  _ __| |_     ___| |__
# / __|/ _ \| '__| __|   / __| '_ \
# \__ \ (_) | |  | |_   | (__| |_) |
# |___/\___/|_|   \__|___\___|_.__/
#                   |_____|
# Sort the current selection with an own defined callback function
# Input: Reference to a callback function taking reference to two
#        hash-array and returning -1, 0 or 1 depending on their relation.
# Output: nothing
#
# Example: $db->sort_cb(\&function);
#          sub function {
#            local ($ref1, $ref2)=@_;
#            return ( $$ref1{"name"} cmp $$ref2{"name"});
#          }
#
sub sort_cb
{
    my($self, $subroutine)=@_;

    @{$self->{selectionlist}[$self->{selection}]} =
        sort {&$subroutine(\%{$self->{Database}[$a]},
                            \%{$self->{Database}[$b]}) } @{$self->{selectionlist}[$self->{selection}]};
}

#                     _
# __   _____ _ __ ___(_) ___  _ __
# \ \ / / _ \ '__/ __| |/ _ \| '_ \
#  \ V /  __/ |  \__ \ | (_) | | | |
#   \_/ \___|_|  |___/_|\___/|_| |_|
# Returning version of pbase
sub version
{
    return $version;
}
