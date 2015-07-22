package FilePathTest;
use base 'Exporter';
use Cwd;
use File::Spec::Functions;

our @EXPORT = qw(_run_for_warning _run_for_verbose _basedir);

sub _basedir {
  return catdir( curdir(),
                 sprintf( 'test-%x-%x-%x', time, $$, rand(99999) ),
  );

}

sub _run_for_warning {
  my $coderef = shift;
  my $warn;
  local $SIG{__WARN__} = sub { $warn = shift };
  &$coderef;
  return $warn;
}

sub _run_for_verbose {
  my $coderef = shift;
  my $stdout = '';
  local *STDOUT;
  open STDOUT, '>', \$stdout;
  &$coderef;
  close STDOUT;
  return $stdout;
}

1;
