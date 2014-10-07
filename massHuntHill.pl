#!/usr/bin/env perl
# huntHill.pl by Amory Meltzer
# Huntington-Hill apportionment en masse

use strict;
use warnings;
use diagnostics;

die "Usage: massHuntHill.pl <min> <max> <data>\nStopped" unless @ARGV == 3;

my %congress; # matrix of state data (Name => pop, seats)
## key = state
## 0 - population, 1 - representatives, 2 - divisor, 3 - average
my $priority = "California"; # needs some initial value, might as well do it here
my @states; # All state names
my $repTotal; # make global

open (my $census, "<$ARGV[2]") or die $!;
while (<$census>)
{
    chomp;
    my @data = split /[,.\t]/, $_;
    my $name = shift @data; # state name is the key
    $name =~ s/ /_/; # spaces suck
    push @states, $name;
    push @data, 1; # each state gets at least one Representative
    $congress{$name} = [@data]; # population, etc are the values in the array
}
close ($census);

@states = sort @states; # alpha order to match %congress
print "EC"; # Header row
print "\t$states[$_]" for 0..(scalar @states - 1); # print all the states
print "\n";
#print "\tAvg\n";

for my $i ($ARGV[0]..$ARGV[1])
{
    while (calcReps() < $i)
    {
	huntHill();
	sortState();
	$congress{$priority}[1]++;
    }
    
    sortState(); # final recalc of avg for the last apportionment
    die "incongruent" unless $repTotal == $i;
#    print "State\tReps\tPop per Rep\n";
    print "$i"; # EC total
    print "\t$congress{$_}[1]" foreach (sort keys %congress); # reps for each state
    print "\n";
#    print "\tempty\n";
#    print "\t$congress{$i}[3]\n"; # average
}


# Calculate divisor, append to state hasharray
# D = sqrt(n(n+1))
sub huntHill
{
    foreach my $state (keys %congress)
    {
	$congress{$state}[2] = sqrt($congress{$state}[1]*($congress{$state}[1]+1));
    }
}

# Which state is next to get a representative?
sub sortState
{
    foreach my $state (keys %congress)
    {
	$priority = $state if $congress{$state}[0]/$congress{$state}[2] >= $congress{$priority}[0]/$congress{$priority}[2];

	# How many people does each Rep rep?
	$congress{$state}[3] = int ($congress{$state}[0] / $congress{$state}[1]);
    }
}
    
# Keep tabs on the total members of Congress
sub calcReps
{
    $repTotal = 0;
    foreach my $state (keys %congress)
    {
	$repTotal += $congress{$state}[1];
    }
    return $repTotal;
}
