

use strict;

use Test::More tests => 6;
use Config;
use Fcntl ':mode';

BEGIN {
    use_ok('Cwd');
    use_ok('File::Path', qw(rmtree mkpath make_path remove_tree));
    use_ok('File::Spec::Functions');
}

my $tmp_base = catdir(
    curdir(),
    sprintf( 'test-%x-%x-%x', time, $$, rand(99999) ),
);

SKIP: {
    skip "This is not a MSWin32 platform", 3
        unless $^O eq 'MSWin32';

    my $UNC_path = catdir(getcwd(), $tmp_base, 'uncdir');
    #dont compute a SMB path with $ENV{COMPUTERNAME}, since SMB may be turned off
    #firewalled, disabled, blocked, or no NICs are on and there the PC has no
    #working TCPIP stack, \\?\ will always work
    $UNC_path = '\\\\?\\'.$UNC_path;

    is(mkpath($UNC_path), 1, 'mkpath on Win32 UNC path returns made 1 dir');

    ok(-d $UNC_path, 'mkpath on Win32 UNC path made dir');

    my $removed = rmtree($UNC_path);

    cmp_ok($removed, '>', 0, "removed $removed entries from $UNC_path");
}
