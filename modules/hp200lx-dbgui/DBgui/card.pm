#!/usr/local/bin/perl
# FILE DBgui/card.pm
#
# card view component of the HP-200LX/DB GUI
#
# T2D:
# + DEL records
#
# written:       1998-03-08
# latest update: 2001-03-11  2:23:09
# $Id: card.pm,v 1.3 2002/07/01 06:55:55 gonter Exp $
#

package HP200LX::DBgui::card;

use strict;
use vars qw($VERSION @ISA);
use Exporter;

$VERSION= '0.09';
@ISA= qw(Exporter HP200LX::DBgui);

use Tk;

# ----------------------------------------------------------------------------
sub new
{
  my $class= shift;
  my $DBparent= shift;          # parent object creating this card view
  my $title= shift;
  my %pars= @_;

  my $db= $DBparent->{db};      # database object
  my $AD= $db->{APT_Data};

  print ">>> card pars=", join (':', %pars), "\n";
  my $first= (defined ($pars{'index'})) ? $pars{'index'} : 1;

  my $fd= $db->{fielddef};      # description abuot data types
  my $cd= $AD->{carddef} || $db->{carddef}; # description about positions etc.
  print ">>> AD=", $AD->{carddef}, " db=", $db->{carddef}, "\n";
  my $cpd= $db->{cardpagedef};
  my ($ce, $fe);                # single items
  my ($i, %fields, $top);

  # print "cd=", ref($cd), " fd=", ref ($fd), "\n";

  unless (defined ($top= $pars{top}))
  {
    $top= MainWindow->new ();
    $top->title ($title);
  }

  my $DBgui=
  {
    top => $top,                        # Tk window
    Fields => \%fields,                 # field descriptors
    db => $db,                          # Database object
    Parent => $DBparent,                # Parent GUI object
    num => $db->get_last_index ()+1,    # total number of records
    disp => -1,                         # number of displayed record
    disp_rec => undef,                  # currently displayed record
    visibility => 'mapped',             # card is icon/widget/withdrawn
    FramePos => {},                     # horizontal frames by y-coord
  };
  bless $DBgui, $class;

  # record bar
  &HP200LX::DBgui::create_record_bar ($top, $DBgui, $DBparent);

  # ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # T2D:
  # + this loop *roughly* matches the layout of a DB card.
  my @i;
  if (exists ($AD->{field_sequence})) { @i= @{$AD->{field_sequence}}; }
  else { @i = (0 .. $#$cd); }

  my $debug= $db->{'__DEBUG__'} & 0x01;
  if ($debug) { print "<tr><th>idx<th>name<th>type<th>x<th>y<th>w<th>h<th>Lsize\n"; }

  foreach $i (@i)
  {
    $ce= $cd->[$i];     # card definition
    $fe= $fd->[$i];     # field definition
    my $ty= $fe->{Ftype};
    my $name= $fe->{name};
    # $name= '&field'. $i unless ($name);

    if ($ty eq 'LIST')
    { # don't display LIST type entries
      if ($debug) { print "<tr><td>.<td>$name<td>LIST<td>...\n"; }
      next;
    }

    $fields{$name}= { 'Ftype' => $ty, 'val' => '' };
    $fields{$name}->{'el'}=
      &make_field ($top, \$fields{$name}->{'val'}, $name, $ty,
                   $ce->{'x'}, $ce->{'y'}, $ce->{'w'}, $ce->{'h'},
                   $ce->{'Lsize'}, $debug);
  }

  $DBgui->show_record ($first, 0);
  $DBgui;
}

# ----------------------------------------------------------------------------
sub make_field
{
  my $top= shift;
  my $tv= shift;                # ref to scalar text variable
  my ($name, $type, $x, $y, $w, $h, $Lsize, $debug)= @_;

  # print " { 'name' => '$name', 'type' => '$type',",
  #       " 'x' => $x, 'y' => $y, 'w' => $w, 'h' => $h,",
  #       " 'Lsize' => $Lsize },\n";

  if ($debug)
  {
    print "<tr><td>.<td>$name<td>$type<td>$x<td>$y<td>$w<td>$h<td>$Lsize\n";
  }
  print "name=$name type=$type tv=$tv '$$tv'\n";

  my $Lw= $w/8;
  my $frame;

  if ($top->{Last_y} == $y)
  # if (exists ($top->{FramePos}->{$y}))
  {
    $frame= $top->{FramePos}->{$y};
    # print "re-use frame at y=$y\n";
  }
  else
  {
    $frame= $top->Frame ();
    $top->{FramePos}->{$y}= $frame;
    $top->{Last_y}= $y;                 # T2D: used for Multiple Pages
    # print "create frame at y=$y name=$name\n";
  }

  # $L= $frame->Label (-text => $name);
  my ($E, $L, %pack);
  my %packf= (-fill => 'x');      # packing of the enclosing frame
  if ($type eq 'WORDBOOL'
      || $type eq 'RADIO_BUTTON'  # T2D: Radio Buttons need to be mapped!
     )
  {
    $E= $frame->Checkbutton (-text => $name, -variable => $tv);
  }
  elsif ($type eq 'NOTE')
  {
    $L= $frame->Label (-text => $name);
    $E= $frame->Scrolled ('Text',
                          -width => $Lw, -height => $h/8,
                          -scrollbars => 'e');
    %pack= %packf= (-fill => 'both', -expand => 1);
  }
  elsif ($type eq 'GROUP' || $type eq 'STATIC')
  {
    $L= $frame->Label (-text => $name);
  }
  elsif ($type eq 'COMBO')
  {
    $E= $frame->Entry (-width => $Lw, -textvariable => $tv);
    print "combo field: y=$y\n";
    %pack= (-fill => 'x', -expand => 1);
  }
  else
  {
    $L= $frame->Label (-text => $name);
    $E= $frame->Entry (-width => $Lw, -textvariable => $tv);
    %pack= (-fill => 'x', -expand => 1);
  }
  
  if ($L)
  {
    $frame->{L}= $L;
    $L->pack (-side => 'left');
  }
  if ($E)
  {
    $frame->{E}= $E;
    $E->pack (-side => 'left', %pack);
  }

  $frame->pack (%packf);

  $frame;
}

# ----------------------------------------------------------------------------
sub add_record
{
  my $widget= shift;

  $widget->update_record ();
  &show_record ($widget, ++$widget->{num}, 0);
}

# ----------------------------------------------------------------------------
sub show_record
{
  my ($widget, $num, $whence)= @_;

  print ">>> disp= $widget->{disp}\n";
  $widget->update_record ();

  if ($whence == 2)     { $widget->{disp}= $widget->{num} - $num; }
  elsif ($whence == 1)  { $widget->{disp} += $num; }
  else                  { $widget->{disp}= $num; }

  $num= $widget->{disp};
  $num= $widget->{disp}= 1 if ($num < 1);
  $num= $widget->{disp}= $widget->{num} if ($num > $widget->{num});

  my $Fields= $widget->{Fields};
  my $db= $widget->{db};
  my $rec= $widget->{disp_rec}= $db->FETCH ($num-1);
  unless (defined ($rec))
  {
    print ">>> [$num] rec == undef\n";
    # initialize data record, let it fill in later
    $rec= $widget->{disp_rec}= {};
  }

  my ($f);
  foreach $f (keys %$Fields)
  {
    my $v= $rec->{$f};
    my $F= $Fields->{$f};

    my $type= $F->{Ftype};
    if ($type eq 'NOTE')
    {
      my $t= $F->{el}->{E};
      $v=~ s/\r//g;
      $t->delete (0.1, 'end');
      $t->insert ('end', $v);
      $F->{orig}= $v;
      # print ">>> fetch note size=", length ($v), "\n";
    }
    elsif ($type eq 'WORDBOOL' || $type eq 'RADIO_BUTTON')
    {
      my $flg= $F->{el}->{E};
print "boolean: n='$F->{name}' v='$v'\n";
      $F->{val}= $F->{orig}= ($v eq 'Y') ? 1 : 0;
    }
    else { $F->{val}= $F->{orig}= $v; }
  }

  if ($widget->{visibility} ne 'mapped')
  {
    my $top= $widget->{top};
    $top->raise ();
    $top->deiconify ();
    $widget->{visibility}= 'mapped';
  }
}

# ----------------------------------------------------------------------------
sub update_record
{
  my $widget= shift;
  my $rec= {};          # reference to record data, possibly cached

  print "update_record: 1\n";
  # nothing displayed yet ?
  return 0 unless (defined ($rec= $widget->{disp_rec}));
  my $disp= $widget->{disp};

  print "update_record: 2 disp= $disp\n";
  my $Fields= $widget->{Fields};
  my $db= $widget->{db};

  my ($f, $v);

  my $upd= 0;   # number of fields updated;
  foreach $f (keys %$Fields)
  {
    my $F= $Fields->{$f};
    my $orig= $F->{orig};

    if ($F->{Ftype} eq 'NOTE')
    {
      my $t= $F->{el}->{E};
      $v= $t->get (0.1, 'end');
      chop ($v); # somehow we pick up one extra character at the end...
      if ($v ne $orig)
      {
        print ">>>> updated note field\n";
        $upd++;
      }
      # print ">>> store note size=", length ($v), "\n";
      $v=~ s/\n/\r\n/g;
      # NOTE reocrds (HP only): re-insert \r at the end of line
      # print ">>> NOTE='$v'\n";
    }
    else
    {
      $v= $F->{val};
      # NOTE: this works fine also for storing WORD and BYTE-BOOL variables 
      if ($v ne $orig)
      {
        print ">>>> updated field\n";
        $upd++;
      }
    }

    $rec->{$f}= $v;
  }

  print ">>> upd=$upd\n";
  print ">>> widget=$widget ", join (',', sort keys %$widget), "\n";
  $db->STORE ($disp-1, $rec) if ($upd);
}

1;

