#!/usr/bin/perl

my $snackList;

open(my $f, "<", "puzzle1.txt");
while(<$f>) {
	$snackList .= $_
}
close($f);

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
