#!/usr/bin/perl

use 5.34.0;

my @m;
my $m;

our @mods;

my %ops = (
    '+' => sub { 
        my $e = shift;
        my $k = shift;
        $e->{$_} = ($e->{$_} + $k) % $_ for @mods
    },
    '*' => sub {
        my $e = shift;
        my $k = shift;
        $e->{$_} = ( $e->{$_} * ( $k || $e->{$_} ) ) % $_ for @mods
    }
);

my %mods;

while(<>) {
    chomp;
    s/^\s*//;
    s/\s*$//;
    if(m/Monkey\s+\d+:/) {
        push(@m, { n => 0, i => [ ], t => [ ] });
        $m = $m[-1];
        next
    }
    if(s/Starting items:\s*//) {
        s/\s//g;
        @{$m->{i}} = split(/,/);
        next
    }
    if(s/Operation: new = old //) {
        my @o = split(/\s+/);
        $m->{a} = $o[1] ne 'old' ? $o[1] : 0;
        $m->{f} = $ops{$o[0]};
        next
    }
    if(s/Test: divisible by |If true: throw to monkey |If false: throw to monkey //) {
        $mods{$_} = 1 unless @{$m->{t}};
        push(@{$m->{t}}, $_);
        next
    }
}

@mods = keys %mods;

for my $m ( @m ) {
    my @items = @{$m->{i}};
    for my $i (0 .. @items-1) {
        my $n = $items[$i];
        $m->{i}->[$i] = { };
        %{$m->{i}->[$i]} = map{ $_ => $n % $_ } @mods 
    }
}

my $r = 0;
while($r < 10_000) {
    $r++;
    for (@m) {
        while(@{$_->{i}}) {
            $_->{n}++;
            my $l = shift(@{$_->{i}});
            my ($f,$a) = ( $_->{f} , $_->{a} );
            &{$f}($l,$a);
            my $j = $l->{$_->{t}[0]} ? $_->{t}[2] : $_->{t}[1];
            push(@{$m[$j]->{i}},$l) 
        }
    }
}

@m = sort { $b->{n} <=> $a->{n} } @m;

say $m[0]->{n} * $m[1]->{n};
