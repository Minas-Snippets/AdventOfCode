#!/usr/bin/perl

use 5.34.0;

my %v = ( 0 => { 0 => 1 } ); # %v for "visited"
my $m = 10;        # set $m (moves) = 2 for the first assignment
my $c = 1;         # $c for count
my @k = map{[0,0]} (1..$m);    # @k for knots
my ($h, $t) = ($k[0], $k[-1]); # $h for "head", $t for "tail"

open(my $f,"<","puzzle09.txt");

while(<$f>) {
    m/^(\w) (\d+)/ or next;
    my ($d, $n) = ($1, $2); # $d for "direction", $n for "number of steps"
    for( 1 .. $n ) {
        $h->[$d =~ /[UD]/ ? 0  : 1] += $d =~ /[UL]/ ? -1 : 1;
        for (1 .. $m-1) {
            follow($k[$_-1],$k[$_]) if 
                abs($k[$_]->[0] - $k[$_-1]->[0]) > 1 ||
                abs($k[$_]->[1] - $k[$_-1]->[1]) > 1
        }
        exists($v{$t->[0]}->{$t->[1]}) or $v{$t->[0]}->{$t->[1]} = ++$c
    }
}
close($f);

sub follow {
    $_[1]->[$_] += $_[0]->[$_] <=> $_[1]->[$_] for 0..1
}

say $c
