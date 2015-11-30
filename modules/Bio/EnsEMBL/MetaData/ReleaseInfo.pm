
=head1 LICENSE

Copyright [1999-2014] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

=pod

=head1 NAME

Bio::EnsEMBL::MetaData::ReleaseInfo

=head1 SYNOPSIS

	  my $release_info =
		Bio::EnsEMBL::MetaData::GenomeReleaseInfo->new(
								   -ENSEMBL_VERSION=>83,
								   -EG_VERSION=>30,
								   -DATE=>'2015-12-07');

=head1 DESCRIPTION

Object encapsulating information about a particular release of Ensembl or Ensembl Genomes

=head1 Author

Dan Staines

=cut

package Bio::EnsEMBL::MetaData::ReleaseInfo;
use base qw/Bio::EnsEMBL::MetaData::BaseInfo/;
use strict;
use warnings;

use Bio::EnsEMBL::Utils::Argument qw(rearrange);
use POSIX 'strftime';
use Bio::EnsEMBL::ApiVersion;

=head1 CONSTRUCTOR
=head2 new
  Arg [-ENSEMBL_VERSION]  : 
       int - Ensembl version (by default current version from API)
  Arg [-EG_VERSION]    : 
       int - optional Ensembl Genomes version
  Arg [-DATE] : 
       string - date of the release as YYYY-MM-DD

  Example    : $info = Bio::EnsEMBL::MetaData::ReleaseInfo->new(...);
  Description: Creates a new release info object
  Returntype : Bio::EnsEMBL::MetaData::ReleaseInfo
  Exceptions : none
  Caller     : general
  Status     : Stable

=cut
sub new {
	my ( $class, @args ) = @_;
	my $self = $class->SUPER::new(@args);
	( $self->{ensembl_version}, $self->{eg_version}, $self->{date} ) =
	  rearrange( [ 'ENSEMBL_VERSION', 'EG_VERSION', 'DATE' ], @args );
	$self->{ensembl_version} ||= software_version();
	$self->{date} ||= strftime '%Y-%m-%d', localtime;
	return $self;
}

=head1 ATTRIBUTE METHODS
=head2 ensembl_version
  Arg        : (optional) version to set
  Description: Gets/sets name Ensembl version
  Returntype : string
  Exceptions : none
  Caller     : general
  Status     : Stable
=cut

sub ensembl_version {
	my ( $self, $arg ) = @_;
	$self->{ensembl_version} = $arg if ( defined $arg );
	return $self->{ensembl_version};
}

=head2 eg_version
  Arg        : (optional) version to set
  Description: Gets/sets name Ensembl version
  Returntype : string
  Exceptions : none
  Caller     : general
  Status     : Stable
=cut

sub eg_version {
	my ( $self, $arg ) = @_;
	$self->{eg_version} = $arg if ( defined $arg );
	return $self->{eg_version};
}

=head2 date
  Arg        : (optional) version to set
  Description: Gets/sets name Ensembl version
  Returntype : string
  Exceptions : none
  Caller     : general
  Status     : Stable
=cut

sub date {
	my ( $self, $arg ) = @_;
	$self->{date} = $arg if ( defined $arg );
	return $self->{date};
}

=head2 to_hash
  Description: Render as plain hash suitable for export as JSON/XML
  Returntype : Hashref
  Exceptions : none
  Caller     : general
  Status     : Stable
=cut

sub to_hash {
	my ($in) = @_;
	return { ensembl_version => $in->ensembl_version(),
			 eg_version      => $in->eg_version(),
			 date            => $in->date(), };
}

sub to_string {
	my ($self) = @_;
	return
	  join( '/',
			$self->ensembl_version(), ($self->eg_version()||'-'), ( $self->date() ) );
}

=head1 INTERNAL METHODS
=head2 dbID
  Arg        : (optional) dbID to set set
  Description: Gets/sets internal release_id used as database primary key
  Returntype : dbID string
  Exceptions : none
  Caller     : Bio::EnsEMBL::MetaData::DBSQL::GenomeInfoAdaptor
  Status     : Stable
=cut

sub dbID {
	my ( $self, $arg ) = @_;
	if ( defined $arg ) {
		$self->{dbID} = $arg;
	}
	return $self->{dbID};
}

=head2 adaptor
  Arg        : (optional) adaptor to set set
  Description: Gets/sets GenomeInfoAdaptor
  Returntype : Bio::EnsEMBL::MetaData::DBSQL::GenomeInfoAdaptor
  Exceptions : none
  Caller     : Internal
  Status     : Stable
=cut

sub adaptor {
	my ( $self, $arg ) = @_;
	if ( defined $arg ) {
		$self->{adaptor} = $arg;
	}
	return $self->{adaptor};
}

1;