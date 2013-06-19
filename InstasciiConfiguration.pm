package InstasciiConfiguration;
use warnings;
use strict;

my $singleton;

# Show usage information and exit.
#
sub usage {
  print(
    "\n"
    . "  Navigation, user-name or hash-tag as parameter:\n"
    . "    --search-user=, --search-hash=,    --show-feed=,\n"
    . "    --show-user=,   --show-followers=, --show-following=\n"
    . "    --show-popular\n"
    . "    --refresh=<times>\n"
    . "\n"
    . "  Display:\n"
    . "    --hide-comments, --hide-likes, --hide-images\n"
    . "    --limit=<count>\n"
    . "\n"
    . "  Image manipulation:\n"
    . "    --invert, --smaller\n"
    . "    --renderer=<custom script>\n"
    . "\n"
    . "  Miscellaneous:\n"
    . "   --write_dir=<dir>       Temporary storage for cache etc.\n"
    . "   --access_token=...      Override built-in, recommended to keep in file though.\n"
    . "   ...all internal variables can be overridden with --<variable_name>=\n"
    . "\n"
  );
  exit;
}

sub new {
  my ($class) = shift;
  if (defined($singleton))  { return $singleton; }

  $singleton = { my %params };

  # @todo
  # These could default to {settings} or a file,
  # future-fix I guess.
  $singleton->{params}{'refresh'}      = 0;
  $singleton->{params}{'write_dir'}    = '/tmp';
  $singleton->{params}{'user-agent'}   = 'instascii/1.1';

  #
  # Note, because the access_tokens are private
  # it would be unwise to share it.  I  set  it
  # using a script before developing / testing.
  #
  $singleton->{params}{'access_token'} = $ENV{'instagram_access_token'};

  # Read parameters and assign them on our object.
  foreach (@ARGV) {
    my $_param = length($_) > 2 ? substr($_, 2) : $_;
    my ($key, $val) = split(/\=/, $_param);
    unless (defined($key)) { next;       }
    unless (defined($val)) { $val = '1'; }
    $singleton->{params}{$key} = $val;
  }

  # Make sure that the Instagram Access Token has been set.
  if ($singleton->{params}{'access_token'} eq '') {
    die("Developer! access_token not set. Serious issue.");
  }

  bless ($singleton, $class);
  return $singleton;
}

sub get {
  my ($self, $key) = @_;
  return (defined($self->{params}{$key})) ? $self->{params}{$key} : '';
}
sub getAll {
  my ($self) = @_;
#  while (my ($key, $val) = each(% ${ \$config->getAll() })) {
  return $self->{params};
}

sub set {
  my ($self, $key, $value) = @_;
  return $self->{params}{$key} = $value;
}


# Loop until {refresh} reaches 0, used in primary do / while.
sub loops {
  my $self = $_[0];

  if ($self->get("refresh") > 0)  { sleep(1); }
  $self->set("refresh", $self->get("refresh") - 1);

  return ($self->get("refresh") > 0);
}

# Determine the ability to draw images to ASCII
# Parameters --hide-images and --renderer overrides this test.
sub testRenderers {
  my ($self) = @_;

  if ($self->get('hide-images'))    { return; }
  if ($self->get('renderer') ne "") {
    $self->set('rendermethod', 'custom');
    return;
  }
  $self->set('rendermethod', 'package');

  if ($self->testRenderer("GD")) {
    return $self->set('renderer', 'GD');
  }
  # Not fully tested etc.
  if ($self->testRenderer("Image/Magick")) {
    return $self->set('renderer', 'IM');
  }

  print "--- WARNING: No image renderer detected.                       ---\n";
  print "--- The error is however not fatal so execution wasn't halted. ---\n";
  print "--- See InstasciiConfiguration.pm::testRenderers()             ---\n\n";
}

sub testRenderer {
  my ($self, $module_name) = @_;
  eval {
    require "$module_name.pm";
  };
  unless($@) {
    return 1;
  }
  return 0;
}

# Returns binary if {renderer} is set
sub canRender {
  my ($self) = @_;
  return ($self->get('renderer') ne "");
}



1;
