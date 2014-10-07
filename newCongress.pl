#!/usr/bin/env perl
# newCongress.pl by Amory Meltzer
# Predict election changes given census data for a certain range of house sizes

use strict;
use warnings;
use diagnostics;

die "Usage: newCongress.pl <min size> <max size> <voting_data.tsv> <all_census.tsv>\nStopped" unless @ARGV == 4;

my $min = shift @ARGV; # minimum house size
my $max = shift @ARGV; # maximum house size
#print "min: $min\tmax: $max\n";
my $priority = "Delaware"; # needs some initial value, might as well do it here
my $repTotal; # make global
my @years; # array of years
my @states; # array of states
my @electors; # array of elector totals
# Hash of hash holding number of reps per each state per each congressional size
# House size, state
my %stateReps;
# Hash of array holding specific state results for each year
# Year, state
my %stateYears;
# Matrix of state data (State => pop, seats)
# 0 - population, 1 - representatives, 2 - divisor, 3 - average seat size
my %congress;


# Build yearly results table
open (my $votingHist, "<$ARGV[0]") or die $!;

while (<$votingHist>)
{
    chomp;
    if (/^Year/) # build up list of states, to be used later
    {
	@states = split /\t/;
	shift @states;
	next; # the rest pertains to actual data
    }

    my @tmp = split /\t/;
    my $now = shift @tmp;
    push @years, $now;

    # - if the state didn't partake
    $stateYears{$now}{$states[$_]} = $tmp[$_] for 0..(scalar @states - 1);
}
close ($votingHist);

@states = sort @states; # should be alpha order, but just in case


# Build table of yearly census data
open (my $census, "<$ARGV[1]") or die $!;
while (<$census>)
{
    next if /^EC/;
    chomp;
    my @tmp = split /[,.\t]/;
    my $now = shift @tmp;

    $congress{$now}{$states[$_]} = [$tmp[$_],] for 0..(scalar @states - 1);
}
close ($census);

foreach my $year (@years)
{
    for my $i ($min..$max)
    {
	while (calcReps($year) < $i)
	{
	    huntHill($year);
	    sortState($year);
	    $congress{$year}{$priority}[1]++;
	}

	sortState($year); # final recalc of avg for the last apportionment
	die "incongruent" unless $repTotal == $i;
#    print "State\tReps\tPop per Rep\n";
#	print "$i"; # EC total
#	print "\t$congress{$_}[1]" foreach (sort keys %congress); # reps for each state
#	print "\n";
#    print "\tempty\n";
#    print "\t$congress{$i}[3]\n"; # average
    }
}



############################################################################################################
# Actual election, so include senators
#$stateReps{$house}{$states[$_]} = $tmp[$_]+2 for 0..(scalar @states - 1);


# Produce results
# Header
print "House";
print "\t$years[$_]" for 0..(scalar @years - 1);
print "\n";
my $one = "500";
my $two = "California";
print "$stateReps{$one}{$two}\n";
# Election results
foreach my $elector (@electors)
{
    print "$elector";
    foreach my $year (@years)
    {
	my $dTot = 0;
	foreach my $state (@states)
	{
	    print "$stateReps{$elector}{$state}\t$stateYears{$year}{$state}\n";
	    $dTot += $stateReps{$elector}{$state} if $stateYears{$year}{$state} eq "D";
	}
	print "\t$dTot";
    }
    print "\n";
}
############################################################################################################




# Calculate divisor, append to state hasharray
# D = sqrt(n(n+1))
sub huntHill
{
    my $now = shift @_;
    foreach my $state (@states)
    {
	next unless ($congress{$now}{$state}[1]);
	$congress{$now}{$state}[2] = sqrt($congress{$now}{$state}[1]*($congress{$now}{$state}[1]+1));
    }
}

# Which state is next to get a representative?
sub sortState
{
    my $now = shift @_;
    foreach my $state (@states)
    {
	next unless ($congress{$now}{$state}[1]);
#	next unless ($congress{$now}{$state}[2]);
	$priority = $state if $congress{$now}{$state}[0]/$congress{$now}{$state}[2] >= $congress{$now}{$priority}[0]/$congress{$now}{$priority}[2];

	# How many people does each Rep rep?
	$congress{$now}{$state}[3] = int ($congress{$now}{$state}[0] / $congress{$now}{$state}[1]);
    }
}
    
# Keep tabs on the total members of Congress
sub calcReps
{
    my $now = shift @_;
    $repTotal = 0;
    foreach my $state (@states)
    {
	next unless ($congress{$now}{$state}[1]);
	$repTotal += $congress{$now}{$state}[1];
    }
    return $repTotal;
}
