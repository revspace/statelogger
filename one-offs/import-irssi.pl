#!/usr/bin/perl -w
use strict;
use autodie;
use POSIX qw(strftime);

### Import from irccloud log file, prefiltered using
### egrep "RevSpace (open|dicht)" irclog.txt | grep "bar:#revspace" | grep -v ">" > opendicht.txt

# Note: this script assumes state will remain the same until the next message,
# which might not have been the case if any relevant IRC session was
# disconnected or faulty.

# Usage: Update $start_time, then: perl import.pl < opendicht.txt > statelog

# Example line:
# .irssi/irclogs/2018/freenode/#revspace.06-13.log:09:00 -bar:#revspace- achievement unlocked by censored % RevSpace open

$| = 1;

my $start_time = 1336255470;

my $state;

sub read_one {
    my $line = readline STDIN;
    defined $line or exit;
    my ($Y, $m, $d, $H, $M) = $line =~ m[irclogs/(\d\d\d\d)/freenode/#revspace.(\d\d)-(\d\d).log:(\d\d):(\d\d)] or die "l=$line";
    my $target = "$Y-$m-$d $H:$M";
    my ($newstate) = $line =~ /.*RevSpace (open|dicht)/ or die "l2=$line";  # inefficient /.*/ because we need the *last* occurrence
    return $target, $newstate;
}

print pack "q", $start_time;

my ($target, $newstate) = read_one;

for (my $minute = $start_time; $minute < time(); $minute += 60) {
    my $now = strftime("%Y-%m-%d %H:%M", localtime $minute);

    if ($now ge $target) {
        $state = $newstate;
        ($target, $newstate) = read_one while $now ge $target;
    }
    print defined $state ? ($state eq "open" ? 1 : 0) : "?";
}

