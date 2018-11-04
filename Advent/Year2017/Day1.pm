package Advent::Year2017::Day1;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a { 
    my $in = shift;
    my @chars = split(//, $in);
    my $first = $chars[0];
    my $total = 0;
    foreach my $i (0 .. $#chars) {
        my $char = $chars[$i];
        my $next = $i == $#chars ? $first : $chars[$i+1];
        $total += $char eq $next ? $char : 0;
    }
    say "total is $total";
}

sub b { 
    my $in = shift;
    my @chars = split(//, $in);
    my $total = 0;
    my $len = scalar(@chars) + 1;
    foreach my $i (0 .. $#chars) {
        my $char = $chars[$i];
        my $next = $chars[($i + int($len / 2)) % ($len - 1)];
        $total += $char eq $next ? $char : 0;
    }
    say "total is $total";
}

1;