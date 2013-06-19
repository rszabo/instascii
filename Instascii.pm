package Instascii;

# This package helps in drawing
# the results  from  Instagram,
# as produced  by dataDecode().
#
use InstaMedia;
use InstaMediaImage;
use Data::Dumper;
use warnings;
use strict;

my $conf;
sub new {
  my ($class, $self) = (shift, {});
  $conf = new InstasciiConfiguration();
  bless ($self, $class);
  print $self->getLogo();
  return $self;
}

sub getLogo {
  my ($self) = @_;
  #open (F, "README") or die("README is missing. Not cool.");
#  my @file = <F>;
#  close(F);
#  my $r = "\n";
#  for (3..8) { $r .= $file[$_]; }
#  $r .= "\n";
 # return $r;

  my $r = "\n";
  $r .= '                                               by Richard K. Szabo, 2013' . "\n";
  $r .= '::::::.    :::. .::::::.:::::::::::::::.     .::::::.   .,-:::::  ::::::' . "\n";
  $r .= ';;;`;;;;,  `;;;;;;`    `;;;;;;;;\'\'\'\';;`;;   ;;;`    ` ,;;;\'````\'  ;;;;;;' . "\n";
  $r .= '[[[  [[[[[. \'[[\'[==/[[[[,    [[    ,[[ \'[[, \'[==/[[[[,[[[         [[[[[[' . "\n";
  $r .= '$$$  $$$ "Y$c$$  \'\'\'    $    $$   c$$$cc$$$c  \'\'\'    $$$$         $$$$$$' . "\n";
  $r .= '888  888    Y88 88b    dP    88,   888   888,88b    dP`88bo,__,o, 888888' . "\n";
  $r .= 'MMM  MMM     YM  "YMmMY"     MMM   YMM   ""`  "YMmMY"   "YUMMMMMP"MMMMMM' . "\n\n";
  return $r;


}


# Draw results, have parameter $param as guideline.
#
sub draw {
  my ($self, $param, $param_val, $data) = @_;

  # @todo Do NOT parse these. Maybe InstasciiConfiguration::%settings, rather than %params?
  if ($param eq "write_dir" || $param eq "refresh"
      || $param eq "access_token") { return; }


  if ($param eq "search-user") {
    my $count = scalar(@ $data);
    print "Found $count hits on $param_val:\n";
    foreach (@ $data) {
      $self->drawRowUsers($_);
    }
  }
  elsif ($param eq "show-user") {
    $self->drawUserDetails($data);
  }
  elsif ($param eq "show-feed") {
    $self->drawUserFeed($data);
  }
  elsif ($param eq "show-followers") {
    print Dumper($data);
  }

}

sub getReadableDate {
  my ($self, $unixtime) = @_;
  return scalar localtime $unixtime;
}

# Private, or whatever.
# Draws a row as determined by draw()
# @param $self, $instamedia object
sub drawRowUsers {
  my ($self, $instamedia) = @_;

  my $bio = $instamedia->get('bio')       || '';
  my $web = $instamedia->get('website')   || 'No web.';
  my $fn  = sprintf("%-40s", ($instamedia->get('full_name') || $instamedia->get('username')));

  $bio =~ s/(\n|\r)/, /g;

  my $_id    = sprintf("%10s",  $instamedia->get('id'));
  my $_user  = sprintf("%-17s", $instamedia->get('username'));;

  print '  '    . $_id    . ' / ' . $_user
        . ' / ' . $fn
        . ' / ' . $web    . ' / ' . $bio . "\n"

}

# Draw someones details
sub drawUserDetails {
  my ($self, $instamedia) = @_;

  print $instamedia->get('id') . ": " . $instamedia->get('username') . " / "
        . $instamedia->get('full_name') . "\n";
  my $inf = $instamedia->get('counts');
  print "Images: "        . ${ $inf }{'media'} . " / "
        . "Following: "   . ${ $inf }{'follows'} . " / "
        . "Followed by: " . ${ $inf }{'followed_by'} . "\n\n";

  my $image = new InstaMediaImage($instamedia->get('profile_picture'));
  $image->draw();
  print "\n";
  print ($instamedia->get('web') || 'No website');
  print "\n" . ($instamedia->get('bio') || 'No biography. ');
  print "\n";

}

# Draw someones feed
# hrmpf, it's currently quite bloated.
# @todo Rewrite.
#
sub drawUserFeed {
  my ($self, $data) = @_;
  # Show user info here..

  # Iterate through media on feed.
  my $cntr = 0;
  foreach (@ $data) {
    my $instamedia = new InstaMedia(${ $_ }{'data'});
    my $link       = $instamedia->get('link');
    my $filter     = $instamedia->get('filter');
    my $unixtime   = $instamedia->get('created_time');
    my $img_obj    = new InstaMedia($instamedia->get('images'));
    my $img_std    = $img_obj->get('standard_resolution')->{'url'};
    my $img_tmb    = $img_obj->get('thumbnail')->{'url'};
    my ($t_text, $t_date)    = ('No title', $self->getReadableDate($unixtime));
    my ($l_count, $l_users) = (0, '');
    my ($c_count, $c_users) = (0, '');
    # Get caption
    if ($instamedia->get('caption')) {
      my $title = new InstaMedia($instamedia->get('caption'));
      $t_text = $title->get('text');
      $t_date = $self->getReadableDate($title->get('created_time'));
    }

    # Show title
    my $title_display = "\n\n$t_text (@ $t_date)\n";
    print $title_display . ("-" x length($title_display)) ."\n";

    # Draw image
    my $image = new InstaMediaImage($img_tmb);
    $image->draw();
    print "\n(Original: $img_std)\n";
    print "\n";

    # Get likes
    if (!$conf->get('hide-likes') && $instamedia->get('likes')) {
      $l_count = $instamedia->get('likes')->{'count'};
      my $ld = $instamedia->get('likes')->{'data'};
      my $ld_c = scalar(@ $ld);
      print "$l_count likes: ";
      for (my $i = 0; $i < $ld_c; $i++) {
        print $ld->[$i]->{'username'} . ", ";
      }
      print "\n";
    }

    # Get comments?
    if (!$conf->get('hide-comments') && $instamedia->get('comments')) {
      my $comments = new InstaMedia($instamedia->get('comments'));
      $c_count = $comments->get('count');
      my $ld = $instamedia->get('comments')->{'data'};
      print "$c_count comments: \n";
      if ($c_count > 0) {
        for (my $i = 0; $i < $c_count; $i++) {
          my $c_obj = $ld->[$i];
          my $c_user = $c_obj->{'from'}->{'username'};
          my $c_text = $c_obj->{'text'};
          unless($c_obj->{'created_time'}) { next; }

          my $c_date = $self->getReadableDate($c_obj->{'created_time'});

          print "$c_date [$c_user]: $c_text\n";
        }
      }
    }

    # Done?
    $cntr++;
    if ($cntr == $conf->get('limit')) { last; }
  }
}


1;
