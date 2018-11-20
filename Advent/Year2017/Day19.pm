package Advent::Year2017::Day19;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);
use Data::Dumper;

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    say "EOCZQMURF" 
}

sub b  { 
    # answer is greater than 15043
    # true path is EOCZQMURF, we know that already
    my @map;
    #my $x = 5;
    my $x = 1;
    my $y = 0;
    my $direction = 3;
    my $cursor;
    my $count = 0;

    my @route = ();

    foreach my $line (@_) {
        my @row = split "", $line;
        push @map, \@row;
    }

    while (1) {
        #sleep(1);
        $cursor = $map[$y][$x];
        $count += 1;
        #say "($x, $y): cursor is $cursor";
        if ($cursor =~ /[A-Z]/) {
            push @route, $cursor;
        }
        last if $cursor eq "F";
        last if !defined($cursor);

        if ($cursor eq "+") {
            ($x, $y, $direction) = flail($x, $y, $direction, @map);
        } else {
            if ($direction == 1) {
                # north
                $y = $y - 1;
            } elsif ($direction == 2) {
                # east
                $x = $x + 1;
            } elsif ($direction == 3) {
                # south
                $y = $y + 1;
            } else {
                # west
                $x = $x - 1;
            }
        }
    }

    say @route;
    say "$count steps taken";
}

sub flail {
    my ($x, $y, $direction, @map) = @_;
    # x and y will never, ever be zero
    if ($x == 0 || $y == 0) {
        die ("wtf???");
    }

    my $north = $map[$y-1][$x];
    my $east = $map[$y][$x+1];
    my $south = $map[$y+1][$x];
    my $west = $map[$y][$x-1];

    if ($north ne " " && $direction != 3) {
        return ($x, $y-1, 1);
    }
    if ($east ne " " && $direction != 4) {
        return ($x+1, $y, 2);
    }
    if ($south ne " " && $direction != 1) {
        return ($x, $y+1, 3);
    }
    if ($west ne " " && $direction != 2) {
        return ($x-1, $y, 4);
    }

}

1;