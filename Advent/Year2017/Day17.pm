package Advent::Year2017::Day17;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);
use Advent::Functions qw(highlight_int_element);
use List::Slice qw(head);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    my $in = int(shift @_);
    my @buffer = (0);
    my $position = 0;
    my $limit = 2017;
    for (my $i = 1; $i <= $limit; $i++) {
        my $plusoffset = $position + $in;
        my $length = scalar @buffer;
        my $mod = $plusoffset % $length;
        my $new_position = $mod + 1;
        splice @buffer, $new_position, 0, $i;
        $position = $new_position;
    }
    say highlight_int_element 2017, @buffer;
}

sub b  { 
    my $in = int(shift @_);
    my @buffer = (0);
    my $position = 0;
    my $limit = 50000000;
    #my $last = 0;
    my $length = 1;
    for (my $i = 1; $i <= $limit; $i++) {
        if ($position == 1) {
            my $report = $i - 1;
            say "buffer[i] changed to $report";
        }
        my $plusoffset = $position + $in;
        
        #my $length = scalar @buffer;
        
        my $mod = $plusoffset % $length;
        my $new_position = $mod + 1;
        #splice @buffer, $new_position, 0, $i;
        $length += 1;
        $position = $new_position;
        #say "$i: PO $plusoffset with buffer length $length, heading to $new_position next";
        #if ($buffer[1] != $last) {
        #    $last = $buffer[1];
        #    say "$i: buffer[1] changed to $last";
        #}
    }
    #say $buffer[1];
}

1;