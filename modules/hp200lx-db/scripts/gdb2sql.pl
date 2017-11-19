#!/usr/bin/perl 
# Author: Vaclav Stepan, w@linux.fjfi.cvut.cz
# Code heavily based on the catgdb.pl and DB.pm scripts
# 2002-03-11
# $Id: gdb2sql.pl,v 1.2 2002/03/28 09:39:03 gonter Exp $

use HP200LX::DB;
use HP200LX::DB::tools;
use HP200LX::DB::diag;

my $pdef = 0;
my $pgdb = 0;

ARGUMENT: while (defined ($arg= shift (@ARGV)))
{
  if ($arg =~ /^-/)
  {
    if ($arg eq '-')            { push (@JOBS, $arg);   }
    elsif ($arg =~ /^-dbdef/)   { $pdef=1;              }
    elsif ($arg =~ /^-dump/)    { $pgdb=1;              }
    else
    {
      &usage;
      exit (0);
    }
    next;
  }

  push (@JOBS, $arg);
}

foreach $job (@JOBS) 
{
  &process ($job); 
}

# cleanup

exit (0);

# ----------------------------------------------------------------------------
sub usage
{
  print <<END_OF_USAGE
Usage: $0 [-options] [filename]

Dumps DROP/CREATE or INSERT commands appropriate for exporting 
a HP 200LX .gdb database into a PostgreSQL RDBMS engine. 

Module Version: $HP200LX::DB::VERSION

Options:
-help                   ... print help
-dbdef                  ... dump database definition
-dump                   ... dump everything in printable form

Example:
  To import books.gdb into default database try
  
     $0 -dbdef -dump books.gdb | psql 

$ID
END_OF_USAGE
}

# ----------------------------------------------------------------------------
sub process {
   my $fnm = shift ;
   my $db= HP200LX::DB::openDB ($fnm);

   my $table_name;
   my $path;

   ($path,$table_name) = $fnm =~ /(.*\/)*(\w+)\.\w+/;

   &print_create_def_sql($db,$table_name) if $pdef;
   &print_gdb_sql($db,$table_name) if $pgdb;
}

# ----------------------------------------------------------------------------
sub print_gdb_sql
{
  my $db = shift;
  my $table_name = shift;
  # It is like CSV format, but PostgreSQL uses ',' as FS
  $FS= "','"; 
  $RStart= "INSERT INTO $table_name VALUES ('", 
  $RS= "');\n"; 
  
  my $view= '';  # retrieve a view description

  my (@data, $i);
  my @show;                     # field names in the order used for display
  my $i;
  my $field;
  my $x_name;

  # Get number of records 
  my $db_cnt= $db->get_last_index ();

  # tie the @data array to the $db database 
  tie (@data, HP200LX::DB, $db);

  # Read the field definition
  my $Fdef= $db->{'fielddef'}; 
  foreach $fdef (@$Fdef)
  {
    if ($fdef->{'ftype'}<11)
    {
       if ($x_name= $fdef->{name})
       {
# Erases diacritics
#          $x_name=~ s/[\x80-\xFF]/?/g;
          push (@show, $x_name);
       }
    }
  }

  # Now @show contains fields in the display order
  # print STDERR @show; 
 
  # for each record
  for ($i= 0; $i <= $db_cnt; $i++)
  {
    # Read the current record into $rec
    my $rec= $data[$i];
    foreach $field (@show) 
    {
       $rec->{$field} =~ s/\r\n/\<P>/g;
       $rec->{$field} =~ s/'/"/g; 
    } 
 
    my $fld = $RStart.join($FS, map { $rec->{$_} } @show).$RS;
    # Change '' to NULLs as PostgreSQL doesn't like '' for date
    # and boolean types
    $fld =~ s/''/NULL/g;
    print $fld;
  }
}

# ----------------------------------------------------------------------------
sub print_create_def_sql {
   my $db = shift;
   my $table_name = shift;
   my $Fdef= $db->{'fielddef'};
   my $fdef;
   my $num= 0;

   print "DROP TABLE $table_name;\nCREATE TABLE $table_name (\n";
   foreach $fdef (@$Fdef)
   {
      my $type= $fdef->{'ftype'};
      my $ftype= &get_field_type ($type);
      my $ttype= $ftype->{Desc} || "USER$type";
      my $x_name= $fdef->{name};
# Erases diacritics
#      $x_name=~ s/[\x80-\xFF]/?/g;

      if ($type<11)
      {
         if ($num>0)
         {
            print ",\n"
         }
         print "\t\"$x_name\" $ttype" if ($type<11);
      }
      $num++;
   }
   print "\n);\n\n";
}
