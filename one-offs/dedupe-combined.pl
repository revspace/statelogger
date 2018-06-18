#!/usr/bin/perl -w
use strict;
use autodie;

my %hash;
open my $fh, "t-bin-combined.txt";
while (defined(my $line = readline $fh)) {
    my ($t, $v, $s) = split " ", $line;
    push @{ $hash{$t}{$s} }, $v;
}

for my $t (sort { $a <=> $b } keys %hash) {
    if (keys(%{ $hash{$t} }) > 1) {
        # irc log is more reliable than the tweets; when in conflict, trust the irc log
        print "$t $hash{$t}{eightdot}[-1]\n";
    } else {
        my ($item) = values %{ $hash{$t} };
        print "$t $item->[0]\n" if @$item == 1;
        print "$t ?\n"   if @$item > 1;

    }
}
