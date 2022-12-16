#!/usr/bin/perl

use 5.32.1;

my(@sensors, %beacons);


while(<>) {
    m/[^x]*x=(-?\d+), y=(-?\d+)[^x]*x=(-?\d+), y=(-?\d+)/ or next;
    $beacons{"$3,$4"} = 1;
    push(@sensors,[$1,$2,abs($1-$3) + abs($2-$4)]);
}

my ($y, $n) = (2_000_000, 0);

my @unions;

for(@sensors) {
    my ($i, $j, $d) = @$_;
    my $v = abs($y - $j);
    next if $v > $d;
    my ($a,$b) = ($i-$d+$v,$i+$d-$v);
    unless(@unions || $a > $unions[-1]->[1]) {
        push(@unions,[$a,$b]);
        next
    }
    if($b < $unions[0]->[0]) {
        unshift(@unions,[$a,$b]);
        next;
    }
    if($a > $unions[-1]->[1]) {
        push(@unions,[$a,$b]);
        next;
    }
    my $m = @unions;
    my $k = 0;
    while($k < $m) {
        my ($c, $d) = ($unions[$k]->[0],$unions[$k]->[1]);
        if($a > $d) {
            $k++;
            next
        }
        if($b < $c) {
            splice(@unions,$k,1,[$a,$b]);
            $k = $m;
            next;
        }
        if($b <= $d) {
            $unions[$k]->[0] = $a if $a < $c;
            $k = $m;
            next;
        }
        if($k + 1 == $m) {
            $unions[$k]->[1] = $b;
            $unions[$k]->[0] = $a if $a < $c;
            $k++;
            next
        }
        $a = $c;
        splice(@unions,$k,1);
        $m--;
        $k = 0;
    }
}
my $n = 0;
for(@unions) {
    $beacons{"$_,$y"} or $n++ for $_->[0] .. $_->[1]
}
say $n;

$n = @sensors;
my $r = 4_000_000;

@sensors = sort{ $a->[0] <=> $b->[0] } @sensors;

for my $line (0..$r) {
    my @intervals = ( [ 0, $r ] );
    my $sen = @sensors;
    for(my $k = 0; $k < $sen; $k++) {
        @intervals or next;
        my ($i,$j,$d) = @{$sensors[$k]};
        next if $line + $d < $j;
        if($line - $d > $j) {
            splice(@sensors,$k,1);
            $k--;
            $sen--;
        }
        my $v = abs($line-$j);
        next if $v > $d;
        my ($x1, $x2) = ($i - $d + $v, $i + $d - $v);
        next if $x2 < 0 || $x1 > $r; 
        $x1 = 0  if $x1 < 0;
        $x2 = $r if $x2 > $r;
        my $num = @intervals;
        for(my $m = 0; $m < $num; $m++) {
            my ($a, $b) = @{$intervals[$m]};
            $b < $x1 || $a > $x2 and next;
            if($x1 <= $a) {
                if($x2 >= $b) {
                    splice(@intervals,$m,1);
                    $num--;
                    $m--;
                    next
                }
                $intervals[$m]->[0] = $x2 + 1;
                next;
            }
            if($x2 >= $b) {
                $intervals[$m]->[1] = $x1 - 1;
                next;
            }
            splice(@intervals,$m + 1, 0, [$x2 + 1, $b]);
            $intervals[$m]->[1] = $x1 - 1;
            $m++;
            $num++
        }
    }
    if(@intervals) {
        say (4_000_000*$intervals[0]->[0] + $line);
        exit
    }
}
