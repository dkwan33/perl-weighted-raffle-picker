#!/usr/local/perl -w
use strict;
use warnings;

#INFORMATION -------------------------------------------------------------------
# author: David Kwan
# version: 1.0

#DESCRIPTION  ------------------------------------------------------------------
#This is just a weighted random picker, specifically designed to pick a raffle
#winner from a bunch of raffle ticket entries.

#INPUT -------------------------------------------------------------------------
#Use a .tsv where each line is an entrant tab-seperated by the number of entries they have

#PROGRAM START -----------------------------------------------------------------
my $start = time;
local $|=1; #Standard Output Buffer
use constant DS=>"\\";

my $infile=shift(@ARGV);
if (! $infile) {
    print "usage: ".$0." <INPUT FILE>\n";
    exit(1);
}

open (IN, $infile) or die $!;
my @allFile=<IN>;
close (IN);

my @entries;
for (my $i = 0; $i < @allFile; $i++) {
    if ($allFile[$i] =~ /^(.+?)\t(\d+)$/){
    	push @entries, [$1, $2];
    	print "recognized entry: $1 --- entries: $2\n"
    } else {
    	print "error :: a1 at line :: $_";
    	exit(1);
    }
}

my @hat = map {($_->[0]) x $_->[1]} @entries; #pick a number out of the "hat"
print "Total Entries :: " . scalar(@hat) . "\n"; 

my $winner = $hat[rand (scalar @hat)];

print "THE WINNER IS :: $winner\n";

