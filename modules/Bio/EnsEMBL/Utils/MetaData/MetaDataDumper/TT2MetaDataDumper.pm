
=pod
=head1 LICENSE

  Copyright (c) 1999-2011 The European Bioinformatics Institute and
  Genome Research Limited.  All rights reserved.

  This software is distributed under a modified Apache license.
  For license details, please see

    http://www.ensembl.org/info/about/code_licence.html

=head1 CONTACT

  Please email comments or questions to the public Ensembl
  developers list at <dev@ensembl.org>.

  Questions may also be sent to the Ensembl help desk at
  <helpdesk@ensembl.org>.
 
=cut

package Bio::EnsEMBL::Utils::MetaData::MetaDataDumper::TT2MetaDataDumper;
use base qw( Bio::EnsEMBL::Utils::MetaData::MetaDataDumper );
use Bio::EnsEMBL::Utils::Argument qw(rearrange);
use Carp;
use XML::Simple;
use strict;
use warnings;

sub new {
  my ($proto, @args) = @_;
  my $self = $proto->SUPER::new(@args);
  $self->{file} ||= 'species.tt2';
  $self->{division} ||= 0;
  $self->{div_links} = {EnsemblBacteria => "http://bacteria.ensembl.org/",
						EnsemblFungi    => "http://fungi.ensembl.org/",
						EnsemblMetazoa  => "http://metazoa.ensembl.org/",
						EnsemblProtists => "http://protists.ensembl.org/",
						EnsemblPlants   => "http://plants.ensembl.org/"};

  return $self;
}

sub do_dump {
  my ($self, $metadata, $outfile) = @_;
  my $td  = '<td>';
  my $tdx = '</td>';
  my $tr  = '<td>';
  my $trx = '</td>';
  open(my $tt2_file, '>', $outfile)
	|| croak "Could not write to " . $outfile;
  print $tt2_file join('<table><tr>', '<th>Species</th>', '<th>Division</th>', '<th>Taxonomy ID</th>', '<th>Assembly</th>', '<th>Genebuild</th>', '<th>Variation</th>', '<th>Pan compara</th>', '<th>Genome alignments</th>', '<th>Other alignments</th>', '</tr>', "\n");

  for my $md (@{$metadata->{genome}}) {
	my $div_link = $self->{div_links}->{$md->{division}};
	if (!defined $div_link) {
	  croak "No division defined for $md->{name}";
	}
	$div_link .= $md->{species};
	my $line = join($tr, $td, "<a href='${div_link}'>", $md->{name}, '</a>', $tdx, $td, "<a href='", $div_link, "'>", $md->{division}, '</a>', $td, $md->{taxonomy_id}, $tdx, $td, $md->{assembly_name}, $tdx, $td, $md->{genebuild}, $tdx, $td, $self->yesno($self->count_variation($md)), $tdx, $td, $self->yesno($md->{pan_compara}), $tdx, $td, $self->yesno($self->count_dna_compara($md)), $tdx, $td, $self->yesno($self->count_alignments($md)), $tdx, $trx, "\n");
	print $tt2_file $line;
  }
  print $tt2_file '</table></div>';
  close $tt2_file;
  return;
}

1;

__END__

=pod

=head1 NAME

Bio::EnsEMBL::Utils::MetaData::MetaDataDumper::XMLMetaDataDumper

=head1 SYNOPSIS

=head1 DESCRIPTION

implementation to dump metadata details to an XML file

=head1 SUBROUTINES/METHODS

=head2 new

=head2 dump_metadata
Description : Dump metadata to the file supplied by the constructor 
Argument : Hash of details

=head1 AUTHOR

dstaines

=head1 MAINTAINER

$Author$

=head1 VERSION

$Revision$

=cut
