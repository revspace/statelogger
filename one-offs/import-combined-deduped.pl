#!/usr/bin/perl -w
use strict;
use autodie;
use POSIX qw(strftime);

### Import from combined data sources. It's a mess and I don't recall exactly
### what I did, so it's not documented. But it's okay, we're not going to do this
### again, ever. Famous last words...

$| = 1;

my $state;

sub read_one {
    my $line = readline STDIN;
    defined $line or exit;
    my ($t, $v) = split " ", $line;
    return $t, $v;
}

my ($target, $newstate) = read_one;
my $start_time = $target;

print pack "q", $start_time;

for (my $unixtime = $start_time; $unixtime < time(); $unixtime += 60) {
    if ($unixtime >= $target) {
        $state = $newstate;
        ($target, $newstate) = read_one;
    }
    length($state) == 1 or die;
    print $state;
}

