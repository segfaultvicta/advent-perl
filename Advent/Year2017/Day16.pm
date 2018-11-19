package Advent::Year2017::Day16;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);
use List::MoreUtils qw(firstidx);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    my @dance = split "", "abcdefghijklmnop";
    #my @dance = split "", "abcde";
    foreach my $move (split ",", $_[0]) {
        $move =~ /(?<type>\w)(?<first>\w+)(\/(?<second>\w+))?/;
        if ($+{type} eq "s") {
            # spin
            @dance = spin($+{first}, @dance);
        } elsif ($+{type} eq "x") {
            # exchange
            @dance = exchange($+{first}, $+{second}, @dance);
        } else {
            # partner
            my $programa = $+{first};
            my $programb = $+{second};
            my $indexa = firstidx { $_ eq $programa } @dance;
            my $indexb = firstidx { $_ eq $programb } @dance;
            @dance = exchange($indexa, $indexb, @dance);
        }
    }

    say @dance;
}

sub b  { 
    my @dance = split "", "abcdefghijklmnop";
    my $seen = {};
    my $latch = 1;
    my $billion = 1000000000;
    for (my $i = 0; $i < $billion; $i++) {
        say $i;
        foreach my $move (split ",", $_[0]) {
            $move =~ /(?<type>\w)(?<first>\w+)(\/(?<second>\w+))?/;
            if ($+{type} eq "s") {
                # spin
                @dance = spin($+{first}, @dance);
            } elsif ($+{type} eq "x") {
                # exchange
                @dance = exchange($+{first}, $+{second}, @dance);
            } else {
                # partner
                my $programa = $+{first};
                my $programb = $+{second};
                my $indexa = firstidx { $_ eq $programa } @dance;
                my $indexb = firstidx { $_ eq $programb } @dance;
                @dance = exchange($indexa, $indexb, @dance);
            }
        }

        if ($latch) {
            my $state = join "", @dance;
            if (defined $seen->{$state}) {
                my $seenidx = $seen->{$state};
                my $diff = $i - $seenidx;
                my $skip_remainder = ($billion - $i) % $diff;
                $i = $billion - $skip_remainder;
                $latch = 0;
                next;
            } else {
                $seen->{$state} = $i;
            }
        }
    }
    print "\n";
    say @dance; 
}

sub spin {
    my $by = shift;
    my @dance = @_;

    widdershins(\@dance, $by);

    return @dance;
}

sub sunwise {
    my ($listref, $n) = @_;
    for (1 .. $n) {
        push(@$listref, shift @$listref);
    }
}

sub widdershins {
    my ($listref, $n) = @_;
    for (1 .. $n) {
        unshift(@$listref, pop @$listref);
    }
}

sub exchange {
    my $first = shift;
    my $second = shift;
    my @dance = @_;

    my $tmp = $dance[$first];
    $dance[$first] = $dance[$second];
    $dance[$second] = $tmp;

    return @dance;
}

1;