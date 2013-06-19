

                                               by Richard K. Szabó, 2013
::::::.    :::. .::::::.:::::::::::::::.     .::::::.   .,-:::::  ::::::
;;;`;;;;,  `;;;;;;`    `;;;;;;;;'''';;`;;   ;;;`    ` ,;;;'````'  ;;;;;;
[[[  [[[[[. '[['[==/[[[[,    [[    ,[[ '[[, '[==/[[[[,[[[         [[[[[[
$$$  $$$ "Y$c$$  '''    $    $$   c$$$cc$$$c  '''    $$$$         $$$$$$
888  888    Y88 88b    dP    88,   888   888,88b    dP`88bo,__,o, 888888
MMM  MMM     YM  "YMmMY"     MMM   YMM   ""`  "YMmMY"   "YUMMMMMP"MMMMMM

                 An Instagram Client for terminals
                https://richardkszabo.me/instascii/


See LICENSE for GPL. This software is not really copyrighted:
Credit where credit is due.

Neither Richard K. Szabó nor Instascii is affiliated with Instagram
and/or it's affiliates.



TODO
-----------------------------------------------------------------------
0)                     Sleep.
1)                     --show-followers, --show-following.
2-3904290349509059359) Note sure. ANSI-colors maybe.


CHANGELOG
-----------------------------------------------------------------------
See ./CHANGELOG


PREREQUISITES
-----------------------------------------------------------------------

1. Instagram access
   Make sure you have an Instagram Access Token before using this software.

   Register Instagram client: http://instagram.com/developer/clients/manage
   Validate for API-access  : http://instagram.com/developer/authentication/

2. Perl with LWP, GD/ImageMagick is optional as the image-renderer
   can be whatever.

3. A write-enabled directory, defaults to /tmp/


USAGE
-----------------------------------------------------------------------

Export environmental variable instagram_access_token or set
access_token in InstasciiConfiguration.pm.

The Instagram API accepts user-ids when browsing and interacting,
Instascii will accept username and perform a getByUsername() before
any such call to the API.


./instascii.pl [--help]

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



CREDITS
-----------------------------------------------------------------------

ImageAsciiGD.pm based on example code by jimt, 2006.
  jimt's profile : http://www.perlmonks.org/?node_id=19316
  original code  : http://www.perlmonks.org/?node_id=578595

Thanks to: D. Fors., Joakim Karlsson and Textalk AB.

See ./LICENSE
