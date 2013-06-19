package InstaMedia;
use Container;
use Data::Dumper;
use strict;
our @ISA = qw(Container);

# All results from InstAscii are arrays of this package.
#
# @todo Singleton. Only one MEDIA per call, i.e. one user per X requests.
#       Currently this object will only cache if several requests
#       are made to the same user/option. It will certainly be improved.
#
sub new {
  my $class = shift;
  my $self  = $class->SUPER::new();
  my $jdata = shift;

  # Store keys and values on object
  while (my ($key, $val) = each(% ${ \$jdata })) {
    #print "- $key = $val\n";
    $self->set($key, $val);
  }
  #print "\n";
  bless ($self, $class);
  return $self;
}

# @todo We should implement getters and setters here
# for convinience.
#

1;
