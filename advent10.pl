#!/usr/bin/perl

use 5.34.0;

sub draw {
    my $p = ($_[0]-1) % 40;
    print abs($_[1]-$p) < 2 ? '#' : '.', $p==39 ? "\n" : ''
}

my ($c,$x,$s) = (1,1,0);

while(<STDIN> =~ /(\w+)\s*(\S*)/) {
    draw($c++,$x);
    $s += $c*$x if $c%40 == 20;
    $1 eq 'addx' or next;
    draw($c++,$x);
    $x += $2;
    $s += $c*$x if $c%40 == 20
}

say $s
