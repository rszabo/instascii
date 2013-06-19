package InstaMediaImage;
use Container;
use WebContainer;
use Data::Dumper;
use warnings;
use strict;
our @ISA = qw(Container);

my ($webcontainer, $renderer);
sub new {
  my ($class) = shift;
  my ($self)  = $class->SUPER::new();
  bless ($self, $class);

  # Copy the basic rendering details from config to $self.
  #
  my $conf = new InstasciiConfiguration();
  $self->set('image_url'   , shift);
  $self->set('enabled'     , $conf->canRender());
  $self->set('renderer'    , $conf->get('renderer'));
  $self->set('rendermethod', $conf->get('rendermethod'));
  $webcontainer = new WebContainer();
  return $self;
}

sub draw {
  my ($self)    = @_;
  my $image_url = $self->get('image_url');

  unless($self->get('enabled')) {
    $self->drawStupid($image_url);
    return;
  }

  # Fetch image, attempt to draw.
  my $data = $webcontainer->get($image_url);
  if ($data eq "") { $self->drawStupid("Nothing to do for $image_url"); return ''; }

  # Cached renderer? Perform!
  if (defined($renderer)) {
    $renderer->draw($data);
    return;
  }

  # Choose renderer
  if ($self->get("rendermethod") eq "package") {         # Built-in renderer, package.
    if ($self->get('renderer') eq "GD") {
      require ImageAsciiGD;
      $renderer = new ImageAsciiGD();
    }
    elsif ($self->get('renderer') eq "IM") {
      require ImageMagickGD;
      $renderer = new ImageMagickGD();
    }

    if (defined($renderer)) {
      $renderer->draw($data);
      return;
    }

  }
  elsif ($self->get('rendermethod') eq "custom") {        # Custom renderer, i.e. script.
    my $script = $self->get('renderer');
    `$script $data`;
    return;
  }
  $self->drawStupid("No renderer found for $image_url");

}

# If InstaMediaImage is disabled we will show text instead.
#
sub drawStupid {
  my ($self, $text) = @_;

  print "drawStupid(): $text\n";
}

1;
