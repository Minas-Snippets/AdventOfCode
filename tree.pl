#!/usr/bin/perl

use 5.32.1;


# data
#
# index`
# 
# day
# 
# machines
# 
# goods
# 
# heuristic value min max
# 
# final value min max
# 
# visited
# 
# parent node
# 
# child nodes


our @rule = ( [ 4, 0, 0 ], [ 2, 0, 0 ], [3,14,0 ], [2, 0, 7] );


our @base_values;

sub set_base_values {
    $base_values[0] = 1;
    $base_values[1] = $rule[1]->[0];
    $base_values[2] = $rule[2]->[0] + $rule[2]->[1]*$base_values[1];
    $base_values[3] = $rule[3]->[0] + $rule[3]->[2]*$base_values[2];
}

sub h {
#  The heuristic function

    my ($day, $machines, $goods) = @_;
    my $h = 0;
    for(0..3) {
        $h += ((24 - $day) * $machines->[$_] + $goods->[$_])*$base_values[$_]
    }
    return $h
}



our @d = ( [ 0,1, 1,0,0,0, 0,0,0,0, 24,24,-1,-1, 0,0 ] ); 

set_base_values(\@rule,\@base_values);

go(0);


sub get_choices {
    my $i = shift;
    my @c;
    my $day = $d[$i]->[1] + 1;
    my @mac = map{ $d[$i]->[$_] }(2..5);
    my @gds = map{ $d[$i]->[$_] }(6..9);
    $gds[$_] += $mac[$_] for(0..3);
    my $cap0 = int($gds[0]/$rule[0]->[0]);
    my $j = @d;
    for my $c0 (0..$cap0) {
        my $g00 = $gds[0]-$c0*$rule[0]->[0];
        my $m0  = $mac[0]+$c0;
        my $cap1 = int($g00/$rule[1]->[0]);
        for my $c1 (0..$cap1) {
            my $g10 = $g00 - $c1*$rule[1]->[0];
            my $g11 = $gds[1];
            my $m1  = $mac[1]+$c1;
            my $cap2 = min( int($g10/$rule[2]->[0]), 
                            int($g11/$rule[2]->[1]));
            for my $c2 (0..$cap2) {
                my $g20  = $g10 - $c2*$rule[2]->[0];
                my $g21  = $gds[1] - $c2*$rule[2]->[1];
                my $g22  = $gds[2];
                my $m2   = $mac[2]+$c2;
                my $cap3 = min( int($g20/$rule[3]->[0]),
                                int($g22/$rule[3]->[2]));
                for my $c3 (0..$cap3) {
                    my $g30 = $g20 - $c3*$rule[3]->[0];
                    my $g31 = $g21;
                    my $g32 = $g22 - $c3*$rule[3]->[2];
                    my $g33 = $gds[3];
                    my $m3  = $mac[3]+$c3;
                    
                    my $h = h($day,[$m0,$m1,$m2,$m3],[$g30,$g31,$g32,$g33]);
                    push(@d,[$j, $day, $m0,$m1,$m2,$m3,$g30,$g31,$g32,$g33,$h,$h,-1,-1,0,$i ]);
                    push(@c,$j,$h);
                    $j++
                }
            }
        }
    }
    return @c
}

sub show_status {
    my $i = shift;
    say "node ($i) day ".$d[$i]->[1]." machines: ".join(",",(@{$d[$i]}[2..5]))." goods: ".join(",",(@{$d[$i]}[6..9]))." heuristic values: ".$d[$i]->[10]."/".$d[$i]->[11];
}

sub remove_node {
}


sub go {
    my $i = shift;
    say "called go($i)";
    show_status($i);
    my $day = $d[$i]->[1];
    my $parent = $d[$i]->[15];
    if($day == 24) {
        $d[$i]->[14] = 1;
        say "final result: ".$d[$i]->[9];
        go($parent)
    }
    if($d[$i]->[14]) {
 #       my @children = (@{$d[$i]}[16 .. @{$d[$i]}-1 ]);
        say "went back to $i";
        my $j = find_best(@{$d[$i]}[16 .. @{$d[$i]}-1 ]);
        say "chose ".($j<0 ? "parent node $parent" : $j); 
        say "node ".($j<0 ? "parent node $parent" : $j)." has" .( $d[$j<0 ? $parent : $j]->[14] ? '' : ' not ' )."been visited";
        exit if $j < 0 && $i == 0;
        go($j < 0 ? $parent : $j);
        
#         hier bin ich 
        
        return
    } 
    $d[$i]->[14] = 1; # visited
        say "node $i has " .( $d[$i]->[14] ? '' : ' not ' )."been visited";
        
        
        
    my @c = get_choices($i);
    say "choices: (".join(",",@c).")";
    my ($min, $max) = map{$d[$i]->[$_]}(10,11);
    my $c = @c;
    $c /= 2;
    push(@{$d[$i]}, $c[2*$_]) for (0 .. $c-1);
    my $hmin = min(map{ $c[2*$_+1] }(0 .. $c-1)); 
    my $hmax = max(map{ $c[2*$_+1] }(0 .. $c-1));
    if($hmin < $min) {
        say "update min from $min to $hmin";
        $d[$i]->[10] = $hmin;
        update_minmax($parent,$min,0)
    }
    if($hmax > $max) {
        say "update max from $max to $hmax";
        $d[$i]->[10] = $hmax;
        update_minmax($parent,$max,1)
    }
    
    my $j = find_best(@c);
    say "Best choice: $j";
    go($j < 0 ? $parent : $j)
}

sub find_best {
    my $i = -1;
    my $m = -1;
    my $c = @_/2 - 1;
    for(0..$c) {
        $d[$_[2*$_]]->[14] and next;
        $_[2*$_+1] <= $m and next;
        ($i, $m) = ($_[2*$_],$_[2*$_+1])
    }
    return $i
}


sub update_minmax {
    my ($i, $v, $q) = @_; # q = 0 min, q = 1 max
    return if((2*$q-1)*$v <= (2*$q-1)*$d[$i]->[10 + $q]);
    $d[$i]->[10 + $q] = $v;
    return if $i == 0;
    update_minmax($d[$i]->[15],$v,$q)
}


sub min {
    my $m = shift;
    for(@_) {
        $m = $_ if $_ < $m
    }
    return $m
}

sub max {
    my $m = shift;
    for(@_) {
        $m = $_ if $_ > $m
    }
    return $m
}
