package WebContainer;
use InstasciiConfiguration;
use Data::Dumper;
use LWP;
use warnings;
use strict;

my ($singleton, $cache, $conf);
sub new {

  my ($class) = shift;
  if (defined($singleton)) { return $singleton; }

  $singleton = { };

  # Setup only once
  $cache = new Cache();
  $conf  = new InstasciiConfiguration();

  bless ($singleton, $class);
  return $singleton;
}

sub get {
  my ($self, $url)  = @_;

  # At the moment ( https://groups.google.com/forum/?fromgroups=#!topic/instagram-api-developers/PE5-1Ba9s_M )
  # we can't fetch profile images so we're cowardly refusing to do so.
  #if ($url =~ m/images\.ak\.instagram\.com/) { return ''; }

  # Check cache first
  if ($cache->exist($url)) { return $cache->get($url); }

  # Download
  my $ua = LWP::UserAgent->new();
  $ua->agent($conf->get('user-agent'));
  my $req = HTTP::Request->new(GET => $url);
  my $res = $ua->request($req);

  # Cache and return
  if ($res->is_success) { $cache->set($url, $res->content); return $res->content; }

  die("Failed to fetch data: " . $res->status_line);

}

1;
