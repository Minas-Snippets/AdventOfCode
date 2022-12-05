#!/usr/bin/perl

my @stacks = ( [ "Z" ,"N" ], [ "M", "C", "D" ], [ "P" ] );
my @moves  = ( [ 1, 2, 1 ], [ 3, 1, 3 ], [ 2, 2, 1 ], [ 1, 1, 2 ] );

sub moveCrate {
	my ( $stacks, $move ) = @_;
	my ( $n, $from, $to ) = @$move;
	$from = $stacks->[$from - 1]; 
	$to   = $stacks->[$to - 1];
	my $height = @$from;
	push(@$to, reverse(splice(@$from, $height - $n, $n)))
}

moveCrate(\@stacks, $_) for @moves;

# if a stack is empty, print a space character
print @$_ ? $_->[-1] : ' ' for @stacks
