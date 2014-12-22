# generate Makefile for building File::Path
#
# Copyright (C) 2007 David Landgren

use strict;
use ExtUtils::MakeMaker;

eval "use ExtUtils::MakeMaker::Coverage";
$@ or print "Adding testcover target\n";

my @extra_prereq = (
    $] < 5.006 ? ('Symbol' => 0) : (),
);

WriteMakefile1(
    NAME          => 'File::Path',
    VERSION_FROM  => 'Path.pm',
    ABSTRACT_FROM => 'Path.pm',
    AUTHOR        => 'David Landgren',
    INSTALLDIRS   => ($] >= 5.008001 ? 'perl' : 'site'),
    PREREQ_PM => {
        'Carp'           => 0,
        'Cwd'            => 0,
        'File::Basename' => 0,
        'File::Spec'     => 0,
        @extra_prereq,
    },
    TEST_REQUIRES => {
        'Test::More'	=> 0,
    },
    clean => {
        FILES => 'cover_db',
    },
    LICENSE => 'perl',
    MIN_PERL_VERSION => '5.00504',
    META_MERGE => {
        resources => {
            repository => 'https://github.com/dland/File-Path',
        },
    },
);

sub WriteMakefile1 {  #Compatibility code for old versions of EU::MM. Written by Alexandr Ciornii, version 0.23. Added by eumm-upgrade.
    my %params=@_;
    my $eumm_version=$ExtUtils::MakeMaker::VERSION;
    $eumm_version=eval $eumm_version;
    die "EXTRA_META is deprecated" if exists $params{EXTRA_META};
    die "License not specified" if not exists $params{LICENSE};
    if ($params{AUTHOR} and ref($params{AUTHOR}) eq 'ARRAY' and $eumm_version < 6.5705) {
        $params{META_ADD}->{author}=$params{AUTHOR};
        $params{AUTHOR}=join(', ',@{$params{AUTHOR}});
    }
    if ($params{TEST_REQUIRES} and $eumm_version < 6.64) {
        $params{BUILD_REQUIRES}={ %{$params{BUILD_REQUIRES} || {}} , %{$params{TEST_REQUIRES}} };
        delete $params{TEST_REQUIRES};
    }
    if ($params{BUILD_REQUIRES} and $eumm_version < 6.5503) {
        #EUMM 6.5502 has problems with BUILD_REQUIRES
        $params{PREREQ_PM}={ %{$params{PREREQ_PM} || {}} , %{$params{BUILD_REQUIRES}} };
        delete $params{BUILD_REQUIRES};
    }
    delete $params{CONFIGURE_REQUIRES} if $eumm_version < 6.52;
    delete $params{MIN_PERL_VERSION} if $eumm_version < 6.48;
    delete $params{META_MERGE} if $eumm_version < 6.46;
    delete $params{META_ADD} if $eumm_version < 6.46;
    delete $params{LICENSE} if $eumm_version < 6.31;

    WriteMakefile(%params);
}

