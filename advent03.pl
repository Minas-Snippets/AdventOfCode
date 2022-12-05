#!/usr/bin/perl

my @rucksacks = qw(
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw );

my $n = 0;
our %priorities = map{ ( $_, ++$n, uc($_) , $n + 26) } ( a .. z );

sub compartments {
	my $str = shift;
	my $len = length($str);
	my $mid = int($len/2);
	return ( substr($str, 0, $mid) , substr($str, $mid, $len - $mid) )
}

sub shared {
	my @compartments = compartments($_[0]);
	my %list = map{ $_ => 1 } ( split('',$compartments[0]) );
	return map{ $compartments[1] =~ /$_/ ? $_ : '' } keys( %list )
}

my $sum = 0;
for my $rucksack (@rucksacks) {
	$sum += $priorities{$_} for shared($rucksack);
}
print $sum;
