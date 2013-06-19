package Cache;
use warnings;
use strict;

my $singleton;
my $MAX_AGE = 300; # seconds

sub new {
  my $class = shift;
  if (defined($singleton)) {
    return $singleton;
  }
  $singleton  = {};
  bless ($singleton, $class);
  return $singleton;
}

sub getFile {
  my ($self, $key) = @_;
  my $conf = new InstasciiConfiguration();
  return $conf->get("write_dir") . "/.iac_" . $self->getHash($key);
}

sub set {
  my ($self, $key, $value) = @_;
  my $file = $self->getFile($key);
  open (F, "> " . $file) or die("Failed to write: $file\nCheck permissions.\n");
  print F $value;
  close(F);
}

sub get {
  my ($self, $key) = @_;
  unless ($self->exist($key)) { return ''; }
  my $file = $self->getFile($key);

  open (F, $file) or die("Unexpected failure in reading cache: $file\n");;
  my $filedata = "";
  while (<F>) { $filedata .= $_;  }
  close(F);

  return $filedata;
}


sub exist {
  my ($self, $s) = @_;
  my $file = $self->getFile($s);

  unless(-e $file) { return 0; }

  # Has the cache expired?
  my $mod = (stat($file))[9];
  if ((time() - $mod) > $MAX_AGE) {
    unlink($file);
  }

  return (-e $file);
}

sub getHash {
  my ($self, $key) = @_;
  return unpack("%32W*", $key) % 65535;
}

1;
