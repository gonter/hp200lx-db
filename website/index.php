<?php
// Default Web Page for groups that haven't setup their page yet
// Please replace this file with your own website
//
// $Id: index.php,v 1.5 2001/04/01 14:37:31 gonter Exp $
//
$headers = getallheaders();
?>
<HTML>
<HEAD>
<TITLE>SourceForge: Welcome</TITLE>
<LINK rel="stylesheet" href="http://sourceforge.net/sourceforge.css" type="text/css">
</HEAD>

<BODY bgcolor=#abcdef topmargin="0" bottommargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0">

<!-- top strip -->
<TABLE width="100%" border=0 cellspacing=0 cellpadding=2 bgcolor="737b9c">
  <TR>
    <TD><SPAN class=maintitlebar>&nbsp;&nbsp;
      <A class=maintitlebar href="http://sourceforge.net/"><B>Home</B></A> | 
      <A class=maintitlebar href="http://sourceforge.net/about.php"><B>About</B></A> | 
      <A class=maintitlebar href="http://sourceforge.net/partners.php"><B>Partners</B></a> |
      <A class=maintitlebar href="http://sourceforge.net/contact.php"><B>Contact Us</B></A></SPAN></TD>
    </TD>
  </TR>
</TABLE>
<!-- end top strip -->

<!-- top title table -->
<TABLE width="100%" border=0 cellspacing=0 cellpadding=0 bgcolor="" valign="center">
  <TR valign="top" bgcolor="#eeeef8">
    <TD>
      <A href="http://sourceforge.net/"><IMG src="http://sourceforge.net/images/sflogo2-steel.png" vspace="0" border=0 width="143" height="70"></A>
    </TD>
    <TD width="99%"><!-- right of logo -->
      <a href="http://www.valinux.com"><IMG src="http://sourceforge.net/images/valogo3.png" align="right" alt="VA Linux Systems" hspace="5" vspace="0" border=0 width="117" height="70"></A>
    </TD><!-- right of logo -->
  </TR>
  <TR><TD bgcolor="#543a48" colspan=2><IMG src="http://sourceforge.net/images/blank.gif" height=2 vspace=0></TD></TR>
</TABLE>
<!-- end top title table -->

<!-- center table -->
<TABLE width="100%" border="0" cellspacing="0" cellpadding="2" bgcolor="#FFFFFF" align="center">
  <TR>
    <TD>
      <BR>
      <CENTER><H1>Welcome to http://<?php print $headers[Host]; ?>/</H1></CENTER>
<!-- BEGIN body text ZZZ -->
<p>hp200lx-db is a Perl module, or rather a collection of such modules, which are used
to access the HP 200LX[1]'s database files.  It currently supports GDB, NDB, PDB and
to some extent also ADB and WDB files.  These files are used by the PIM applications
of this fine PDA.  The Perl modules can also be found on CPAN, they use
the <a href="http://www.cpan.org/modules/by-module/HP200LX/">HP200LX::</a> name space.</p>

<p>The project's overview page is on
<A href="http://sourceforge.net/projects/hp200lx-db/">http://sourceforge.net/projects/hp200lx-db/</a></p>
<p>A few <a href="docs/">documents</a> describe the file formats and the releases.</p>

<h2>Structure and Future Plans</h2>
hp200lx-db contains two module groups and a number of scripts:
<ol>
<li> DB access modules
<li> Perl/Tk user interface for X11 and possibly wherever else Tk runs these days;<br>
     TASK: These modules and their scripts need to be re-packaged in a separate module.
</ol>

Further development depends on user demand and may include:
<ul>
<li> something to sync data with "real" databases such as
     <a href="http://www.postgresql.org/">PostgreSQL</a> or
     <a href="http://www.mysql.org/">MySQL</a>.
<li> integration with other PIM applications [does anybody know one for Unix?].
<li> something to integrate the whole thing with a decent web interface.
<li> integration with the <a href="http://sourceforge.net/projects/lxtools-ng/">
     LX Tools</a> for backup.
</ul>

<h2>Related Projects</h2>
This PDA has been discontinued by HP in November 1999, just before any Y2K
related inconveniences could affect the owners.  The Y2K bug didn't cause any
major usability problem, so the versatile machine has still many dedicated 
fans and support from userland is still enormous.  Here are just a few
links to continuing projects:
<ul>
<li><a href="http://www.palmtop.net/">www.palmtop.net</a>:Central hub for all HP-LX
    users.
<li><a href="http://www.sp.uconn.edu/~mchem1/HPLX.shtml">HPLX-L</a>:
    The mailing list for the user community.  As a proud owner of a
    HP-LX you're either already subscribed or for some strange reason
    you didn't know it exists!
<li><a href="http://sourceforge.net/projects/lxtools-ng/">LX Tool</a>:
    file transfer for Un*x
<li><a href="http://sourceforge.net/projects/hplxdb-win32sdk/">HPLX Database Win32 SDK</a>:
    This project's goal is to provide a Basci API for the databases.
    Note: Our Perl modules should run on Window too.  Maybe someone wants to
    try an OLE thing?
<li><a href="http://sourceforge.net/search/?type_of_search=soft&words=200lx">Projects
    on Sourceforge</a>: There are several other projects related to the venerable
    HP-LX palmtops hosted by Sorceforge.  Thanks for hosting our projects!
<li><a href="http://members.aol.com/FreeWhL44/lxgames.html">Curtis Cameron</a>:
    Several programs to verify database integrity and for Outlook
    synchronization.
<li><a href="http://sitescooper.cx/">Sitescooper</a>:
    used for automatic downloads from the web; downloaded items could be
    transfered to DBs.
</ul>

<h2>References</h2>
<ol>
<li>From the FAQ: <a href="http://www.hplx.net/faq.faq.html#04">What are these HP Palmtops, anyway?</a>
</ol>
<hr>
$Id: index.php,v 1.5 2001/04/01 14:37:31 gonter Exp $
<!-- END body text ZZZ -->
    </TD>
  </TR>
</TABLE>
<!-- end center table -->

<!-- footer table -->
<TABLE width="100%" border="0" cellspacing="0" cellpadding="2" bgcolor="737b9c">
  <TR>
    <TD align="center"><FONT color="#ffffff"><SPAN class="titlebar">
      All trademarks and copyrights on this page are properties of their respective owners. Forum comments are owned by the poster. The rest is copyright ©1999-2000 VA Linux Systems, Inc.</SPAN></FONT>
    </TD>
  </TR>
</TABLE>

<!-- end footer table -->
</BODY>
</HTML>
