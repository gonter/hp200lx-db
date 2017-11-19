#!/usr/local/bin/perl
# FILE .../hp200lx-db/DB/diag.pm
#
# written:       2001-01-01
# latest update: 2001-01-01 18:13:36
# $Id: diag.pm,v 1.4 2002/03/28 09:39:03 gonter Exp $
#

package HP200LX::DB::diag;

use strict;
use vars qw($VERSION @ISA @EXPORT);
use Exporter;

$VERSION= '0.11';
@ISA= qw(Exporter);
@EXPORT= qw(
  print_db_def
);

# ----------------------------------------------------------------------------
sub print_db_def
{
  my $db= shift;
  local *FO= shift;

  $db->dump_def (*FO);
  print FO "database definition:\n";
  $db->show_db_def (*FO);
  # print FO "card definition:\n";
  $db->show_card_def (*FO);

  my $vpt_cnt= $db->get_viewptdef_count;
  print FO "view point count=$vpt_cnt\n";

  my $i;
  for ($i= 0; $i <= $vpt_cnt+100; $i++)
  {
    print FO "view point definition [$i]:\n";
    my $def= $db->find_viewptdef ($i);
    last unless (defined ($def));

    # print FO ">>> ", join (':', keys %$def), "\n";
    print FO "&type:vpt\n";
    print FO "&idx:$i\n";
    HP200LX::DB::vpt::show_viewptdef ($def, *FO);
  }
}

# ----------------------------------------------------------------------------
1;
