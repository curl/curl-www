# Manually associate os-flavour pair with a pix filename (without extension)
my %autoimgmap = (
    'HurdArch' => 'archhurd',
    'Win32'    => 'win32-2',
    'Win64'    => 'win32-2',
);

# Input: requested image name, os, flavour
# Output: image filename with extension, or empty
sub dlpix {
    my $img;
    my ($imgi, $os, $flav) = @_;

    if($imgi && -f '../pix/'.$imgi) {
        $img=$imgi;
    }
    # If not set explicitly or missing, find logos automatically by using
    # the flavour or os name as the image filename.
    else {
        my $imgid;
        if($autoimgmap{"$os$flav"}) {
            $imgid=$autoimgmap{"$os$flav"};
        }
        else {
            if($flav) {
                $imgid=$flav;
            }
            else {
                $imgid=$os;
            }
            $imgid =~ s/[^a-zA-Z0-9]//g;
            $imgid=lc $imgid;
        }
        if(   -f '../pix/'.$imgid.'.svg') {
            $img=$imgid.'.svg';
        }
        elsif(-f '../pix/'.$imgid.'.png') {
            $img=$imgid.'.png';
        }
        elsif(-f '../pix/'.$imgid.'.jpg') {
            $img=$imgid.'.jpg';
        }
    }

    return $img;
}
