package ImageAsciiGD;
#
#
# Originally written by jimt around 2006
# Modified by Richard K. Szabó <https://richardkszabo.me> for Instascii.
#
# jimt's profile : http://www.perlmonks.org/?node_id=19316
# original code  : http://www.perlmonks.org/?node_id=578595
#
#
use GD;
use warnings;
use strict;

my $singleton;
my $conf;
sub new {
  my ($class) = shift;
  if (defined($singleton)) { return $singleton; }

  # Setup once
  $singleton = {};
  $conf      = new InstasciiConfiguration();

  bless ($singleton, $class);
  return $singleton;
}

sub draw {
  my ($self, $imagedata) = @_;
  my @master_ascii         = (qw(W M 0 o @ & j y . ), ',', qw(' - . `), ' ');
  my ($gdimg, $x, $matrix) = (GD::Image->new($imagedata), 0, []);
  my ($w, $h)              = $gdimg->getBounds();

  # Resize...
  if ($conf->get('smaller')) {
    $gdimg = $self->bisect($gdimg);
    ($w, $h) = $gdimg->getBounds();
  }

  # Better for terminals.
  if ($conf->get('invert')) {
    $gdimg = $self->invert($gdimg);
  }

  while ($x < $w) {
    my $y = 0;
    while ($y < $h) {
      my $index = $gdimg->getPixel($x, $y);
      my ($r,$g,$b) = $gdimg->rgb($index);
      $matrix->[$y]->[$x] = ($r + $g + $b) / 3;
      $y++;
    }
    $x++;
  }

  my ($num, $den)                = (2, 3);
  my $blocksize                  = $den - $num + 1;
  my $skipblock                  = $den - $blocksize;
  my ($matrix2, $m2line,$spacer) = ([], 0, 0);

  foreach my $l (0..$#$matrix) {
    if ($spacer > $skipblock){
      $spacer = ($spacer + 1) % $den;
      next;
    }
    $spacer = ($spacer + 1) % $den;

    my ($m2pix, $line) = (0, $matrix->[$l]);
    foreach my $p (0..$#$line) {
      my $total = 0;
      foreach my $multiplier (0..$blocksize - 1) {
          $total += $matrix->[$l + $multiplier]->[$p]
               if defined $matrix->[$l + $multiplier]->[$p];
      }
      my $m2value = int($total / $blocksize);
      $matrix2->[$m2line]->[$m2pix++] = $m2value;
    };

    $m2line++;
  };

  $matrix = $matrix2;
  foreach my $m (@$matrix) {
    foreach my $g (@$m) {
      my $idx = 0;

      #find out the ascii value we'll use. 0 is always our black,
      #255 is always our white
      if ($g == 255) {
        $idx =  $#master_ascii;
      }
      else {
        $idx = @master_ascii * $g / 256;
      };
      print $master_ascii[$idx];
    }
    print "\n";
  }
  print "(" . $w . "x" . $h . " px)\n";
}

# Invert an image resource
sub invert {
  my ($self, $image) = @_;
  my ($width, $height) = $image->getBounds();
  my $image2 = GD::Image->new($width,$height);

  for my $w (1..$width){
    for my $h (1..$height){
      my $index = $image->getPixel($w,$h);
      my (@rgb) = $image->rgb($index);
      for(@rgb) { $_ = 255-$_ }
      $index = $image2->colorExact(@rgb);
      if ($index == -1) { $index = $image2->colorAllocate(@rgb); }
      $image2->setPixel($w,$h,$index);
    }
  }

  return $image2;
}

# Bisect an image resource.
sub bisect {
  my ($self, $image)  = @_;
  my ($w, $h)         = $image->getBounds();
  my ($new_w, $new_h) = ($w / 2, $h / 2);
  my $new_image       = GD::Image->new($new_w, $new_h);

  $new_image->copyResampled($image, 0, 0, 0, 0, $new_w, $new_h, $w, $h);
  return $new_image;

}


1;
