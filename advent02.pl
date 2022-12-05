#!/usr/bin/perl

my %matchPoints = (
	A => { X => 3, Y => 0, Z => 6 },
	B => { X => 6, Y => 3, Z => 0 },
	C => { X => 0, Y => 6, Z => 3 }
);

my %basePoints = ( X => 1, Y => 2, Z => 3 );
my @games = ( [ 'A', 'Y' ], [ 'B', 'X' ], [ 'C', 'Z' ] );


$sum = 0;
$sum += $matchPoints{$_->[0]}->{$_->[1]} + $basePoints{$_->[1]} for @games;
print $sum
