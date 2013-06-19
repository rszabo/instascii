
### Usage

An Instagram Client for terminals (OS X, Linux, Windows Console).

Export environmental variable instagram_access_token or set
access_token in InstasciiConfiguration.pm.

The Instagram API accepts user-ids when browsing and interacting,
Instascii will accept username and perform a getByUsername() before
any such call to the API.

    $ ./instascii.pl [--help]

    Navigation, user-name or hash-tag as parameter:
      --search-user=, --search-hash=,    --show-feed=,
      --show-user=,   --show-followers=, --show-following=
      --show-popular
      --refresh=<times>

    Display:
      --hide-comments, --hide-likes, --hide-images
      --limit=<count>

    Image manipulation:
      --invert, --smaller
      --renderer=<custom script>

    Miscellaneous:
      --write_dir=<dir>       Temporary storage for cache etc.
      --access_token=...      Override built-in, recommended to keep in file though.
      ...all internal variables can be overridden with --<variable_name>=

More information over at https://richardkszabo.me/instascii/

### Prerequisites

1.  Instagram access
  * Make sure you have an Instagram Access Token before using this software.

  * Register Instagram client: http://instagram.com/developer/clients/manage

  * Validate for API-access  : http://instagram.com/developer/authentication/

2. Perl with LWP, GD/ImageMagick is optional as the image-renderer can be whatever.
3. A write-enabled directory, defaults to /tmp/


### Credits and license

* See LICENSE for GPL. This software is not really copyrighted: Credit where credit is due.
* Neither Richard K. Szabó nor Instascii is affiliated with Instagram and/or it's affiliates.
* ImageAsciiGD.pm based on example code by jimt, 2006.
  * http://www.perlmonks.org/?node_id=19316 and http://www.perlmonks.org/?node_id=578595
* Thanks to: D. Fors., Joakim Karlsson and Textalk AB.
* See ./LICENSE
