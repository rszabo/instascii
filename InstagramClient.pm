package InstagramClient;

use Container;
use WebContainer;
use Cache;
use JSON;
use Data::Dumper;
use warnings;
use strict;

our @ISA = qw(Container);

our $api_url = "https://api.instagram.com/v1";

# Perform query
#
sub performRequest {
  my ($self, $url)   = @_;
  my ($conf, $webcontainer) = (new InstasciiConfiguration(), new WebContainer());
  my $full_url = $api_url . $url . '&access_token=' . $conf->get('access_token');
  return $self->dataDecode($url, $webcontainer->get($full_url));
}

# Return parsed data as scalar or InstaMedia-object
#
sub dataDecode {
  my ($self, $url, $jsondata) = (shift, shift, decode_json("@_"));
  unless(${ $jsondata }{'meta'}{'code'} = 200) { die("Parsing $url failed.\n@_\n"); }
  my ($data, @res) = (${ $jsondata }{'data'}, ());
#  my @results = (ref($data) eq "ARRAY") ? $data->[0] : $data;

  if (ref($data) eq "ARRAY") {
    foreach (@ $data) { push(@res, new InstaMedia($_));  }
    return \@res;
  }
  return new InstaMedia($data);
}

# Get user_id by username
sub getByUsername {
  my ($self, $username) = @_;
  my $instamedia = $self->searchByUsername($username, 1);
  return $instamedia->[0]->get('id');
}

sub getUserDetails {
  my ($self, $user_id) = @_;
  return $self->performRequest('/users/' . $user_id . '/?');
}

sub searchByUsername {
  my ($self, $username, $count) = @_;
  unless (defined($count)) { $count = 20; }
  return $self->performRequest('/users/search?q=' . $username . '&count=' . $count);
}

sub getSelfFeed {
  my ($self) = @_;
  return $self->performRequest('/users/self/feed?');
}

sub getUserFeed {
  my ($self, $user_id, $count) = @_;
  unless (defined($count)) { $count = 20; }
  return  $self->performRequest('/users/' . $user_id . '/media/recent/?count=' . $count);
}

sub getUserFollowers {
  my ($self, $user_id) = @_;
  return $self->performRequest('/users/' . $user_id . '/followed-by?');
}

sub getUserFollowing {
  my ($self, $user_id) = @_;
  return $self->performRequest('/users/' . $user_id . '/follows?');
}

sub searchByHashtag {
  my ($self, $hashtag) = @_;
  return $self->performRequest('/tags/search?q=' . $hashtag);
}

sub getAllPopular {
  my ($self) = @_;
  return $self->performRequest("/media/popular/?");

}

sub getTagInfo {
  my ($self, $hashtag) = @_;
  return $self->performRequest('/tags/' . $hashtag . '?');
}


1;
