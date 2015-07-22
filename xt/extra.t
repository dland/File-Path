



my $extra =  catdir(curdir(), qw(EXTRA 1 a));

SKIP: {
    skip "extra scenarios not set up, see eg/setup-extra-tests", 14
        unless -e $extra;
    skip "Symlinks not available", 14 unless $Config{d_symlink};

    my ($list, $err);
    $dir = catdir( 'EXTRA', '1' );
    rmtree( $dir, {result => \$list, error => \$err} );
    is(scalar(@$list), 2, "extra dir $dir removed");
    is(scalar(@$err), 1, "one error encountered");

    $dir = catdir( 'EXTRA', '3', 'N' );
    rmtree( $dir, {result => \$list, error => \$err} );
    is( @$list, 1, q{remove a symlinked dir} );
    is( @$err,  0, q{with no errors} );

    $dir = catdir('EXTRA', '3', 'S');
    rmtree($dir, {error => \$error});
    is( scalar(@$error), 1, 'one error for an unreadable dir' );
    eval { ($file, $message) = each %{$error->[0]}};
    is( $file, $dir, 'unreadable dir reported in error' )
        or diag($message);

    $dir = catdir('EXTRA', '3', 'T');
    rmtree($dir, {error => \$error});
    is( scalar(@$error), 1, 'one error for an unreadable dir T' );
    eval { ($file, $message) = each %{$error->[0]}};
    is( $file, $dir, 'unreadable dir reported in error T' );

    $dir = catdir( 'EXTRA', '4' );
    rmtree($dir,  {result => \$list, error => \$err} );
    is( scalar(@$list), 0, q{don't follow a symlinked dir} );
    is( scalar(@$err),  2, q{two errors when removing a symlink in r/o dir} );
    eval { ($file, $message) = each %{$err->[0]} };
    is( $file, $dir, 'symlink reported in error' );

    $dir  = catdir('EXTRA', '3', 'U');
    $dir2 = catdir('EXTRA', '3', 'V');
    rmtree($dir, $dir2, {verbose => 0, error => \$err, result => \$list});
    is( scalar(@$list),  1, q{deleted 1 out of 2 directories} );
    is( scalar(@$error), 1, q{left behind 1 out of 2 directories} );
    eval { ($file, $message) = each %{$err->[0]} };
    is( $file, $dir, 'first dir reported in error' );
}


SKIP: {
    $dir = catdir('EXTRA', '3');
    skip "extra scenarios not set up, see eg/setup-extra-tests", 3
        unless -e $dir and $has_Test_Output;

    $dir = catdir('EXTRA', '3', 'U');
    stderr_like(
        sub {rmtree($dir, {verbose => 0})},
        qr{\Acannot make child directory read-write-exec for [^:]+: .* at \S+ line \d+\.?},
        q(rmtree can't chdir into root dir)
    );

    $dir = catdir('EXTRA', '3');
    stderr_like(
        sub {rmtree($dir, {})},
        qr{\Acannot make child directory read-write-exec for [^:]+: .* at (\S+) line (\d+)\.?
cannot make child directory read-write-exec for [^:]+: .* at \1 line \2
cannot make child directory read-write-exec for [^:]+: .* at \1 line \2
cannot remove directory for [^:]+: .* at \1 line \2},
        'rmtree with file owned by root'
    );

    stderr_like(
        sub {rmtree('EXTRA', {})},
        qr{\Acannot remove directory for [^:]+: .* at (\S+) line (\d+)
cannot remove directory for [^:]+: .* at \1 line \2
cannot make child directory read-write-exec for [^:]+: .* at \1 line \2
cannot make child directory read-write-exec for [^:]+: .* at \1 line \2
cannot make child directory read-write-exec for [^:]+: .* at \1 line \2
cannot remove directory for [^:]+: .* at \1 line \2
cannot unlink file for [^:]+: .* at \1 line \2
cannot restore permissions to \d+ for [^:]+: .* at \1 line \2
cannot make child directory read-write-exec for [^:]+: .* at \1 line \2
cannot remove directory for [^:]+: .* at \1 line \2},
        'rmtree with insufficient privileges'
    );
}

SKIP: {
    skip "extra scenarios not set up, see eg/setup-extra-tests", 12
        unless -d catdir(qw(EXTRA 1));

    rmtree 'EXTRA', {safe => 0, error => \$error};
    is( scalar(@$error), 10, 'seven deadly sins' ); # well there used to be 7

    rmtree 'EXTRA', {safe => 1, error => \$error};
    is( scalar(@$error), 9, 'safe is better' );
    for (@$error) {
        ($file, $message) = each %$_;
        if ($file =~  /[123]\z/) {
            is(index($message, 'cannot remove directory: '), 0, "failed to remove $file with rmdir")
                or diag($message);
        }
        else {
            like($message, qr(\Acannot (?:restore permissions to \d+|chdir to child|unlink file): ), "failed to remove $file with unlink")
                or diag($message)
        }
    }
}
