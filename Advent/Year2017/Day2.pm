package Advent::Year2017::Day2;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);
use Advent::Functions qw(h t);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    my $sum = 0;
    foreach my $line (@_) {
        my @row = split(" ", $line);
        my @sort = sort { $a <=> $b } @row;
        $sum += $sort[-1] - $sort[0];
    }
    say "sum is $sum";
}
sub b  { 
    my $sum = 0;
    foreach my $line (@_) {
        my @row = split(" ", $line);
        my $diff = 0;
        $sum += divisibles(h(@row), t(@row));
    }
    say "sum is $sum";
}

sub divisibles {
    my ($head, @tail) = @_;
    return 0 if not @tail;
    foreach (@tail) {
        return $head / $_ if $head % $_ == 0;
        return $_ / $head if $_ % $head == 0;
    }
    return divisibles(h(@tail), t(@tail));
}

1;