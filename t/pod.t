# pod.t
#
# Test suite for File::Path - test the POD
#
# copyright (C) 2007 David Landgren

use strict;

use Test::More;

eval qq{use Test::Pod};
my $has_test_pod = $@ ? 0 : 1;

eval qq{use Test::Pod::Coverage};
my $has_test_pod_coverage = $@ ? 0 : 1;

if (!$ENV{PERL_AUTHOR_TESTING}) {
    plan skip_all => 'PERL_AUTHOR_TESTING environment variable not set (or zero)';
}
elsif ($has_test_pod or $has_test_pod_coverage) {
    plan tests => $has_test_pod + $has_test_pod_coverage;
}
else {
    plan skip_all => 'POD testing modules not installed';
}

SKIP: {
    skip( 'Test::Pod not installed on this system', 1 )
        unless $has_test_pod;
    pod_file_ok( 'Path.pm' );
}

SKIP: {
    skip( 'Test::Pod::Coverage not installed on this system', 1 )
        unless $has_test_pod_coverage;
    pod_coverage_ok( 'File::Path', 'POD coverage is go!' );
}

