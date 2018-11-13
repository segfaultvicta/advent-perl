package Advent::Year2017::Day11;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);
use List::Util qw(max);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    my @directions = split ",", shift;
    my $curr_x = 0;
    my $curr_y = 0;
    my $curr_z = 0;

    my $distance = 0;

    say "position at start: $curr_x, $curr_y, $curr_z";

    foreach my $d (@directions) {
        $curr_x += d_x($d);
        $curr_y += d_y($d);
        $curr_z += d_z($d);
        $distance = max(abs($curr_x), abs($curr_y), abs($curr_z));
        say "position after move in $d: $curr_x, $curr_y, $curr_z, distance from 0 $distance";
    }

    say "position at end: $curr_x, $curr_y, $curr_z";
}

sub b  { 
    my @directions = split ",", shift;
    my $curr_x = 0;
    my $curr_y = 0;
    my $curr_z = 0;

    my $distance = 0;
    my $max_distance = 0;

    say "position at start: $curr_x, $curr_y, $curr_z";

    foreach my $d (@directions) {
        $curr_x += d_x($d);
        $curr_y += d_y($d);
        $curr_z += d_z($d);
        $distance = max(abs($curr_x), abs($curr_y), abs($curr_z));
        $max_distance = max($distance, $max_distance);
        say "position after move in $d: $curr_x, $curr_y, $curr_z, distance from 0 $distance";
    }

    say "position at end: $curr_x, $curr_y, $curr_z";
    say "max distance from 0: $max_distance";
}

sub d_x {
    my $dir = shift;
    return ($dir eq "ne" || $dir eq "n") ?  1 :
           ($dir eq "sw" || $dir eq "s") ? -1 :
           0;
}

sub d_y {
    my $dir = shift;
    return ($dir eq "ne" || $dir eq "se") ?  1 :
           ($dir eq "nw" || $dir eq "sw") ? -1 :
           0;
}

sub d_z {
    my $dir = shift;
    return ($dir eq "se" || $dir eq "s") ?  1 :
           ($dir eq "nw" || $dir eq "n") ? -1 :
           0;
}

1;