package Advent::Year2017::Day14;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);
use Advent::Functions qw(knot);
use List::Util qw(reduce);
use Data::Dumper;

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    my $in = "nbysizxe";
    #my $in = "flqrgnkx";
    my @rows;

    foreach my $i (0..127) {
        my $to_hash = $in . "-$i";
        my $dense = join "", knot($to_hash);
        my $binary;
        foreach my $char (split "", $dense) {
            my $digit = hex $char;
            $binary .= sprintf("%04b", $digit);
        }
        $rows[$i] = $binary;
    }

    my $sum = 0;
    foreach my $row (@rows) {
        $sum += reduce { $a + $b } split "", $row;
    }
    say $sum;
}
sub b  { 
    my $in = "nbysizxe";
    #my $in = "flqrgnkx";
    my @rows;
    my $groupcount = 1;

    foreach my $i (0..127) {
        my $to_hash = $in . "-$i";
        my $dense = join "", knot($to_hash);
        my $binary;
        foreach my $char (split "", $dense) {
            my $digit = hex $char;
            $binary .= sprintf("%04b", $digit);
        }
        $binary =~ s/0/ /g;
        $binary =~ s/1/0/g;
        my @row = split "", $binary;
        $rows[$i] = \@row;
    }

    for (my $i = 0; $i <= $#rows; $i++) {
        for (my $j = 0; $j <= $#rows; $j++) {
            my $cursor = $rows[$i][$j];
            next unless $cursor eq "0";

            $rows[$i][$j] = $groupcount;
            $groupcount++;

            flood_fill_from($i, $j, \@rows);
        }
    }

    foreach my $i (0..7) {
        foreach my $j (0..7) {
            if ($rows[$i][$j] eq " ") { print "     "; }
            else {
                printf("%5s",$rows[$i][$j]);
            }
        }
        print "\n";
    }
    $groupcount--;
    say "group count $groupcount";

}

sub flood_fill_from {
    my ($i, $j, $ref) = @_;
    my $contents = $ref->[$i][$j];
    my @neighbors;
    
    push @neighbors, ([$i-1, $j, $ref->[$i-1][$j]]);
    push @neighbors, ([$i+1, $j, $ref->[$i+1][$j]]);
    push @neighbors, ([$i, $j+1, $ref->[$i][$j+1]]);
    push @neighbors, ([$i, $j-1, $ref->[$i][$j-1]]);

    @neighbors = grep { @$_[0] >= 0 && @$_[1] >= 0 && defined @$_[2] && @$_[2] eq "0"; } @neighbors;

    if ($contents == 1) {
        say "in floodfill contents == 1 at $i, $j";
    }

    foreach my $neighbor (@neighbors) {
        my @n = @$neighbor;
        $ref->[$n[0]][$n[1]] = $contents;
        flood_fill_from($n[0], $n[1], $ref);
    }
}


1;