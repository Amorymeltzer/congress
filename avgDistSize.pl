#!/usr/bin/env perl
# avgDistSize.pl by Amory Meltzer
# Calculate the average districv size

use strict;
use warnings;
use diagnostics;

die "Usage: avgDistSize.pl <data>\nStopped" unless @ARGV == 1;

my $sum = 0;
my $num = 0;
my $diff = 0;

open my $data, '<', "$ARGV[0]" or die $!;

while (<$data>) {
  chomp;
  my @tmp = split /\t/;
  #    print "$tmp[0]\t$tmp[1]\t";
  $sum += $tmp[0] * $tmp[1];
  $num += $tmp[0];
  #    print "$sum\n";
}
close $data or die $!;

# Total pop divided by number of districts
my $mean = int ($sum / $num);
print "Average district size: $mean ($num districts)\n";

# Open again to get variance, stdDev
open $data, '<', "$ARGV[0]" or die $!;
while (<$data>) {
  chomp;
  my @tmp = split /\t/;
  for my $i (1..$tmp[0]) {
    my $tmp = $tmp[1]-$mean;
    $diff += $tmp*$tmp;
  }
}
close $data or die $!;

# Population and Sample variances to four decimals
my $varPop = $diff/$num;
my $varSam = $diff/($num-1);

printf "Popn Std dev: %.4f\tVariance: %.4f\n", $varPop**(0.5), $varPop;
printf "Samp Std dev: %.4f\tVariance: %.4f\n", $varSam**(0.5), $varSam;
