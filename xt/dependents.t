use Test::More;
use Test::DependentModules qw( test_all_dependents );

#$ENV{PERL_TEST_DM_CPAN_VERBOSE} = 1;

test_all_dependents('File::Path');
