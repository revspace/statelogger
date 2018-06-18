#!/usr/bin/perl -w
use strict;
use autodie;

# Import from twitter export

my $start_time = 1263151890;

open my $fh, "grep -B 3 'triggered on' tweet.js|";

my ($Y, $d, $m, $HM);

while (defined ($_ = readline $fh)) {
    chomp;
    $Y = $1 if /created_at".*(\d\d\d\d)"/;  # year from twitter metadata

    if (/triggered on/) {
        my ($d, $m, $HM) = /triggered on (\d\d)-(\d\d) at (\d\d:\d\d)/;
        # rest of datetime from tweet contents; tweets were often significantly
        # delayed, so this is more accurate than the twitter metadata

        my $t = `date -d"$Y-$m-$d $HM:30" +%s`;
        chomp $t;

        print "$t ", ($1 eq "open" ? 1 : 0), "\n" if /now (open|closed)/
    }
}
