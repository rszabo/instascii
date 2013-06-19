package Container;

# Basic data-storage for various packages of
# Instascii. Cache, InstaMedia and so forth,
# all use Container.
#

use warnings;
use strict;

sub new {
  my ($class, $self) = (shift, { my %data });
  bless ($self, $class);
  return $self;
}

sub get {
  my ($self, $key) = @_;
  return (defined($self->{data}{$key})) ? $self->{data}{$key} : '';
}

sub getAll {
  my ($self) = @_;
  return $self->{data};
}

sub set {
  my ($self, $key, $value) = @_;
  return $self->{data}{$key} = $value;
}

1;
