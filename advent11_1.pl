#!/usr/bin/perl

use 5.34.0;

my @m;

my $m;

my %ops = (
    '+' => sub { $_[0] + $_[1] },
    '*' => sub { $_[0] * ( $_[1] || $_[0] ) }
);

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
        $m->{f} = $ops{$o[0]};
        $m->{a} = $o[1] ne 'old' ? $o[1] : 0;
        next
    }
    if(s/Test: divisible by |If true: throw to monkey |If false: throw to monkey //) {
        push(@{$m->{t}}, $_);
    }
}

my $r = 0;
while($r < 20) {
    $r++;
    for (@m) {
        while(@{$_->{i}}) {
            $_->{n}++;
            my $l = shift(@{$_->{i}});
            $l = int(&$f($l,$_->{a})/3);
            push(@{$m[$l % $_->{t}[0] ? $_->{t}[2] : $_->{t}[1]]->{i}},$l) 
        }
    }
}

@m = sort { $b->{n} <=> $a->{n} } @m;

say $m[0]->{n} * $m[1]->{n};
