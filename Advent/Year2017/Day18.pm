package Advent::Year2017::Day18;

use 5.28.0;
use warnings;
use strict;
use Exporter qw(import);
use Scalar::Util qw(looks_like_number);
use Data::Dumper;

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(a b);
our %EXPORT_TAGS = ( DEFAULT => [qw(a b)] );

sub get {
    my ($registers, $index) = @_;
    if (defined $registers->{$index}) {
        return $registers->{$index};
    } else {
        return 0;
    }
}

sub set {
    my ($registers, $index, $operand) = @_;
    $registers->{$index} = r($registers, $operand);
}

sub r {
    my ($registers, $in) = @_;
    if (looks_like_number($in)) {
        return $in;
    } else {
        return get($registers, $in);
    }
}

sub process_a {
    my ($pc, $registers, $line, $frequency) = @_;
    my $val;
    #say "processing $line";
    #sleep(1);
    $line =~ /(?<command>\w+) (?<first>\w)( (?<second>[\-0-9a-z]+))?/;
    if ($+{command} eq "set") {
        # set X Y sets register X to the value of Y.
        set($registers, $+{first}, r($registers, $+{second}));
        return ($pc + 1, $frequency);
    } elsif ($+{command} eq "add") {
        # add X Y increases register X by the value of Y.
        $val = get($registers, $+{first});
        $val += r($registers, $+{second});
        set($registers, $+{first}, $val);
        return ($pc + 1, $frequency);
    } elsif ($+{command} eq "mul") {
        # mul X Y sets register X to the result of multiplying the value contained in register X 
        # by the value of Y.
        $val = get($registers, $+{first});
        $val *= r($registers, $+{second});
        set($registers, $+{first}, $val);
        return ($pc + 1, $frequency);
    } elsif ($+{command} eq "mod") {
        # mod X Y sets register X to the remainder of dividing the value contained in register X
        # by the value of Y (that is, it sets X to the result of X modulo Y).
        $val = get($registers, $+{first});
        $val = $val % r($registers, $+{second});
        set($registers, $+{first}, $val);
        return ($pc + 1, $frequency);
    } elsif ($+{command} eq "rcv") {
        # rcv X recovers the frequency of the last sound played, but only when the value of X 
        # is not zero. (If it is zero, the command does nothing.)
        $val = get($registers, $+{first});
        if ($val != 0) {
            say "recieved frequency: $frequency";
            die("butts");
        }
        return ($pc + 1, $frequency);
    } elsif ($+{command} eq "snd") {
        # snd X plays a sound with a frequency equal to the value of X.
        $val = get($registers, $+{first});
        say "setting sound to $val";
        return ($pc + 1, $val);
    } elsif ($+{command} eq "jgz") {
        # jgz X Y jumps with an offset of the value of Y, but only if the value
        # of X is greater than zero. (An offset of 2 skips the next instruction, 
        # an offset of -1 jumps to the previous instruction, and so on.)
        $val = get($registers, $+{first});
        my $offset = r($registers, $+{second});
        my $jump = $pc + 1;
        if ($val > 0) {
            $jump = $pc + $offset;
        }
        return ($jump, $frequency);
    }
}

