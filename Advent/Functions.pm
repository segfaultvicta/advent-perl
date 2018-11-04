package Advent::Functions;

use 5.28.0;
use warnings;
use strict;
use Exporter;

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(h t);
our %EXPORT_TAGS = ( DEFAULT => [qw(h t)] );

sub h { $_[0]; }
sub t { shift; @_ };

1;