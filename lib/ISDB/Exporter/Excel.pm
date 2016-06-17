use 5.010;
use strict;
use warnings;
use utf8;

package ISDB::Exporter::Excel;
use Moo;
use Types::Standard qw< :types >;
use Excel::Writer::XLSX;
use Archive::Zip qw< AZ_OK >;
use namespace::clean;

use constant BOGUS_TIMESTAMP => 556387200; # 1987-08-19 12:00:00 US/Eastern

has _excel => (
    is      => 'lazy',
    isa     => InstanceOf['Excel::Writer::XLSX'],
    builder => sub {
        my $self  = shift;
        my $excel = Excel::Writer::XLSX->new( $self->filename->stringify )
            or die "Excel::Writer::XLSX->new failed: $!";
        return $excel;
    },
);

has _worksheet => (
    is      => 'lazy',
    isa     => Object,
    builder => sub {
        my $self = shift;
        return $self->_excel->add_worksheet( $self->basename );
    },
);

has _row => (
    is      => 'rw',
    isa     => Int,
    default => 0,
);

has extension => (
    is      => 'ro',
    isa     => Str,
    default => 'xlsx',
);

with 'ISDB::Exporter::Formatter',
     'ISDB::Exporter::Formatter::FormatValue';

sub BUILD {
    my $self = shift;
    $self->_excel->set_properties(
        # Set a bogus creation time for the workbook so the message digest of
        # the file remains stable with the contents/formatting.  This isn't
        # (currently) documented as supported by Excel::Writer::XLSX, but the
        # source code explicitly supports it.  I've submitted a doc patch
        # upstream.
        # -trs, 16 June 2016
        created  => [ gmtime( BOGUS_TIMESTAMP ) ],
        comments => 'Generated by ' . __PACKAGE__,
    );
}

sub write_header {
    my ($self, $fields) = @_;
    $self->_write_row( $fields );
}

sub write_row {
    my ($self, $fields, $row) = @_;
    $self->_write_row( [ map { $self->format_value($_) } @$row{ @$fields } ]);
}

sub _write_row {
    my ($self, $data) = @_;

    # ->write_row() uses ->write() which discerns the Excel cell type from the
    # data for the cell.  The heuristics¹ are safe for our data, at least for
    # now, because it doesn't try to guess dates.²  Dates are the worst
    # offending heuristics in Excel itself, turning string values like SEPT9
    # into a date by default.  Writing all cells as text isn't useful since the
    # numbers we output would then be uncomputable within Excel without first
    # changing the cell type back to numeric for those columns.
    # -trs, 15 June 2016
    #
    # ¹ https://metacpan.org/pod/Excel::Writer::XLSX#write-row-column-token-format
    # ² https://metacpan.org/pod/Excel::Writer::XLSX#Excel::Writer::XLSX-doesnt-automatically-convert-date-time-strings
    $self->_worksheet->write_row($self->_row, 0, $data);
    $self->_row( $self->_row + 1 );
}

sub write_footer { }

sub DESTROY {
    my $self = shift;

    # Ensure that the Excel writer gets to close up shop in the order it needs
    # rather than the order of the garbage collector.
    $self->_excel->close
        or die "Error closing Excel file: $!";

    # XXX TODO: Remove this and bump the Excel::Writer::XLSX dep version
    # if/when my upstream patch to do the same ever gets released:
    #   https://github.com/jmcnamara/excel-writer-xlsx/pull/166
    # -trs, 16 June 2016
    #
    # Set last modification times and file permissions to static values inside
    # the zip file so the file's digest remains stable modulo content changes.
    my $zip = Archive::Zip->new;
    $zip->read( $self->filename->stringify ) == AZ_OK
        or die "Error reading zipfile: $!";

    for my $member ($zip->members) {
        $member->setLastModFileDateTimeFromUnix( BOGUS_TIMESTAMP );
        $member->unixFileAttributes( 0644 );
    }

    $zip->overwrite == AZ_OK
        or die "Error updating zipfile: $!";
}

1;
