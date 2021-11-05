#!/usr/bin/env perl
use v5.20 ;
use Test2::V0 '!meta' ;

use FindBin ;
use lib "$FindBin::Bin/../lib" ;

use Repeat::Until ;

foreach my $trial ( 1, 2, 3 ) {
    diag "Trial $trial" ;

    my $c     = 0 ;
    my $start = time ;

    repeat_until { $c++ == 3 } 10, 1 if $trial == 1 ;
    repeat_until { $c++ == 3 } 10 if $trial == 2 ;
    repeat_until { $c++ == 3 }    if $trial == 3 ;

    # repeat_until { $c++ == 3 } $args->@* ;

    my $end = time ;

    ok( $c == 4,            "c == 4" )    or note("Got c: $c") ;
    ok( $end == $start + 3, "3 seconds" ) or note( "Got interval: " . ( $end - $start ) ) ;
    }

done_testing ;
