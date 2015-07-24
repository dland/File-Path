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
  my $stdout = '';
  {
    my $guard = SelectSaver->new(_ref_to_fh(\$stdout));
    &$coderef;
  }
  return $stdout;
}

sub _ref_to_fh {
  my $output = shift;
  open my $fh, '>', $output;
  return $fh;
}

BEGIN {
  if ($] < 5.008000) {
    eval qq{#line @{[__LINE__+1]} "@{[__FILE__]}"\n} . <<'END' or die $@;
      no warnings 'redefine';
      use Symbol ();

      sub _ref_to_fh {
        my $output = shift;
        my $fh = Symbol::gensym();
        tie *$fh, 'StringIO', $output;
        return $fh;
      }

      package StringIO;
      sub TIEHANDLE { bless [ $_[1] ], $_[0] }
      sub CLOSE    { @{$_[0]} = (); 1 }
      sub PRINT    { ${ $_[0][0] } .= $_[1] }
      sub PRINTF   { ${ $_[0][0] } .= sprintf $_[1], @_[2..$#_] }
      1;
END
  }
}

1;
