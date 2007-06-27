# generate Makefile for building File::Path
#
# Copyright (C) 2007 David Landgren

use strict;
use ExtUtils::MakeMaker;

eval "use ExtUtils::MakeMaker::Coverage";
$@ or print "Adding testcover target\n";

my @license = $ExtUtils::MakeMaker::VERSION > 6.30
    ? qw(LICENSE perl)
    : ();

WriteMakefile(
    NAME          => 'File::Path',
    VERSION_FROM  => 'Path.pm',
    ABSTRACT_FROM => 'Path.pm',
    AUTHOR        => 'David Landgren',
    PREREQ_PM => {
        'File::Basename' => 0,
    },
    @license,
);
