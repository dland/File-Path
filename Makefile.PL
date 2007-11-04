# generate Makefile for building File::Path
#
# Copyright (C) 2007 David Landgren

use strict;
use ExtUtils::MakeMaker;

eval "use ExtUtils::MakeMaker::Coverage";
$@ or print "Adding testcover target\n";

my @license =
    do {
        my $version = $ExtUtils::MakeMaker::VERSION;
        $version =~ tr/_//d;
        $version} > 6.30
    ? qw(LICENSE perl)
    : ();


WriteMakefile(
    NAME          => 'File::Path',
    VERSION_FROM  => 'Path.pm',
    ABSTRACT_FROM => 'Path.pm',
    AUTHOR        => 'David Landgren',
    INSTALLDIRS   => ($] >= 5.008001 ? 'perl' : 'site'),
    PREREQ_PM => {
        'File::Basename' => 0,
        'File::Spec'     => 0,
        'Cwd'            => 0,
    },
    clean => {
        FILES => 'cover_db',
    },
    @license,
);
