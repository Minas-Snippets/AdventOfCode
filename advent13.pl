#!/usr/bin/perl

use 5.32.1;

my $d;
while(<>) { $d .= $_ }

my @p = map { m/^(.*)\n(.*)$/ ? [eval($1),eval($2)] : [ ]} split("\n\n",$d);

my ($s, $n) = (0,0);

map { c($_->[0],$_->[1]) > 0 ? $s += 1 + $n++ : $n++ } @p;

say $s;

my @o = ( [[2]], [[6]] );

splice(@o,i(\@o,$_),0,$_) for map{ ($_->[0],$_->[1]) } @p;

say ( (i(\@o,[[2]]) + 1) * (i(\@o,[[6]]) + 1) );

sub i {
    my ($i, $l, $v) = (0, @_);
    while( $i < @$l ) { c($v,$l->[$i++]) >= 0 and return $i - 1 }
    return $i
}

sub c {
    my ($a,$b) = map{ ref($_) ? $_ : [ $_ ] } ($_[0],$_[1]);
    
    for( 0 .. (@$a < @$b ? @$a-1 : @$b-1)) {
        my ($x, $y) = ( $a->[$_], $b->[$_] );
        !ref($x) && !ref($y) ? ($x-$y and return $y-$x) : ($x = c($x,$y) and return $x)
    }
    return @$b - @$a 
}
