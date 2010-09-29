#!/usr/bin/perl -w

# Copyright 2009, 2010 Kevin Ryde

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
use Test::More;

eval { require Sub::Identify; 1 }
  or plan skip_all => "Sub::Identify not available -- $@";

use lib 't';
use MyTestHelpers;
BEGIN { MyTestHelpers::nowarnings() }

plan tests => 9;

require Test::MockTime::DateCalc;
require Date::Calc;

#------------------------------------------------------------------------------
# Sub::Identify sub_name() on replacements

foreach (qw(System_Clock
            Today
            Now
            Today_and_Now
            This_Year
            Gmtime
            Localtime
            Timezone
            Time_to_Date)) {
  my $name = $_;
  my $fullname = "Date::Calc::$name";
  my $coderef = do { no strict 'refs';
                     \&$fullname };
  my $subname = Sub::Identify::sub_name ($coderef);
  is ($subname, $name,
      "name of $name $coderef");
}

exit 0;
