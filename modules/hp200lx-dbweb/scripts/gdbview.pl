#!/usr/local/bin/perl
# FILE .../hp200lx-dbweb/scripts/gdbview.pl
#
# written:       2001-10-04
# latest update: 2001-10-04 20:10:52
# $Id: gdbview.pl,v 1.1 2002/03/28 09:11:23 gonter Exp $
#

use strict;
use lib '/usr/local/www/cgi-bin';
use CGI;
use HP200LX::DB;
use HP200LX::DBweb;

my $CGI= new CGI;

my $db_name= $CGI->param ('db');
my $title= "gdbview: $db_name\n";

print $CGI->header,
  $CGI->start_html ($title),
  $CGI->end_html;

my $show= $CGI->param ('show') || 'main';
$db_name= '/www/'. $db_name;

if ($show eq 'main')
{
  &show_main ($CGI, $db_name) if ($db_name);
}
elsif ($show eq 'card')
{
}
elsif ($show eq 'list')
{
}
else
{
}

exit (0);

sub show_main
{
  my $CGI= shift;
  my $db_name= shift;

  print "file exists\n" if (-f $db_name);
  my $db= HP200LX::DB::openDB ($db_name);
  print "<pre>";
  &print_db_def ($db, *STDOUT);
  print "</pre>";
  &print_db_def_html ($db, *STDOUT);
}

__END__
print "libs: ", join (', ', @INC), "\n";

print "names: ", join (', ', $CGI->param()), "\n";
