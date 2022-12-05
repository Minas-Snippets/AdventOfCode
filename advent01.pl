#!/usr/bin/perl

my $snackList = "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000";

sub sumCalories {
	my $sum = 0;
	$sum += $_ for split("\n", $_[0]);
	return $sum
}

my ($elf, $max, $txt) = (0, 0, "There are no elves.");
for ( split("\n\n", $snackList) ) {
	$elf++;
	my $cals = sumCalories($_);
	($max, $txt) = ($cals, "Elf $elf carries the biggest pack with $cals calories") if $cals >= $max 
}
print $txt