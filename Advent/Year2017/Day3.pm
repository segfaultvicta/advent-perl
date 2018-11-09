package Advent::Year2017::Day3;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);
use Data::Dumper;

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    my $in = shift;
    my %graph;
    my $x = 0;
    my $y = 0;
    my @heading = (1, 0);
    my $current_max_steps_before_turn = 1;
    my $steps_before_turn = 1;
    my $turns_remaining = 2;
    for my $i (1 .. $in) {
        $graph{$i} = [($x, $y)];
        $x += $heading[0];
        $y += $heading[1];
        $steps_before_turn -= 1;
        if ($steps_before_turn == 0) {
            @heading = widdershins($heading[0], $heading[1]);
            $turns_remaining -= 1;
            $steps_before_turn = $current_max_steps_before_turn;
            if ($turns_remaining == 0) {
                $turns_remaining = 2;
                $current_max_steps_before_turn += 1;
                $steps_before_turn = $current_max_steps_before_turn;
            }
        }
    }
    
    #foreach my $i (sort {$a <=> $b } keys(%graph)) {
    #    say "[$i]: @{ $graph{$i}}";
    #}
    say abs(@{$graph{$in}}[0]) + abs(@{$graph{$in}}[1]);
}
sub b  { 
    my $in = shift;
    my %graph;
    my $x = 0;
    my $y = 0;
    my @heading = (1, 0);
    my $current_max_steps_before_turn = 1;
    my $steps_before_turn = 1;
    my $turns_remaining = 2;
    for my $i (1 .. 64) {
        $graph{$i} = [($x, $y)];
        $x += $heading[0];
        $y += $heading[1];
        $steps_before_turn -= 1;
        if ($steps_before_turn == 0) {
            @heading = widdershins($heading[0], $heading[1]);
            $turns_remaining -= 1;
            $steps_before_turn = $current_max_steps_before_turn;
            if ($turns_remaining == 0) {
                $turns_remaining = 2;
                $current_max_steps_before_turn += 1;
                $steps_before_turn = $current_max_steps_before_turn;
            }
        }
    }

    my %copy;
    foreach my $i (sort {$a <=> $b} keys(%graph)) {
        my $lookup = "@{$graph{$i}}[0],@{$graph{$i}}[1]";
        $copy{$lookup} = [($i, 0)];
    }
    
    foreach my $lookup (sort { @{$copy{$a}}[0] <=> @{$copy{$b}}[0] } keys(%copy)) {
        my ($x, $y) = split ",", $lookup;
        my $val = @{$copy{$lookup}}[0] == 1 ? 1 : sum_neighbors(int($x), int($y), %copy);
        @{$copy{$lookup}}[2] = $val;
        say "$lookup: @{ $copy{$lookup}} value: $val";
    }
}

sub widdershins {
    return
        $_[0] ==  1 && $_[1] ==  0 ? (0,1) :
        $_[0] ==  0 && $_[1] ==  1 ? (-1,0) :
        $_[0] == -1 && $_[1] ==  0 ? (0, -1) :
        $_[0] ==  0 && $_[1] == -1 ? (1, 0) : die("well, fuck");
}

sub sum_neighbors {
    my ($x, $y, %graph) = @_;
    my $rightwards_lookup = (($x+1) . "," . $y);
    my $rightwards = (@{$graph{(($x+1) . "," . $y)}}[2] or 0);
    return 
        (@{$graph{(($x + 1) . "," . ($y + 0))}}[2] or 0) +
        (@{$graph{(($x + 1) . "," . ($y + 1))}}[2] or 0) +
        (@{$graph{(($x + 0) . "," . ($y + 1))}}[2] or 0) +
        (@{$graph{(($x - 1) . "," . ($y + 1))}}[2] or 0) +
        (@{$graph{(($x - 1) . "," . ($y + 0))}}[2] or 0) +
        (@{$graph{(($x - 1) . "," . ($y - 1))}}[2] or 0) +
        (@{$graph{(($x + 0) . "," . ($y - 1))}}[2] or 0) +
        (@{$graph{(($x + 1) . "," . ($y - 1))}}[2] or 0)
    ;
}

sub print_graph {
    my %graph = @_;
    foreach my $lookup (sort { @{$graph{$a}}[0] <=> @{$graph{$b}}[0] } keys(%graph)) {
        say "$lookup: @{ $graph{$lookup}}";
    }
}

1;