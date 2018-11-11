package Advent::Year2017::Day10;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);
use Data::Dumper;
use List::Util qw(reduce);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    my @lengths = split ",", shift;
    my $skip = 0;
    my $moved_forward = 0;
    my $diff = 0;
    my $len = 256;
    my @list = (0..($len-1));
    foreach my $length (@lengths) {
        push @list, @list;
        splice @list, 0, $len, reverse splice @list, 0, $length;
        push @list, @list;
        push @list, @list;
        push @list, @list;
        push @list, @list;
        $moved_forward += ($length + $skip);
        @list = splice @list, ($length + $skip), $len;
        $skip += 1;
    }
    
    $diff = $len - ($moved_forward % $len); 
    #say "moved forward by $moved_forward in total and need to move $diff times to compensate";
    push @list, @list;
    push @list, @list;
    push @list, @list;
    push @list, @list;
    @list = splice @list, $diff, $len;

    say "@list";
}
sub b  { 
    my @bytes;
    my @in = split "", shift;
    foreach my $char (@in) {
        push @bytes, ord($char);
    }
    push @bytes, (17, 31, 73, 47, 23);

    my @hash = (0..255);
    my $skip = 0;
    my $position = 0;

    # fuck all of this and start over

    for (my $round = 0; $round < 64; $round++) {
        #say "round $round, hash is @hash";
        foreach my $byte (@bytes) {
            #say "processing byte $byte";
            my $term = ($position + $byte - 1) % @hash;
            my $curr = $position;

            #say "swapping between $curr and $term";

            for(my $i = 0; $i < ($byte / 2); $i++) {
                # swap
                my $temp = $hash[$curr];
                $hash[$curr] = $hash[$term];
                $hash[$term] = $temp;
                $term -= 1;
                $curr += 1;
                $term = $term < 0 ? $#hash : $term;
                $curr = $curr > $#hash ? 0 : $curr;
            }
            $position = ($position + $byte + $skip++) % (scalar @hash);
            #say "hash now looks like @hash and current position is $position";
        }
    }
    
    my @dense;
    foreach my $block (0..15) {
        my @chunk = splice @hash, 0, 16;
        my $hex = sprintf("%02x", reduce { $a ^ $b } @chunk);
        push @dense, $hex;
    }
    say @dense;
}

1;