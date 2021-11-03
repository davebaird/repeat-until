# NAME

`Repeat::Until` - run a coderef until it returns true

# SYNOPSIS

    use Repeat::Until ;

    my $tries = 5 ;     # default 0 - keep trying forever
    my $delay = 2 ;     # default 1 second

    my $file = repeat_until { get_locked_file() } $tries, $delay ;

    write_stuff_to( $file ) if $file ;

# DESCRIPTION

Repeatedly run a coderef for a max number of tries, short-cutting when it returns true.

The return value is the return value of the coderef.

Context aware - the coderef is run in the same list or scalar context as `repeat_until` is called.

In void context, the coderef is run in scalar context, but no value is returned when the coderef returns true.

# GOTCHA!

Note there is no comma after the coderef in the argument list. This will cause you pain if you forget it.
The error generated is:

    Useless use of private variable in void context

BUT Perl reports the wrong line.

## Exports

The module exports a single subroutine.

- `repeat_until( $coderef, [$repeats], [$delay])`

    `$repeats` and `$delay` are optional.

    `$repeats` defaults to `0`, meaning repeat indefinitely until coderef returns true.

    `$delay` defaults to `1` second.
