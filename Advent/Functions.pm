package Advent::Functions;

use 5.28.0;
use warnings;
use strict;
use Exporter;
use List::Util qw(reduce);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(h t knot highlight_idx highlight_string_element highlight_int_element);
our %EXPORT_TAGS = ( DEFAULT => [qw(h t knot highlight_idx highlight_string_element highlight_int_element)] );

sub h { $_[0]; }
sub t { shift; @_ };

sub highlight_string_element {
    my $element = shift;
    my @array = @_;
    my $acc = "";
    for(my $i = 0; $i <= $#array; $i++) {
        if ($array[$i] eq $element) {
            $acc .= "($array[$i]) ";
        } else {
            $acc .= "$array[$i] ";
        }
    }
    return $acc;
}

sub highlight_int_element {
    my $element = shift;
    my @array = @_;
    my $acc = "";
    for(my $i = 0; $i <= $#array; $i++) {
        if ($array[$i] == $element) {
            $acc .= "($array[$i]) ";
        } else {
            $acc .= "$array[$i] ";
        }
    }
    return $acc;
}

sub highlight_idx {
    my $position = shift;
    my @array = @_;
    my $acc = "";
    for(my $i = 0; $i <= $#array; $i++) {
        if ($i == $position) {
            $acc .= "($array[$i]) ";
        } else {
            $acc .= "$array[$i] ";
        }
    }
    return $acc;
}

sub knot {
    my @bytes;
    my @in = split "", shift;
    foreach my $char (@in) {
        push @bytes, ord($char);
    }
    push @bytes, (17, 31, 73, 47, 23);

    my @hash = (0..255);
    my $skip = 0;
    my $position = 0;

    for (my $round = 0; $round < 64; $round++) {
        foreach my $byte (@bytes) {
            my $term = ($position + $byte - 1) % @hash;
            my $curr = $position;

            for(my $i = 0; $i < ($byte / 2); $i++) {
                my $temp = $hash[$curr];
                $hash[$curr] = $hash[$term];
                $hash[$term] = $temp;
                $term -= 1;
                $curr += 1;
                $term = $term < 0 ? $#hash : $term;
                $curr = $curr > $#hash ? 0 : $curr;
            }
            $position = ($position + $byte + $skip++) % (scalar @hash);
        }
    }
    
    my @dense;
    foreach my $block (0..15) {
        my @chunk = splice @hash, 0, 16;
        my $hex = sprintf("%02x", reduce { $a ^ $b } @chunk);
        push @dense, $hex;
    }
    return @dense;
}

1;