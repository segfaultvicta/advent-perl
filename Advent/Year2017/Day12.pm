package Advent::Year2017::Day12;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);
use Graph;

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    my $graph = Graph::Undirected->new;

    foreach my $line (@_) {
        my ($u, $edges) = ($line =~ /(\d+) <-> (.+)/);
        foreach my $v (split ", ", $edges) {
            $graph->add_edge($u, $v);
        }
    }
    my @connected_to_origin = $graph->connected_component_by_index($graph->connected_component_by_vertex("0"));
    my $n = scalar @connected_to_origin;
    say "$n programs are in vertex 0's group.";
}

sub b  { 
    my $graph = Graph::Undirected->new;

    foreach my $line (@_) {
        my ($u, $edges) = ($line =~ /(\d+) <-> (.+)/);
        foreach my $v (split ", ", $edges) {
            $graph->add_edge($u, $v);
        }
    }
    my @connected_components = $graph->connected_components();
    my $n = scalar @connected_components;
    say "$n groups of connected vertices total";
}

1;