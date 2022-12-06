#!/usr/bin/perl

use 5.34.0;

my $input;
my $markerLength = 14;

open(my $f, "<", "puzzle06.txt");
while(<$f>) {
    chomp;
    $input = $_ if $_;
}
close($f);

sub allDifferent {
    my $s = shift;
    while($s) {
        my $c = substr($s, 0, 1);
        substr($s, 0, 1) = "";
        return 0 if($s =~ /$c/)
    }
    return 1
}

my $i = 0;
while($input) {
    my $s = substr($input,0,$markerLength);
    last if allDifferent($s);
    $i++;
    substr($input,0,1) = ''
}

say $i + $markerLength;

