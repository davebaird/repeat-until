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

=head1 DESCRIPTION

Repeatedly run a coderef for a max number of tries, short-cutting when it returns true.

The return value is the return value of the coderef.

Context aware - the coderef is run in the same list or scalar context as C<repeat_until> is called.

In void context, the coderef is run in scalar context, but no value is returned when the coderef returns true.

=head1 GOTCHA!

Note there is no comma after the coderef in the argument list. This will cause you pain if you forget it.
The error generated is:

    Useless use of private variable in void context

BUT Perl reports the wrong line.


=head2 Exports

The module exports a single subroutine.

=over 4

=item C<repeat_until( $coderef, [$repeats], [$delay])>


C<$repeats> and C<$delay> are optional.

C<$repeats> defaults to C<0>, meaning repeat indefinitely until coderef returns true.

C<$delay> defaults to C<1> second.

=back

=cut


sub repeat_until : prototype(&;$$) ( $cr, $reps = 0, $interval = 1 ) {

    $reps-- if $reps == 0 ;    # forever until true

    while ( $reps-- != 0 ) {
        if (wantarray) {
            my @result = $cr->() ;
            return @result if @result ;
            }
        elsif ( defined wantarray ) {
            my $result = $cr->() ;
            return $result if $result ;
            }
        else {
            my $result = $cr->() ;
            return if $result ;
            }

        sleep $interval ;
        }

    return ;
    }

1 ;
