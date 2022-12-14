#!/usr/bin/perl

use 5.32.1;

my %rocks;

my $u = 0;
while(<>) {
    chomp;
    my @m = split ' -> ';
    my @a = split(',',shift @m);
    $a[1] > $u and $u = $a[1]; 
    while(@m) {
        my @b = split(',',shift @m);
        $b[1] > $u and $u = $b[1];
        my $i = $a[0] == $b[0] ? 1 : 0;
        map { $rocks{ $i ? $a[0].','.$_ : $_.','.$a[1] } = 1 } z($a[$i], $b[$i]);
        @a = @b
    }
}

my ($stop, $n, $f) = (0, 0, 0);

do {
    $n++;
    my ($r, @s) = (0, 500, 0);
    do {
        ($r, @s) = t(\%rocks, @s);
        $r ||= $s[1] > $u;
        $stop = $r && !$s[1];
        while(!$r && $s[1] < $u + 2) {
            ($r, @s) = t(\%rocks, @s);
            $r ||= $s[1] > $u
        }
        $r and $rocks{$s[0].','.$s[1]} = 1;
        $f = $n-1 if !$f && $s[1] >= $u
    } until $r || $stop
} until $stop;

say "$u\nfall (part 1) at $f\nstop (part 2) at $n";

sub t {
    my ($z, $r, $x, $y) = (1, @_);
    my @t = map{ ($x+$_).','.($y+1) } (0, -1, 1);
    while(my $t = shift @t) {
        $r->{$t} or ($z, $x, $y, @t) = (0, split(',', $t))
    }
    return ($z, $x, $y)
}

sub z { $_[0] < $_[1] ? $_[0]..$_[1] : $_[1]..$_[0] }
