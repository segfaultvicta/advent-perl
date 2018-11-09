package Advent::Year2017::Day9;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    my @stream = split "", shift;
    my $negate = 0;
    my $garbage_mode = 0;
    my $nesting = 0;
    my $score = 0;
    foreach my $char (@stream) {
        if ($negate) {
            $negate = 0;
            next;
        }
        if ($char eq "!") {
            $negate = 1;
            next;
        }
        if ($char eq ">") {
            $garbage_mode = 0;
            next;
        }
        if ($char eq "<" && !$garbage_mode) {
            $garbage_mode = 1;
            next;
        }
        if ($garbage_mode) {
            next;
        }

        # At this point, the garbage has been removed and we just care about counting groups. UGH
        if ($char eq "{") {
            $nesting += 1;
        }
        if ($char eq "}") {
            $score += $nesting;
            $nesting -= 1;
        }
    }
    say "score is $score";
}
sub b  { 
    my @stream = split "", shift;
    my $negate = 0;
    my $garbage_mode = 0;
    my $garbages = 0;
    my $nesting = 0;
    my $score = 0;
    foreach my $char (@stream) {
        if ($negate) {
            $negate = 0;
            next;
        }
        if ($char eq "!") {
            $negate = 1;
            next;
        }
        if ($char eq ">") {
            $garbage_mode = 0;
            next;
        }
        if ($char eq "<" && !$garbage_mode) {
            $garbage_mode = 1;
            next;
        }
        if ($garbage_mode) {
            $garbages += 1;
            next;
        }

        # At this point, the garbage has been removed and we just care about counting groups. UGH
        if ($char eq "{") {
            $nesting += 1;
        }
        if ($char eq "}") {
            $score += $nesting;
            $nesting -= 1;
        }
    }
    say "score is $score, $garbages garbage characters removed";
}

1;