package Advent::Year2017::Day5;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    my @instructions = @_;
    my $i = 0;
    my $steps = 0;
    while ($i < scalar @instructions) {
        my $curr = $instructions[$i];
        $instructions[$i] += 1;
        $i += $curr;
        $steps += 1;
    }
    say "$steps steps taken to escape the maze"
}
sub b  { 
    my @instructions = @_;
    my $i = 0;
    my $steps = 0;
    while ($i < scalar @instructions) {
        my $curr = $instructions[$i];
        $instructions[$i] += $curr >= 3 ? -1 : 1;
        $i += $curr;
        $steps += 1;
    }
    say "$steps steps taken to escape the maze" 
}

1;