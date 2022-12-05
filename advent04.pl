#!/usr/bin/perl

my @assignments = (
	[[2,4], [6,8]], [[2,3], [4,5]], [[5,7], [7,9]],
	[[2,8], [3,7]], [[6,6], [4,6]], [[2,6], [4,8]] );
	
sub isIn {
	return $_[0]->[0] <= $_[1]->[0] && $_[0]->[1] >= $_[1]->[1] ? 1 : 0
}

sub containing {
	return isIn($_[0], $_[1]) || isIn($_[1], $_[0]) ? 1 : 0
}

my $sum = 0;
$sum += containing($_->[0],$_->[1]) for @assignments;
print $sum;