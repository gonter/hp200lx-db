#!/usr/local/bin/perl
# FILE .../hp200lx-dbgui/Makefile.PL
#
# written:       1998-06-16
# latest update: 1998-09-27 21:22:52
# $Id: Makefile.PL,v 1.1 2001/07/19 14:44:14 gonter Exp $
#

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'         => 'HP200LX::DBgui',
    'VERSION_FROM' => 'DBgui.pm',          # finds $VERSION
    'PMLIBDIRS'    => [ 'DBgui' ],
);
