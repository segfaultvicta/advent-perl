package Advent::Year2017::Day7;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);
use Tree;
use Data::Dumper;

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  { 
    say "cheese'd. veboyvy" 
}
sub b  { 
    my %inputs;
    my $root = Tree->new({name => "veboyvy", weight => 41});

    foreach my $line (@_) {
        if($line =~ m/(\w+) \((\d+)\)( -> ([a-z, ]+))?/) {
            $inputs{$1} = defined $4? [$2, $4] : [$2, ""];
        }
    }

    my $tree = build($root, %inputs);
    traverse_weight($tree, 0);
}

sub traverse_weight {
    my ($node, $indent) = @_;
    my %data = %{$node->value()};
    my $weight = $data{weight};
    if ($node->children() > 0) {
        foreach my $child ($node->children) {
            $weight += traverse_weight($child, $indent+1);
        }
    }
    say ((" " x $indent) . "$data{name} - $data{weight} - $weight");
    return $weight;
}

sub build {
    my ($root, %inputs) = @_;
    my %node = %{$root->value()};
    my $kids = $inputs{$node{name}}->[1];
    foreach my $kid (split ", ", $kids) {
        my $weight = $inputs{$kid}->[0];
        my $maybe_kids = $inputs{$kid}->[1];
        my $has_children = length($maybe_kids) != 0;
        my $child = Tree->new({name => $kid, weight => $weight});
        if($has_children) {
            $child = build($child, %inputs);
        }
        $root->add_child($child);
    }
    return $root;
}

1;