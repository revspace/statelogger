#!/usr/bin/perl -w
use strict;
use autodie;
use POSIX qw(strftime);

### Import from irccloud log file, prefiltered using
### egrep "RevSpace (open|dicht)" irclog.txt | grep -v "RevSpace dicht % RevSpace open" | grep -v "RevSpace open % RevSpace dicht" | grep "] \*" > opendicht.txt

# Note: this script assumes state will remain the same until the next message,
# which might not have been the case if any relevant IRC session was
# disconnected or faulty.

# Usage: Update $start_time, then: perl import.pl < opendicht.txt > statelog

$| = 1;

my $start_time = 1445252250;

my $state;
my $line = readline STDIN;

print pack "q", $start_time;

for (my $minute = 1445252250; $minute < time(); $minute += 60) {
    my ($target) = $line =~ /^\[(\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d)\]/ or die "l=$line";
    my ($newstate) = $line =~ /RevSpace (open|dicht)/ or die "l2=$line";
    my $now = strftime("%Y-%m-%d %H:%M:%S", localtime $minute);

    if ($now gt $target) {
        $line = readline STDIN;
        defined $line or exit;
        $state = $newstate;
    }
    print defined $state ? ($state eq "open" ? 1 : 0) : "?";
}

