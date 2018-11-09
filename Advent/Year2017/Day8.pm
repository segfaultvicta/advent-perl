package Advent::Year2017::Day8;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  {
    my %registers; 
    foreach my $line (@_) {
        if($line =~ m/(?<reg_a>\w+) (?<command>inc|dec) (?<diff>-*\d+) if (?<reg_b>\w+) (?<cond>.*) (?<amt>-*\d+)/) {
            say "Instruction: $+{command} $+{reg_a} by $+{diff} if $+{reg_b} $+{cond} $+{amt}";
            my $b = defined $registers{$+{reg_b}} ? $registers{$+{reg_b}} : 0;
            my $amt = int($+{amt});
            my $c = $+{cond};
            say "is $b $c $amt?";
            if($c eq  ">"? $b  > $amt :
               $c eq  "<"? $b  < $amt :
               $c eq "<="? $b <= $amt :
               $c eq ">="? $b >= $amt :
               $c eq "=="? $b == $amt :
               $c eq "!="? $b != $amt : 0) {
                   my $a = defined $registers{$+{reg_a}} ? $registers{$+{reg_a}} : 0;
                   say "triggering instruction on register a, which was $a";
                   $a = $+{command} eq "inc" ? $a + $+{diff} : $a - $+{diff};
                   say "and is now $a";
                   $registers{$+{reg_a}} = $a;
            }
        }
    }
    foreach my $key (keys %registers) {
        say "register $key is $registers{$key}";
    }
}
sub b  { 
    my %registers; 
    my $highest_value = 0;
    foreach my $line (@_) {
        if($line =~ m/(?<reg_a>\w+) (?<command>inc|dec) (?<diff>-*\d+) if (?<reg_b>\w+) (?<cond>.*) (?<amt>-*\d+)/) {
            say "Instruction: $+{command} $+{reg_a} by $+{diff} if $+{reg_b} $+{cond} $+{amt}";
            my $b = defined $registers{$+{reg_b}} ? $registers{$+{reg_b}} : 0;
            my $amt = int($+{amt});
            my $c = $+{cond};
            say "is $b $c $amt?";
            if($c eq  ">"? $b  > $amt :
               $c eq  "<"? $b  < $amt :
               $c eq "<="? $b <= $amt :
               $c eq ">="? $b >= $amt :
               $c eq "=="? $b == $amt :
               $c eq "!="? $b != $amt : 0) {
                   my $a = defined $registers{$+{reg_a}} ? $registers{$+{reg_a}} : 0;
                   say "triggering instruction on register a, which was $a";
                   $a = $+{command} eq "inc" ? $a + $+{diff} : $a - $+{diff};
                   say "and is now $a";
                   $registers{$+{reg_a}} = $a;
                   $highest_value = $a > $highest_value ? $a : $highest_value;
            }
        }
    }
    say "highest value recorded was $highest_value";
}

1;