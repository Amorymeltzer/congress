#!/usr/bin/env perl
# huntHill.pl by Amory Meltzer
# Huntington-Hill apportionment of Congressional seats

use strict;
use warnings;
use diagnostics;

die "Usage: huntHill.pl <number_of_seats> <data>\nStopped" unless @ARGV == 2;

my %congress;		     # matrix of state data (Name => pop, seats)
my $priority = 'California'; # needs some initial value, might as well do it here
my $repTotal;		     # make global

open my $census, '<', "$ARGV[1]" or die $!;
while (<$census>) {
  chomp;
  my @data = split /[,.\t]/;
  my $name = shift @data;	# state name is the key
  $name =~ s/ /_/;		# spaces suck
  push @data, 1;		# each state gets at least one Representative
  $congress{$name} = [@data];	# population, etc are the values in the array
}
close $census;

while (calcReps() < $ARGV[0]) {
  huntHill();
  sortState();
  $congress{$priority}[1]++;
}

sortState();		      # final recalc of avg for the last apportionment
die 'incongruent' unless $repTotal == $ARGV[0];
print "State\tReps\tPop per Rep\n";
print "$_\t$congress{$_}[1]\t$congress{$_}[3]\n" foreach keys %congress;


# Calculate divisor, append to state hasharray
# D = sqrt(n(n+1))
sub huntHill
  {
    foreach my $state (keys %congress) {
      $congress{$state}[2] = sqrt($congress{$state}[1]*($congress{$state}[1]+1));
    }
    return;
  }

# Which state is next to get a representative?
sub sortState
  {
    foreach my $state (keys %congress) {
      $priority = $state if $congress{$state}[0]/$congress{$state}[2] >= $congress{$priority}[0]/$congress{$priority}[2];

      # How many people does each Rep rep?
      $congress{$state}[3] = int ($congress{$state}[0] / $congress{$state}[1]);
    }
    return;
  }

# Keep tabs on the total members of Congress
sub calcReps
  {
    $repTotal = 0;
    foreach my $state (keys %congress) {
      $repTotal += $congress{$state}[1];
    }
    return $repTotal;
  }
