

use strict;

use Test::More;
use Config;
use Fcntl ':mode';


BEGIN {
    use Cwd;
    use File::Path qw(rmtree mkpath make_path remove_tree);
    use File::Spec::Functions;
}

plan skip_all  => 'prerequisites not met' unless prereq() == 1;
plan tests     => 6;

eval "use Test::Output";
my $has_Test_Output = $@ ? 0 : 1;


my $tmp_base = catdir(
    curdir(),
    sprintf( 'test-%x-%x-%x', time, $$, rand(99999) ),
);

# invent some names
my @dir = (
    catdir($tmp_base, qw(a b)),
    catdir($tmp_base, qw(a c)),
    catdir($tmp_base, qw(z b)),
    catdir($tmp_base, qw(z c)),
);

# create them
my @created = mkpath([@dir]);

my $dir;
my $dir2;

my ( $max_uid, $max_user ) = @{ max_u() };
my ( $max_gid, $max_group ) = @{ max_g() };

my $dir_stem = $dir = catdir($tmp_base, 'owned-by');

$dir = catdir($dir_stem, 'aaa');
@created = make_path($dir, {owner => $max_user});
is(scalar(@created), 2, "created a directory owned by $max_user...");

my $dir_uid = (stat $created[0])[4];
is($dir_uid, $max_uid, "... owned by $max_uid");

$dir = catdir($dir_stem, 'aab');
@created = make_path($dir, {group => $max_group});
is(scalar(@created), 1, "created a directory owned by group $max_group...");

my $dir_gid = (stat $created[0])[5];
is($dir_gid, $max_gid, "... owned by group $max_gid");

$dir = catdir($dir_stem, 'aac');
@created = make_path($dir, {user => $max_user, group => $max_group});
is(scalar(@created), 1, "created a directory owned by $max_user:$max_group...");

($dir_uid, $dir_gid) = (stat $created[0])[4,5];
is($dir_uid, $max_uid, "... owned by $max_uid");
is($dir_gid, $max_gid, "... owned by group $max_gid");

SKIP: {
    skip 'Test::Output not available', 1
           unless $has_Test_Output;

    # invent a user and group that don't exist
    do { ++$max_user  } while (getpwnam($max_user));
    do { ++$max_group } while (getgrnam($max_group));

    $dir = catdir($dir_stem, 'aad');
    stderr_like(
        sub {make_path($dir, {user => $max_user, group => $max_group})},
        qr{\Aunable to map $max_user to a uid, ownership not changed: .* at \S+ line \d+
unable to map $max_group to a gid, group ownership not changed: .* at \S+ line \d+\b},
        "created a directory not owned by $max_user:$max_group..."
    );
}

sub max_u {
  # find the highest uid ('nobody' or similar)
  my $max_uid   = 0;
  my $max_user = undef;
  while (my @u = getpwent()) {
      if ($max_uid < $u[2]) {
          $max_uid  = $u[2];
          $max_user = $u[0];
      }
  }
  return [$max_uid, $max_user];
}

sub max_g {
    # find the highest gid ('nogroup' or similar)
    my $max_gid   = 0;
    my $max_group = undef;
    while (my @g = getgrent()) {
        if ($max_gid < $g[2]) {
            $max_gid = $g[2];
            $max_group = $g[0];
        }
    }
}

sub prereq {
  # "getpwent() not implemented on $^O"
  return 0 unless $Config{d_getpwent};

  # getgrent() not implemented on $^O
  return 0 unless $Config{d_getgrent};

  # not running as root
  return 0 unless $< == 0;

  # "darwin's nobody and nogroup are -1 or -2"
  return 0 if $^O eq 'darwin';

  # getpwent() appears to be insane
  return 0 unless @{ max_u() }[1] > 0;

  # getgrent() appears to be insane
  return 0 unless @{ max_g() }[1] > 0;

  return 1;
}
