package Advent::Year2017::Day13;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  {
    my @limits;
    my @current;
    my @reverse;
    my $visiting = 0;
    my $severity = 0;

    foreach my $line (@_) {
        my ($i, $limit) = ($line =~ /(\d+): (\d+)/);
        $limits[$i] = $limit;
    }
    foreach my $i (0..$#limits) {
        $current[$i] = 0;
        $limits[$i] = "X" if !defined $limits[$i];
        $reverse[$i] = 0;
    }

    for (my $visiting = 0; $visiting <= $#limits; $visiting++) {
        say "\n\nVISITING $visiting";
        for (my $i = 0; $i <= $#limits; $i++) {
            print "$i: ";
            if ($limits[$i] eq "X") {
                if ($visiting == $i ) { print "(.)"; }
                else { print "..."; }
            } else {
                for (my $j = 0; $j < $limits[$i]; $j++) {
                    if ($current[$i] == $j) {
                        if ($visiting == $i && $j == 0 ) { 
                            print "(S) ";
                            # BUT ALSO, THIS IS THE KEY LOGIC BIT,
                            # Depth is $visiting, range is $limits[$i]
                            $severity += $visiting * $limits[$i];
                        }
                        else { print "[S] "; }
                    } else {
                        if ($visiting == $i && $j == 0 ) { print "( ) "; }
                        else { print "[ ] "; }
                    }
                }
            }
            print "\n";
        }
        for (my $i = 0; $i <= $#limits; $i++) {
            next if $limits[$i] eq "X";
            if ($reverse[$i]) {
                my $n = $current[$i] - 1;
                $current[$i] = $n == -1 ? 1 : $n;
                $reverse[$i] = $n == -1 ? 0 : 1;
            } else {
                my $n = $current[$i] + 1;
                $current[$i] = $n == $limits[$i] ? $current[$i] - 1 : $n;
                $reverse[$i] = $n == $limits[$i] ? 1 : 0;
            }
        }
    }

    say "severity $severity";
}

sub b  { 
    my @limits;
    my $delay = -1;

    foreach my $line (@_) {
        my ($i, $limit) = ($line =~ /(\d+): (\d+)/);
        $limits[$i] = $limit;
    }
    foreach my $i (0..$#limits) {
        $limits[$i] = "X" if !defined $limits[$i];
    }

    OUTER: while (1) {
        $delay++;
        for (my $layer = 0; $layer <= $#limits; $layer++) {
            my $timestep = $layer + $delay;
            my $range = $limits[$layer];

            next if $range eq "X";            
            next OUTER if ($timestep % (2*($range -1)) == 0); # SUCK IT
        }
        last;
    }
    say "done @ $delay";
}

1;