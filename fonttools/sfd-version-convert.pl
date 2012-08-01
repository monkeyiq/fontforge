#!/usr/bin/perl

use Getopt::Long;
use Pod::Usage;

my $outversion = 0;

GetOptions ("outputversion=f" => \$outversion ) or pod2usage(2);
if( $outversion == 0 ) 
{
    pod2usage(1);
    die;
}

$ifilename = shift;
if( $ifilename eq "" ) { $ifilename = "-"; }
#print $ifilename;

$ignore = 0;
$endtok = "";
open INFILE, $ifilename or die "Can't open input file $ifilename";
while( <INFILE> ) 
{
    if( /^SplineFontDB/ ) {
	print "SplineFontDB: " . $outversion . "\n";
	next;
    }
    if( /^UndoRedoHistory/ ) {
	$ignore = 1;
	$endtok = "^EndUndoRedoHistory";
    }
    if( $endtok ne "" && /$endtok/ ) {
	$ignore = 0;
	next;
    }

    if( $ignore == 0 ) 
    {
	$line = $_;
	print $line;
    }
}

__END__

=head1 NAME

    sfd-version-convert.pl - Convert an SFD file to an older version if possible
 
=head1 SYNOPSIS

    sfd-version-convert.pl [options] [file ...]

     Options:
       -outputversion N.N  :  which version of SFD to create

=head1 OPTIONS

=over 8

=item B<-outputversion>

    Which version you would like to create (currently only 3.0 supported).
    Reading a version 3.1 SFD file to a version 3.0 will:
    * Remove blocks that contain undo information.

=back

=head1 DESCRIPTION

    B<This program> will try to convert an SFD file to a specific older version

=cut
