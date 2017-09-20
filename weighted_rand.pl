#!/usr/local/perl -w
use strict;
use warnings;
# use Data::Dumper;

#INFORMATION -------------------------------------------------------------------
# author: David Kwan
# version: 1.1

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

#OLD METHOD - SIMPLE BUT MEMORY INEFFICIENT
# my @hat = map {($_->[0]) x $_->[1]} @entries; #need brackets with repetition operator to produce a repeated list (see: https://stackoverflow.com/questions/277485/how-can-i-repeat-a-string-n-times-in-perl)
# print "Total Entries :: " . scalar(@hat) . "\n"; 
# my $winner = $hat[rand (scalar @hat)];

#NEW METHOD (using indices)
@entries = sort {$a->[1] <=> $b->[1] || $a->[0] cmp $b->[0]} @entries; #sort the entries list
my $total = 0;
foreach (@entries) {
	$_->[2] = ($total += $_->[1]); #set third element of array to current cumulative total
}
my $random_index = int(rand $total);
my $cur_index = 0;
while ($random_index > $entries[$cur_index]->[2]) {
	$cur_index++; #keep traversing through the entries until you hit the point where your random index is located.
}
my $winner = $entries[$cur_index]->[0];

print "\nTHE WINNER IS :: $winner\n";
my $pct = sprintf("%.1f", (($entries[$cur_index]->[1] / $total) * 100));
print "Percentage chance of winning :: $pct%\n";
