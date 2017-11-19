#!/usr/local/bin/perl
# FILE .../hp200lx-dbweb/DBweb.pm
#
# written:       2001-10-04
# latest update: 2001-10-04 17:59:01
# $Id: DBweb.pm,v 1.1 2002/03/28 09:11:23 gonter Exp $
#

package HP200LX::DBweb;

use strict;
use vars qw($VERSION @ISA @EXPORT);
use Exporter;

$VERSION= '0.11';
@ISA= qw(Exporter);
@EXPORT= qw(
  print_db_def_html
  print_db_def_html_form
);

# ----------------------------------------------------------------------------
sub print_db_def_html
{
  my $db= shift;
  local *FO= shift;

  my @CDEF= @{$db->{'carddef'}};
  my @FDEF= @{$db->{'fielddef'}};
  my ($i, $j);
  my @CARD_FIELDS= qw(x y h w Lsize);

  my $cnt_CDEF= @CDEF;
  my $cnt_FDEF= @FDEF;
  print FO <<EOX;
<br>db=$db cnt_CDEF=$cnt_CDEF cnt_FDEF=$cnt_FDEF<br>
<table border=1>
<tr><th rowspan=2>idx<th rowspan=2>name<th colspan=3>type
    <th rowspan=2>fid<th rowspan=2>off
    <th rowspan=2>res<th rowspan=2>flags
EOX
    foreach $j (@CARD_FIELDS)
    {
      print FO "<th rowspan=2>", $j, "</th>";
    }
  print FO <<EOX;
</tr>
<tr><th>num<th>name<th>size</tr>
EOX

  for ($i= 0;; $i++)
  {
    my $cdef= shift (@CDEF);
    my $fdef= shift (@FDEF);
    last unless (defined ($cdef) && defined ($fdef));
    # print FO "cdef=$cdef fdef=$fdef\n";

    my $type= $fdef->{'ftype'};
    my $ftype= HP200LX::DB::get_field_type ($type);
    my $ttype= $ftype->{Desc} || "USER$type";
    my $x_siz= $ftype->{Size};
    # print ">> type=$type ftype=$ftype ttype=$ttype\n";

    my $x_off= sprintf ('0x%02X', $fdef->{off});
    my $x_flg= sprintf ('0x%02X', $fdef->{flg});
    my $x_name= $fdef->{name};
    # T2D!!! $x_name=~ s/[\x80-\xFF]/?/g;

    print FO "<tr><td align=right>$i<td>'$x_name'",
             "<td align=right>$type<td>$ttype<td align=right>$x_siz",
             "<td align=right>$fdef->{fid}<td align=right>$x_off",
             "<td align=right>$fdef->{res}<td align=right>$x_flg";
    foreach $j (@CARD_FIELDS)
    {
      print FO "<td align=right>", $cdef->{$j}, "</td>";
    }
    print FO "</tr>\n";
  }

  print FO <<EOX;
</table>
EOX

}

# ----------------------------------------------------------------------------
# see new HP200LX::DBgui::card
sub print_db_def_html_form
{
  my $db= shift;
  local *FO= shift;
  my $form_url= shift;

  my $AD= $db->{APT_Data};
  my $fd= $db->{fielddef};      # description abuot data types
  my $cd= $AD->{carddef} || $db->{carddef}; # description about positions etc.
  print ">>> AD=", $AD->{carddef}, " db=", $db->{carddef}, "\n";
  my $cpd= $db->{cardpagedef};

  print FO <<EOX;
<pre>
<form method=post url="$form_url">
<table border=1>
EOX

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # T2D:
  # + this loop *roughly* matches the layout of a DB card.
  my ($i, @i);
  if (exists ($AD->{field_sequence})) { @i= @{$AD->{field_sequence}}; }
  else { @i = (0 .. $#$cd); }

  my $pos= {};
  foreach $i (@i)
  {
    my $ce= $cd->[$i];     # card definition
    my $x= $ce->{'x'};
    my $y= $ce->{'y'};
    $pos->{$y}->{$x}= $i;
  }

  my ($x, $y);
  foreach $y (sort {$a <=> $b} keys %$pos)
  {
   print "<tr>";
   my $ref= $pos->{$y};
   foreach $x (sort {$a <=> $b} keys %$ref)
   {
    $i= $ref->{$x};
    my $ce= $cd->[$i];     # card definition
    my $fe= $fd->[$i];     # field definition
    my $ty= $fe->{Ftype};
    my $name= $fe->{name};

    my $h= 1 + int ($ce->{'h'} / 8);
    my $w= 1 + int ($ce->{'w'} / 8);
    if ($ty eq 'NOTE')
    {
      print "<td>$name<td><textarea name=\"$name\" cols=$w rows=$h></textarea></td>\n";
      print "w=$w h=$h\n";
    }
    elsif ($ty eq 'STATIC' || $ty eq 'GROUP')
    {
      print "<td>$name</td>\n";
    }
    elsif ($name)
    {
      print "<td>$name<td><input type=input name=\"$name\" width=$w></input></td>\n";
    }
   }
   print "</tr>\n";
  }

  print FO <<EOX;
</table>
</form>
</pre>
EOX

}

1;
