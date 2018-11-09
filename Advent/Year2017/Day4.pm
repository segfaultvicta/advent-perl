package Advent::Year2017::Day4;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub a  {
    my $valid_phrases = 0;
    foreach my $phrase (@_) {
        my $valid_phrase = 1;
        my %words;
        foreach my $word (split " ", $phrase) {
            $words{$word} = $words{$word} ? $words{$word} + 1 : 1;
        }
        foreach my $wc_index (keys %words) {
            if ($words{$wc_index} > 1) {
                $valid_phrase = 0;
            }
        }
        $valid_phrases += $valid_phrase;
    }
    say "$valid_phrases valid phrases in the given input.";
}
sub b  { 
    my $valid_phrases = 0;
    foreach my $phrase (@_) {
        my $valid_phrase = 1;
        my %words;
        foreach my $word (split " ", $phrase) {
            my @chars = split "", $word;
            my $normalised_word = join "", sort @chars;
            $words{$normalised_word} = $words{$normalised_word} ? $words{$normalised_word} + 1 : 1;
        }
        foreach my $wc_index (keys %words) {
            if ($words{$wc_index} > 1) {
                $valid_phrase = 0;
            }
        }
        $valid_phrases += $valid_phrase;
    }
    say "$valid_phrases valid phrases in the given input.";
}

1;