use strict;
use Curl::easy;

package Curl;

# curl session handle
my $handle;

sub new {
    my $class = shift;
    my $self = {};

    $self->{handle} = undef;

    my $moo;

    $moo = Curl::easy::init();
    
    if(0 == $moo) {
        die "libcurl panic";
    }
    
    bless $self, $class;
    $self->{handle} = $moo;
    $self->{body} = undef;

    return $self;
}

sub body_callback {
    my ($chunk,$handle)=@_;
    $$handle .= $chunk;
    return length($chunk); # OK
}
sub get {
    my ($self, $url) = @_;
    my $retcode;

    # store URL in the "object"
    $self->{url}=$url;

    $retcode = Curl::easy::setopt($self->{handle},
                                Curl::easy::CURLOPT_WRITEFUNCTION,
                                  \&body_callback);

    $retcode = Curl::easy::setopt($self->{handle},
                                Curl::easy::CURLOPT_FILE,
                                  \$self->{body});

    $retcode = Curl::easy::setopt($self->{handle},
                                Curl::easy::CURLOPT_URL, $url);
    if($retcode) {
        return $retcode;
    }

    $retcode = Curl::easy::perform($self->{handle});

    if($retcode) {
        return $retcode;
    }

    return $self->{body};
}
# Cleanup
sub DESTROY {
    my ($self)= @_;
    if($self->{handle}) {
      Curl::easy::cleanup($self->{handle});
    }
}

1;
