#!/usr/bin/perl

use 5.32.1;

our (@a, @r, @l);
my  $l = 'a';
my  %e = map { $l++ => $_  } (0 .. 25 );
our %h = map { $_   => [ ] } (0 .. 25 );
$e{S} = 0;
$e{E} = 25;

our ($n, $m, $s, $e) = (0, -1);
while(<>) { # call with "./advent12.pl inputfile"
    chomp;
    $m++;
    m/^(.*)S/ and $s = length($1) + @a;
    m/^(.*)E/ and $e = length($1) + @a;
    $n = length($_);
    my $l = $_;
    for ( 0 .. $n-1 ) {
        my ($c, $i) = ( $e{substr($l,$_,1)}, scalar(@a) );
        push(@{$h{$c}},$i);
        $c or push(@l,$i);
        push(@a,$c);
    }
}
$m++;

for my $i ( 0 .. $m-1 ) {
    for my $j ( 0 .. $n-1 ) {
        push(@r,[]);
        for( [$i-1,$j], [$i, $j-1], [$i, $j+1], [$i+1,$j] ) {
            my ($k, $l) = @$_;
            $k < 0 || $l < 0 || $k >= $m || $l >= $n || 
            $a[$k*$n+$l] - $a[@r - 1] > 1 or push(@{$r[-1]},$k*$n+$l);
        }
    }
}

my $z = @a;

L: for ($s, @l) {
    my $d = 0;
    my %v = ( );
    my @t = ( $_ );
    while($d < $z && @t) {
        my %n = ( );
        $v{$_} = 1 for @t;
        for ( @t ) {
            if($_ == $e ) {
                $s >= 0 and say "1. $d";
                ($s, $z) = (-1, $d < $z ? $d : $z);
                next L
            }
            $v{$_} or $n{$_} = 1 for @{$r[$_]} 
        }
        @t = keys %n;
        $d++;
    }
}

say "2. $z"
