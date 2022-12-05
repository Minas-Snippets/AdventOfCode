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

my $elf = 0;
my @packList = map{ [ ++$elf, sumCalories($_) ] } split("\n\n", $snackList);
my @elfPacks = sort {$b->[1] <=> $a->[1]} @packList;

print $elfPacks[0]->[1]."\n";
my $sum = 0;
for(0 .. 2) {
	$sum += $elfPacks[$_]->[1];
}
print $sum;
