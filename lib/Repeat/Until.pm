package Repeat::Until ;

use v5.20 ;
use warnings ;

use Exporter qw(import) ;

our @EXPORT = qw(repeat_until) ;

use feature qw(signatures) ;

no warnings qw(experimental::signatures) ;

=pod

=head1 NAME

C<Repeat::Until> - run a coderef until it returns true

=head1 SYNOPSIS

    use Repeat::Until ;

    my $tries = 5 ;     # default 0 - keep trying forever
    my $delay = 2 ;     # default 1 second

    my $file = repeat_until { get_locked_file() } $tries, $delay ;

    write_stuff_to( $file ) if $file ;

    # -----

    # The 'try' counter is passed to the anonymous sub:

    my $file = repeat_until { my $try = shift; warn "Try $try of $tries" ; get_locked_file() } $tries, $delay ;

=head1 DESCRIPTION

Repeatedly run a coderef for a max number of tries, short-cutting when it returns true.

The return value is the return value of the coderef.

Context aware - the coderef is run in the same list or scalar context as C<repeat_until> is called.

In void context, the coderef is run in scalar context, but no value is returned when the coderef returns true.

=head2 Gotcha!

Note there is no comma after the coderef in the argument list. This will cause you pain if you forget it.
The error generated is:

    Useless use of private variable in void context

BUT Perl reports the wrong line.


=head2 Exports

The module exports a single subroutine.

=over 4

=item C<repeat_until( $coderef [$repeats], [$delay])>


C<$repeats> and C<$delay> are optional.

C<$repeats> defaults to C<0>, meaning repeat indefinitely until coderef returns true.

C<$delay> defaults to C<1> second.

Note that there is no comma between coderef and C<$repeats>.

The current try counter is passed to the coderef.

=back

=cut


sub repeat_until : prototype(&;$$) ( $cr, $reps = 0, $interval = 1 ) {

    my $try = 0 ;

    while ( $try++ < $reps or $reps == 0 ) {
        if (wantarray) {
            my @result = $cr->($try) ;
            return @result if @result ;
            }
        elsif ( my $result = $cr->($try) ) {
            return $result if defined wantarray ;    # scalar
            return ;                                 # void
            }

        sleep $interval ;
        }

    return ;
    }

1 ;
