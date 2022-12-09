#!/usr/bin/perl

use 5.34.0;

my @v = ( [ 1 ] );

my $m = 10; # set $m = 2 for the first assignment
my @k;
push(@k, [0,0]) for ( 1 .. $m);
my ($h, $t) = ($k[0], $k[-1]);

open(my $f,"<","puzzle09.txt");
while(<$f>) {
    m/^(\w) (\d+)/ or next;
    my ($d, $n) = ($1, $2);
    for( 1 .. $n ) {
        $h->[$d =~ /[UD]/ ? 0  : 1] += $d =~ /[UL]/ ? -1 : 1;
        for my $i (1 .. $m-1) {
            follow($k[$i-1],$k[$i]) if 
                abs($k[$i]->[0] - $k[$i-1]->[0]) > 1 ||
                abs($k[$i]->[1] - $k[$i-1]->[1]) > 1
        }
        add(\@k, \@v);
        $v[$t->[0]]->[$t->[1]] |= 1;
    }
}
close($f);
my $n = 0;
for my $l ( @v ) {
    $n += $_ for @{$l}
}
say $n;

sub add {
    my ($k, $v) = @_;
    my $t = $k->[-1];
    if($t->[0] < 0) {
        unshift(@$v, []);
        push(@{$v->[0]}, 0) for @{$v->[1]};
        $_->[0]++ for @$k
    }
    if($t->[0] >= @$v) {
        push(@$v, []);
        push(@{$v->[-1]}, 0) for @{$v->[0]}        
    }
    if($t->[1] < 0) {
        unshift(@$_, 0) for @$v;
        $_->[1]++       for @$k
    }
    if($t->[1] >= @{$v->[0]}) {
        push(@$_,0) for @$v
    }
}

sub follow {
    $_[1]->[$_] += $_[0]->[$_] <=> $_[1]->[$_] for 0..1
}


