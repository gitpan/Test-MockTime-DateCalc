#!/usr/bin/perl

# Copyright 2009 Kevin Ryde

# This file is part of Test-MockTime-DateCalc.
#
# Test-MockTime-DateCalc is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation; either version 3, or (at your option) any
# later version.
#
# Test-MockTime-DateCalc is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Test-MockTime-DateCalc.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;

use Test::More tests => 3;
use Date::Calc;

SKIP: { eval 'use Test::NoWarnings; 1'
          or skip 'Test::NoWarnings not available', 1; }

my $ok = eval { require Test::MockTime::DateCalc };
my $error = $@;
diag ($ok ? 'oops, no error' : "error message (which is expected): $error");

ok (! $ok, 'should not load');
cmp_ok (index($error,'cannot fake'), '!=', -1,
        "error message should say 'cannot fake'");

exit 0;
