package FilePathTest;
use strict;
use warnings;
use base 'Exporter';
use SelectSaver;
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
  my $warn = '';
  local $SIG{__WARN__} = sub { $warn .= shift };
  &$coderef;
  return $warn;
}

sub _run_for_verbose {
  my $coderef = shift;
  my $stdout;
  {
    open my $stdout_fh, '>', \$stdout;
    my $guard = SelectSaver->new($stdout_fh);
    &$coderef;
  }
  return $stdout;
}

1;
