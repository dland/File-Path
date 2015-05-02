use strict;
use warnings;
use Test::More;

eval "require Path::Class";
plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;

use File::Path qw(remove_tree make_path);
Path::Class->import;

my $name = 'test';
my $dir = dir($name);

sub test {
  my ($dir, $pass_arg) = @_;

  my $args = [ $dir, ($pass_arg ? {} : ()) ];
  my $desc = sprintf(
    'dir isa %s, second arg is %s',
    (ref($dir) || 'string'),
    ($pass_arg ? '{}' : 'not passed')
  );

  return ($args, $desc);
}

for my $mk_dir ($name, dir($name)) {
  for my $mk_pass_arg (0, 1) {

    for my $rm_dir ($name, dir($name)) {
      for my $rm_pass_arg (0, 1) {
        remove_tree($name) if -e $name;

        my ($mk_args, $mk_desc) = test($mk_dir, $mk_pass_arg);
        make_path(@$mk_args);

        if (ok( -d $dir, "we made $dir ($mk_desc)")) {
          my ($rm_args, $rm_desc) = test($rm_dir, $rm_pass_arg);
          remove_tree(@$rm_args);
          ok( ! -d $dir, "...then we removed $dir ($rm_desc)");
        } else {
          fail("...can't remove it if we didn't create it");
        }
      }
    }
  }
}

done_testing;
