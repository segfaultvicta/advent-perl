package Advent::Year2017::Day15;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    my $gen_a = 722;
    my $gen_b = 354;
    #my $gen_a = 65;
    #my $gen_b = 8921;

    my $factor_a = 16807;
    my $factor_b = 48271;
    my $divide_by = 2147483647;

    my $count = 0;
    my $i = 0;
    my $max = 40000000;
    #my $max = 5;

    while ($i < $max) {
        $gen_a = ($gen_a * $factor_a) % $divide_by;
        $gen_b = ($gen_b * $factor_b) % $divide_by;
        $count++ if ((substr sprintf("%032b", $gen_a), -16) eq (substr sprintf("%032b", $gen_b), -16));
        $i++;
    }

    say $count;
    
}
sub b  { 
    my $count = 0;
    my $i = 0;
    #my $max = 5;
    my $max = 5000000;
    my $gen_a = build_generator_a();
    my $gen_b = build_generator_b();
    while ($i < $max) {
        my $a_val = $gen_a->();
        my $b_val = $gen_b->();
        $count++ if ((substr sprintf("%032b", $a_val), -16) eq (substr sprintf("%032b", $b_val), -16));
        $i++;
    }
    say $count;
}

sub build_generator_a {
    #my $value = 65;
    my $value = 722;
    my $factor = 16807;
    my $div = 2147483647;
    return sub {    
        while ($value % 4 != 0) {
            $value = ($value * $factor) % $div;
        }
        my $retval = $value;
        $value = ($value * $factor) % $div;
        return $retval;
    }
}

sub build_generator_b {
    #my $value = 8921;
    my $value = 354;
    my $factor = 48271;
    my $div = 2147483647;
    return sub {
        while ($value % 8 != 0) {
            $value = ($value * $factor) % $div;
        }
        my $retval = $value;
        $value = ($value * $factor) % $div;
        return $retval;
    }
}

1;