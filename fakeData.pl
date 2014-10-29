#!/usr/bin/env perl
# fakeData.pl by Amory Meltzer
# Create a fake data table of election results

use strict;
use warnings;
use diagnostics;

die "Usage: fakeData.pl <census_data>\nStopped" unless @ARGV == 1;

my @years;			# election years
my @states;			# states
# Create an array from election years
#for (my $i = 1860; $i <= 2012; $i += 4)
for (my $i = 1920; $i <= 2012; $i += 4) {
  push @years, $i;
}

# Gotta get the state names from somewhere
open my $data, '<', "$ARGV[0]" or die $!;
while (<$data>) {
  chomp;
  my @tmp = split /,/;
  push @states, $tmp[0];
}
close $data;

# Build the fake table
print 'Year';
print "\t$states[$_]" for 0..(scalar @states - 1); # print all the states
print "\n";

foreach my $year (0..(scalar @years - 1)) {
  print "$years[$year]";
  foreach my $state (0..(scalar @states - 1)) {
    my $coin = int rand 2;
    if ($coin == 0) {
      print "\tD";
    } else {
      print "\tR";
    }
  }
  print "\n";
}
