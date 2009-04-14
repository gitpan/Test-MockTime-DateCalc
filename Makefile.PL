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
use ExtUtils::MakeMaker;

WriteMakefile
  (NAME         => 'Test-MockTime-DateCalc',
   ABSTRACT     => 'Fake date/time for Date::Calc functions.',
   VERSION_FROM => 'lib/Test/MockTime/DateCalc.pm',
   PREREQ_PM    => {
                    'Date::Calc' => 4.0,
                   },

   AUTHOR       => 'Kevin Ryde <user42@zip.com.au>',
   LICENSE      => 'gpl',
   SIGN         => 1,
   clean        => { FILES => [ 'DateCalc.html' ] },

   # Test::MockTime version 0.10 and 0.11 had Test::MockTime::DateCalc
   # included, so recommend 0.12
   EXTRA_META => <<'HERE',
recommends:
    Test::MockTime: 0.12
optional_features:
    maximum_tests:
        description: Have "make test" do as much as possible.
        requires:
            Test::Pod: 1.00
no_index:
    directory:
        - devel
        - t
resources:
    homepage: http://www.geocities.com/user42_kevin/test-mocktime-datecalc/index.html
    license: http://www.gnu.org/licenses/#GPL
HERE
  );

sub MY::postamble {
  return <<'MAKE_FRAG';

LINT_FILES = $(TO_INST_PM) t/*.t devel/*.pl
# examples/*.pl
lint:
	perl -MO=Lint $(LINT_FILES)
pc:
	-podchecker $(LINT_FILES)
	perlcritic $(LINT_FILES)
unused:
	for i in $(LINT_FILES); do perl -Mwarnings::unused -I lib $$i; done

myman:
	mv MANIFEST MANIFEST.old
	touch SIGNATURE
	(make manifest 2>&1; diff -u MANIFEST.old MANIFEST) |less

DateCalc.html: lib/Test/MockTime/DateCalc.pm Makefile
	-perl -MPod::Simple::HTML -e Pod::Simple::HTML::go \
	  lib/Test/MockTime/DateCalc.pm >DateCalc.html

# find files in the dist with mod times this year, but without this year in
# the copyright line
copyright-years-check:
	year=`date +%Y`; \
	tar tvfz $(DISTVNAME).tar.gz \
	| egrep '$$year-|debian/copyright' \
	| sed 's:^.*$(DISTVNAME)/::' \
	| (result=0; \
	  while read i; do \
	    case $$i in \
	      '' | */ \
	      | debian/changelog | debian/compat \
	      | t/pod.t \
	      | COPYING | MANIFEST* | SIGNATURE | META.yml) \
	      continue ;; \
	    esac; \
	    if test -e "$(srcdir)/$$i"; then f="$(srcdir)/$$i"; \
	    else f="$$i"; fi; \
	    if ! grep -q "Copyright.*$$year" $$f; then \
	      echo "$$i":"1: this file"; \
	      grep Copyright $$f; \
	      result=1; \
	    fi; \
	  done; \
	  exit $$result)

debug-constants-check:
	if egrep -n 'DEBUG => [^0]' $(TO_INST_PM); then exit 1; else exit 0; fi

diff-prev:
	rm -rf diff.tmp
	mkdir diff.tmp
	cd diff.tmp \
	&& tar xfz ../$(DISTNAME)-`expr $(VERSION) - 1`.tar.gz \
	&& tar xfz ../$(DISTNAME)-$(VERSION).tar.gz
	-cd diff.tmp; diff -ur $(DISTNAME)-`expr $(VERSION) - 1` \
	                       $(DISTNAME)-$(VERSION) >tree.diff
	-less diff.tmp/tree.diff
	rm -rf diff.tmp

MAKE_FRAG
}