sub process {
    my ($pc, $registers, $line, $frequency) = @_;
    my $val;
    #say "processing $line";
    #sleep(1);
    $line =~ /(?<command>\w+) (?<first>\w)( (?<second>[\-0-9a-z]+))?/;
    if ($+{command} eq "set") {
        # set X Y sets register X to the value of Y.
        set($registers, $+{first}, r($registers, $+{second}));
        return ($pc + 1, undef);
    } elsif ($+{command} eq "add") {
        # add X Y increases register X by the value of Y.
        $val = get($registers, $+{first});
        $val += r($registers, $+{second});
        set($registers, $+{first}, $val);
        return ($pc + 1, undef);
    } elsif ($+{command} eq "mul") {
        # mul X Y sets register X to the result of multiplying the value contained in register X 
        # by the value of Y.
        $val = get($registers, $+{first});
        $val *= r($registers, $+{second});
        set($registers, $+{first}, $val);
        return ($pc + 1, undef);
    } elsif ($+{command} eq "mod") {
        # mod X Y sets register X to the remainder of dividing the value contained in register X
        # by the value of Y (that is, it sets X to the result of X modulo Y).
        $val = get($registers, $+{first});
        $val = $val % r($registers, $+{second});
        set($registers, $+{first}, $val);
        return ($pc + 1, undef);
    } elsif ($+{command} eq "rcv") {
        # rcv X receives the next value and stores it in register X. 
        # If no values are in the queue, the program waits for a value to be sent to it. 
        # Programs do not continue to the next instruction until they have received a value. 
        # Values are received in the order they are sent.
        #say ".receive";
        if (defined $frequency) {
            #say ".with frequency $frequency";
            set($registers, $+{first}, $frequency);
            return ($pc + 1, "NOM");
        } else {
            return ($pc, "DEADLOCK");
        }
    } elsif ($+{command} eq "snd") {
        # snd X sends the value of X to the other program. 
        # These values wait in a queue until that program is ready to receive them. 
        # Each program has its own message queue, so a program can never receive a message it sent.
        $val = r($registers, $+{first});
        return ($pc + 1, $val);
    } elsif ($+{command} eq "jgz") {
        # jgz X Y jumps with an offset of the value of Y, but only if the value
        # of X is greater than zero. (An offset of 2 skips the next instruction, 
        # an offset of -1 jumps to the previous instruction, and so on.)
        $val = r($registers, $+{first});
        my $offset = r($registers, $+{second});
        my $jump = $pc + 1;
        #say ".jump if $val > 0 by offset $offset";
        if ($val > 0) {
            $jump = $pc + $offset;
        }
        return ($jump, undef);
    }
}

sub a  {
    my $registers = {};
    my $pc = 0;
    my $out = undef;

    while (1)  {
        my $ins = $_[$pc];
        #say "$pc: $ins";
        ($pc, $out) = process_a($pc, $registers, $ins, $out);
        #say "after instruction, PC at $pc";
        #print Dumper($registers);
        last if ($pc < 0) || ($pc > $#_); #this maybe doesnt work
    } 
}

sub b  { 
    my @register_banks = ({p => 0}, {p => 1});
    my @pcs = (0, 0);
    my @message_queues = ([], []);
    my $curr = 1;
    my $deadlocked_on_one_side = 0;
    my $count = 0;

    while (1) {
        my $other = $curr;
        $curr = $curr == 0 ? 1 : 0;
        my $pc = $pcs[$curr];
        my $registers = $register_banks[$curr];
        my $out = undef;

        if (defined $message_queues[$curr][0]) {
            $out = $message_queues[$curr][0];
        }

        my $stroffset = $curr == 1 ? "\t\t\t" : "";

        my $instruction = $_[$pc];
        #say "$stroffset [$curr] \@$pc: $instruction";
        my $b_before = $register_banks[$curr]{b};
        ($pc, $out) = process($pc, $registers, $instruction, $out);
        my $b_after = $register_banks[$curr]{b};
        #say "$stroffset register b was $b_before and is now $b_after";
        $pcs[$curr] = $pc;
        #say "$stroffset new PC $pc";

        # out can be undef, an integer value, NOM, or DEADLOCK
        # an integer value should be hucked into the other program's message queue
        # NOM indicates that a value has been consumed and should be popped off of our queue
        # DEADLOCK indicates that the program is deadlocked
        if (defined $out) {
            if ($out eq "NOM") {
                my $consumed = shift @{ $message_queues[$curr] };
                $deadlocked_on_one_side = 0;
                if ($consumed < 0) {
                    #say "$stroffset $pc $curr receiving $consumed";
                }
                #say "$stroffset $curr <-- $consumed --- $other";
            } elsif ($out eq "DEADLOCK") {
                #say "$stroffset deadlocked";
                if ($deadlocked_on_one_side == 1) {
                    say "============ DEADLOCK ============";
                    last;
                }
                $deadlocked_on_one_side = 1;
            } else {
                push @{ $message_queues[$other] }, $out;
                if ($out < 0) {
                    #say "$stroffset $pc $curr sending $out";
                }
                #say "$stroffset $curr --- $out ---> $other";
                if ($curr == 1) {
                    $count++;
                }
                $deadlocked_on_one_side = 0;
            }
        } else {
            $deadlocked_on_one_side = 0;
        }

        last if ($pc < 0) || ($pc > $#_);
    }

    say "program 1 sent a value $count times";
}

1;