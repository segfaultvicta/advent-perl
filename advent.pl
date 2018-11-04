#!/usr/bin/env perl

use 5.28.0;
use warnings;
use Getopt::Long;
use Acme::Tools;
use Cwd 'abs_path';
use File::Basename;
use lib dirname( abs_path $0 );
use strict;
no strict 'refs';

# Usage: perl advent.pl --day <day> --side <side> [--in <input>]
#   if in is not given, it'll automatically try to grab the file named "<day><side>.in"

my $year = '2017';
my $day = '';
my $side = '';
my $in = '';
my @in;
GetOptions('year=s' => \$year, 'day=s' => \$day, 'side=s' => \$side, 'in=s' => \$in);

die("--day unprovided, or not a number between 1 and 25\n") unless $day =~ /^[0-9]+$/ && between(int($day), 1, 25);
die("--year isn't a valid year\n") unless $year =~ /^[0-9]+$/ && int($year) >= 2015;
die("--side unprovided, or not 'a' or 'b'\n") unless $side =~ /^[ab]$/;
if ($in) {
    @in = split(/;/, $in);
} else {
    my $infile = "input/$year/$day";
    @in = readfile($infile);
}

my $mod = "Advent::Year$year" . "::" . "Day$day";
my $sub = $mod . "::" . "$side";
eval "require $mod" or die@!;
$sub->(@in);