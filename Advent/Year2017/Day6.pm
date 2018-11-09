package Advent::Year2017::Day6;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);
use List::Util qw(max);
use List::AllUtils qw(firstidx indexes);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    my @mem = split " ", shift @_;
    my @seen;
    my $steps = 0;
    while (1) {   
        my $serialised = join "", @mem;
        my $grep = grep {$_ eq $serialised} @seen;
        if(grep {$_ eq $serialised} @seen) {
            last;
        }
        push @seen, join "", @mem;
        @mem = advance(@mem);
        $steps += 1;
    }
    say "took $steps steps to infinite loop";
}

sub b  { 
    my @mem = split " ", shift @_;
    my @seen;
    my $steps = 0;
    my @indices;
    while (1) {   
        my $serialised = join "", @mem;
        my @grep = indexes {$_ eq $serialised} @seen;
        if(scalar @grep > 1) {
            @indices = @grep;
            last;
        }
        push @seen, join "", @mem;
        @mem = advance(@mem);
        $steps += 1;
    }
    my $difference = $indices[1] - $indices[0];
    say "took $steps steps to infinite loop, $difference steps to cycle";
}

sub advance {
    my @mem = @_;
    my $len = scalar @mem;
    my $maxmem = max @mem;
    my $max_idx = firstidx { $_ == $maxmem } @mem;
    my $held = $mem[$max_idx];
    $mem[$max_idx] = 0;
    my $next_idx = $max_idx + 1 < $len ? $max_idx + 1 : 0;
    while ($held) {
        $mem[$next_idx] += 1;
        $held -= 1;
        $next_idx = $next_idx + 1 < $len ? $next_idx + 1 : 0;
    }
    return @mem;
}

1;