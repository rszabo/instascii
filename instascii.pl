#!/usr/bin/perl -w
#
# INSTASCII by Richard K. Szabó, 2013-06 (C)
#   https://richardkszabo.me/instagram/
#
# See README and LICENSE that came with this file.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of either: the GNU General Public License as published
# by the Free Software Foundation; or the Artistic License.
#
# See http://dev.perl.org/licenses/ for more information.
#
# See InstasciiConfiguration for details on usage.
#
# Original version written in PHP by the same author, 2013-06-11
#

use InstasciiConfiguration;
use InstagramClient;
use Instascii;
use InstaMedia;
use Data::Dumper;
use strict;
use diagnostics;
binmode(STDOUT, ':utf8');

my $ia_conf   = new InstasciiConfiguration();
my $instascii = new Instascii();
my $instagram = new InstagramClient();

# Enough parameters to work with?
if (scalar(@ARGV) eq 0) { $ia_conf->usage(); }
# Do we have a graphical renderer?
$ia_conf->testRenderers();

do {

  # Iterate over things to do.
  #
  my $result;
  while (my ($key, $val) = each(% ${ \$ia_conf->getAll() })) {
    if ($key eq 'help') {
      $ia_conf->usage();
    }
    elsif ($key eq 'search-user') {
      $result = $instagram->searchByUsername($val);
    }
    elsif ($key eq "search-hash") {
      $result = $instagram->searchByHashtag($val);
    }
    elsif ($key eq "show-user") {
      $result = $instagram->getUserDetails($instagram->getByUsername($val));
    }
    elsif ($key eq "show-feed") {
      $result = $instagram->getUserFeed($instagram->getByUsername($val));
    }
    elsif ($key eq "show-followers") {
      $result = $instagram->getUserFollowers($instagram->getByUsername($val));
    }
    elsif ($key eq "show-following") {
      $result = $instagram->getUserFollowing($instagram->getByUsername($val))
    }
    elsif ($key eq "show-popular") {
      $result = $instagram->getAllPopular();
    }

    # @todo Do not parse refresh, access_token and stuff...
    $instascii->draw($key, $val, $result);


  }

} while($ia_conf->loops());
