#!/usr/bin/perl

our ( @g, @v );

open(my $f,"<","puzzle08.txt");
while(<$f>) {
    chomp;
    $_ or next;
    push(@g,[]);
    push(@v,[]);
    while(s/^(\d)(.*)$/$2/) {
        push(@{$g[-1]},$1);
        push(@{$v[-1]},0);
    }
}
close($f);

our $n = @g;
for my $d (0 .. 3 ) {
    for my $i (0 .. ($n-1)) {
        my $max = -1;
        for my $j (0 .. ($n-1)) {
            my ($k, $l) = ( k($d,$i,$j), l($d,$i,$j) );
            $g[$k]->[$l] > $max or next;
            $max = $g[$k]->[$l];
            $v[$k]->[$l] |= 1
        }
    }
}
my $c = 0;
for my $l (@v) {
    $c += $_ for @$l
}
print "$c\n";
my $top = 0;
for my $i ( 1 .. ($n-2) ) {
    for my $j ( 1 .. ($n-2) ) {
        my ($h, $p) = ($g[$i]->[$j], 1);
        for my $d (0..3) {
            my ($step, $add, $ridge, $end) = 
                (0, $d > 1 ? -1 : 1, $d > 1 ? 0 : $n-1, 0);
            do {
                $step++;
                my $k = $i + ($d % 2)     * $add * $step;
                my $l = $j + (1 - $d % 2) * $add * $step;
                $g[$k]->[$l] >= $h ||
                    $ridge == ( $d % 2 ? $k : $l ) and $end = 1;
            } until($end);
            $p *= $step;
        }
        $p > $top and $top = $p;
    }
}
print "$top\n";

sub k { return $_[0] % 2 == 0 ? $_[1] : ($_[0] != 1 ? $n-$_[2]-1 :    $_[2] ) }
sub l { return $_[0] % 2      ? $_[1] : ($_[0]      ? $n-$_[2]-1 :    $_[2] ) } 
