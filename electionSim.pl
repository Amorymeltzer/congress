#!/usr/bin/env perl
# electionSim.pl by Amory Meltzer
# Simulate past elections under new house models

use strict;
use warnings;
use diagnostics;

die "Usage: electionSim.pl <voting_data.tsv> <massHuntHill_output.tsv>\nStopped" unless @ARGV == 2;

my @years;			# array of years
my @states;			# array of states
my @electors;			# array of elector totals
# Hash of hash holding number of reps per each state per each congressional size
# House size, state
my %stateReps;
# Hash of array holding specific state data for each year
# Year, state
my %stateYears;


# Build elector table
open my $congress, '<', "$ARGV[1]" or die $!;

while (<$congress>) {
  chomp;
  if (/^EC/)			# build up list of states, to be used later
    {
      @states = split /\t/;
      shift @states;
      next;			# the rest pertains to actual data
    }
  my @tmp = split /\t/;
  my $house = shift @tmp;
  push @electors, $house;

  # Actual election, so include senators
  $stateReps{$house}{$states[$_]} = $tmp[$_]+2 for 0..(scalar @states - 1);
}
close $congress;

# Build yearly results table
open my $results, '<', "$ARGV[0]" or die $!;

while (<$results>) {
  next if /^Year/;
  chomp;
  my @tmp = split /\t/;
  my $now = shift @tmp;
  push @years, $now;

  $stateYears{$now}{$states[$_]} = $tmp[$_] for 0..(scalar @states - 1);
}
close $results;

# Produce results
# Header
print 'House';
print "\t$years[$_]" for 0..(scalar @years - 1);
print "\n";

# Election results
foreach my $elector (@electors) {
  print "$elector";
  foreach my $year (@years) {
    my $dTot = 0;
    foreach my $state (@states) {
      $dTot += $stateReps{$elector}{$state} if $stateYears{$year}{$state} eq 'D';
    }
    print "\t$dTot";
  }
  print "\n";
}
