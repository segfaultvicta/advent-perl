package Advent::Year2017::Day20;

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
    my @particles;
    my $idx = 0;
	foreach my $line (@_) {
		my ($p, $v, $a) = split /\, /, $line;
		my ($px, $py, $pz) = $p =~ m/p\=\<(-?\d+)\,(-?\d+)\,(-?\d+)\>/;
		my ($vx, $vy, $vz) = $v =~ m/v\=\<(-?\d+)\,(-?\d+)\,(-?\d+)\>/;
		my ($ax, $ay, $az) = $a =~ m/a\=\<(-?\d+)\,(-?\d+)\,(-?\d+)\>/;
		my $particle = {
            i => $idx,
			p => {x => $px, y => $py, z => $pz},
			v => {x => $vx, y => $vy, z => $vz},
			a => {x => $ax, y => $ay, z => $az},
		};
        push @particles, $particle;
        $idx += 1;
	}
	
    my $limit = 1000;

    for (my $i = 0; $i <= $limit; $i++) {
        # physics tick
        foreach my $p (@particles) {
            $p->{v}{x} += $p->{a}{x};
            $p->{v}{y} += $p->{a}{y};
            $p->{v}{z} += $p->{a}{z};
            $p->{p}{x} += $p->{v}{x};
            $p->{p}{y} += $p->{v}{y};
            $p->{p}{z} += $p->{v}{z};
        }
    }

    # find particle closest to 0,0,0
    my $closest_idx;
    my $closest_distance = 9999999;
    foreach my $p (@particles) {
        my $distance = abs($p->{p}{x}) + abs($p->{p}{y}) + abs($p->{p}{z});
        if ($distance < $closest_distance) {
            $closest_distance = $distance;
            $closest_idx = $p->{i};
        }
    }

    say "closest particle is $closest_idx at $closest_distance after $limit ticks";
}

sub sayparticle {
    my $p = shift;
    say "@ ($p->{p}{x},$p->{p}{y},$p->{p}{z}) \t\tv ($p->{v}{x},$p->{v}{y},$p->{v}{z}) \t\ta ($p->{a}{x},$p->{a}{y},$p->{a}{z})";
}

sub b  { 
    my $particles = {};
    my $idx = 0;
	foreach my $line (@_) {
		my ($p, $v, $a) = split /\, /, $line;
		my ($px, $py, $pz) = $p =~ m/p\=\<(-?\d+)\,(-?\d+)\,(-?\d+)\>/;
		my ($vx, $vy, $vz) = $v =~ m/v\=\<(-?\d+)\,(-?\d+)\,(-?\d+)\>/;
		my ($ax, $ay, $az) = $a =~ m/a\=\<(-?\d+)\,(-?\d+)\,(-?\d+)\>/;
		my $particle = {
			p => {x => $px, y => $py, z => $pz},
			v => {x => $vx, y => $vy, z => $vz},
			a => {x => $ax, y => $ay, z => $az},
		};
        $particles->{$idx} = $particle;
        $idx += 1;
	}
	
    my $limit = 40;

    for (my $i = 0; $i <= $limit; $i++) {
        say "calculating tick $i";
        # physics tick
        foreach my $idx (keys %$particles) {
            my $p = $particles->{$idx};
            $p->{v}{x} += $p->{a}{x};
            $p->{v}{y} += $p->{a}{y};
            $p->{v}{z} += $p->{a}{z};
            $p->{p}{x} += $p->{v}{x};
            $p->{p}{y} += $p->{v}{y};
            $p->{p}{z} += $p->{v}{z};
        }

        my @collision_indices = grep { has_cospatial_partners($particles->{$_}, $_, $particles) } keys %$particles;
        foreach my $idx (@collision_indices) {
            delete $particles->{$idx};
        }

        my $count_collisions = scalar @collision_indices;
        say "$count_collisions collisions at step $i" unless $count_collisions == 0;
    }

    my @alive = keys %$particles;
    my $count = scalar @alive;
    say "$count particles left alive after $limit steps";

    # 476 is too high, so somehow I'm missing collisions that should be happening
    # despite the fact that this, again, works on the damn sample input
}

sub has_cospatial_partners {
    my ($q, $q_idx, $particles) = @_;

    my @cospatials = grep {
        my $p = $particles->{$_};
        $q->{p}{x} == $p->{p}{x} &&
        $q->{p}{y} == $p->{p}{y} &&
        $q->{p}{z} == $p->{p}{z} &&
        $q_idx != $_;
    } keys %$particles;

    return (scalar @cospatials) > 0;
}

1;