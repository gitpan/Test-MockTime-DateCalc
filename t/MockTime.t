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

use lib 't';
use MyTestHelpers;
BEGIN { MyTestHelpers::nowarnings() }

BEGIN {
  if (! eval { require Test::MockTime }) {
    plan skip_all => "due to Test::MockTime not available -- $@";
  }
  plan tests => 7;
}

use Test::MockTime::DateCalc;
use Date::Calc;


my $fake_str = "10 Jan 1990 12:30:00 GMT";
diag $fake_str;
#                                      S  M  H   D M Y
require Time::Local;
my $fake_time_t = Time::Local::timegm (0,30,12, 10,0,90);
Test::MockTime::set_fixed_time ($fake_time_t);
sleep 2;
diag "gmtime($fake_time_t) is ", join(' ',gmtime($fake_time_t));

{
  my $func = 'System_Clock';
  my @got = Date::Calc::System_Clock(1);
  diag "$func ", join(' ',@got);
  is_deeply (\@got, [1990,1,10, 12,30,0, 10,3,0], "$fake_str - $func");
}
{
  my $func = 'Today';
  is_deeply ([Date::Calc::Today(1)], [1990,1,10], "$fake_str - $func");
}
{
  my $func = 'Now';
  is_deeply ([Date::Calc::Now(1)], [12,30,0], "$fake_str - $func");
}
{
  my $func = 'Today_and_Now';
  is_deeply ([Date::Calc::Today_and_Now(1)],
             [1990,1,10, 12,30,0], "$fake_str - $func");
}
{
  my $func = 'This_Year';
  is_deeply ([Date::Calc::This_Year(1)], [1990], "$fake_str - $func");
}
{
  my $func = 'Gmtime';
  is_deeply ([Date::Calc::Gmtime()],
             [1990,1,10, 12,30,0, 10,3,0], "$fake_str - $func");
}
{
  my $func = 'Localtime';
  # is_deeply ([Date::Calc::Localtime()], [1990,1,10, 12,30,0, 10,3,0], "$fake_str - $func");
}
{
  my $func = 'Timezone';
  # FIXME: not sure can reliably force a timezone to check this
  # is_deeply ([Date::Calc::Timezone()], [0,0,0, 1,0,0, 0], "$fake_str - Timezone");
}
{
  my $func = 'Time_to_Date';
  # FIXME: is this right for old MacOS, or is it local time?
  is_deeply ([Date::Calc::Time_to_Date()],
             [1990,1,10, 12,30,0], "$fake_str - $func");
}

exit 0;
