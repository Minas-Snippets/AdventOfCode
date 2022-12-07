#!/usr/bin/perl 

use 5.32.1;

no warnings 'experimental'; 

our $tree = { '/' => { 
    dirs  => { }, 
    sum   => 0 } 
};
our $root    = $tree->{'/'};
our $current = $root;

sub sumUp {
    my ($d, $b) = @_;
    $d->{sum}  += $b;
    $d eq $root or sumUp($d->{parent}, $b);
}

sub smalls {
    my ($d, $lim) = @_;
    my $s = 0;
    $s += smalls($_, $lim) for values %{$d->{dirs}}; 
    return $s + ( $d->{sum} <= $lim ? $d->{sum} : 0 ) 
}

sub suff {
    my ($dir, $lim, $inf) = @_;
    for my $d ( values %{$dir->{dirs}}) {
        $inf  = $d->{sum} if $d->{sum} >= $lim && $d->{sum} < $inf;
        my $s = suff($d, $lim, $inf);
        $inf  = $s if $s >= $lim && $s < $inf
    }
    return $inf;
}

open(my $f, "<", "puzzle07.txt");
while(<$f>) {
    chomp;
    next unless $_;
    my @l = split(/\s/,$_);
    given($l[0]) {
        when('$') {
            $l[1] eq 'cd' and 
            $current = $l[2] eq '/' ? $root : ( $l[2] eq '..' ? $current->{parent} : $current->{dirs}{$l[2]} )
        }
        when('dir') {
            $current->{dirs}{$l[1]} = { 
                dirs   => { }, 
                sum    => 0, 
                parent => $current 
            };
        }
        when(/\d+/) {
            $current->{files}{$l[1]} = $l[0];
            $current->{sum}         += $l[0];
            $current eq $root or sumUp($current->{parent}, $l[0])
        }
    }
}
close($f);

say smalls($root, 100_000);

say suff($root, $root->{sum} - 40_000_000, $root->{sum});

