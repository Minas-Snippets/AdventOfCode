#!/usr/bin/perl

use 5.34.0;

my ($c,$x,$s) = (1,1,0);

while(<STDIN> =~ /(\w+)\s*(\S*)/) {
    for($1 eq 'addx' ? (0,$2) : (0)) {
        print abs(($c-1) % 40 - $x) < 2 ? '#' : '.', 
            ($c++ - 1) % 40 == 39 ? "\n" : '';
        $x += $_;
        $s += $c*$x if $c%40 == 20
    }
}

say $s
