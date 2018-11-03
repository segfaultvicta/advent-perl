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
    # if I get rid of ALL of this and replace it with say "bluh"; it works ?_?
    my $in = shift;
    my @chars = split(//, $in);
    my $first = $chars[0];
    my $total = 0;
    say "first character is $first, input length is $len";
    foreach my $i (0 .. $#chars) {
        my $char = $chars[$i];
        my $next = $i == $#chars ? $first : $chars[$i+1];
        $total = $char eq $next ? $char : 0;
    }
    say "total is $total";
}

sub b { 
    say "blah";
}

1;