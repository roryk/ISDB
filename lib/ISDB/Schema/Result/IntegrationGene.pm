use utf8;
package ISDB::Schema::Result::IntegrationGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ISDB::Schema::Result::IntegrationGene

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<ISDB::Schema::InflateColumn::JSON>

=item * L<ISDB::Schema::SerializableAsJSON>

=back

=cut

__PACKAGE__->load_components(
  "+ISDB::Schema::InflateColumn::JSON",
  "+ISDB::Schema::SerializableAsJSON",
);
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<integration_genes>

=cut

__PACKAGE__->table("integration_genes");

=head1 ACCESSORS

=head2 source_name

  accessor: 'source'
  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 environment

  data_type: 'integration_environment'
  is_nullable: 1

=head2 sample

  data_type: 'jsonb'
  is_nullable: 1

=head2 ltr

  data_type: 'ltr_end'
  is_nullable: 1

=head2 landmark

  data_type: 'landmark'
  is_nullable: 1

=head2 location

  data_type: 'integer'
  is_nullable: 1

=head2 orientation_in_landmark

  data_type: 'orientation'
  is_nullable: 1

=head2 sequence

  accessor: 'seq'
  data_type: 'text'
  is_nullable: 1

=head2 sequence_junction

  data_type: 'integer'
  is_nullable: 1

=head2 note

  data_type: 'text'
  is_nullable: 1

=head2 info

  data_type: 'jsonb'
  is_nullable: 1

=head2 ncbi_gene_id

  data_type: 'integer'
  is_nullable: 1

=head2 gene

  data_type: 'text'
  is_nullable: 1

=head2 gene_type

  data_type: 'gene_type'
  is_nullable: 1

=head2 orientation_in_gene

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "source_name",
  { accessor => "source", data_type => "varchar", is_nullable => 1, size => 255 },
  "environment",
  { data_type => "integration_environment", is_nullable => 1 },
  "sample",
  { data_type => "jsonb", is_nullable => 1 },
  "ltr",
  { data_type => "ltr_end", is_nullable => 1 },
  "landmark",
  { data_type => "landmark", is_nullable => 1 },
  "location",
  { data_type => "integer", is_nullable => 1 },
  "orientation_in_landmark",
  { data_type => "orientation", is_nullable => 1 },
  "sequence",
  { accessor => "seq", data_type => "text", is_nullable => 1 },
  "sequence_junction",
  { data_type => "integer", is_nullable => 1 },
  "note",
  { data_type => "text", is_nullable => 1 },
  "info",
  { data_type => "jsonb", is_nullable => 1 },
  "ncbi_gene_id",
  { data_type => "integer", is_nullable => 1 },
  "gene",
  { data_type => "text", is_nullable => 1 },
  "gene_type",
  { data_type => "gene_type", is_nullable => 1 },
  "orientation_in_gene",
  { data_type => "text", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2017-03-21 10:59:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UTYfl7vZ/2x11A0431CuHw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
