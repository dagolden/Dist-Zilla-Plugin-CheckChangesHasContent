use strict;
use warnings;
package Dist::Zilla::Plugin::CheckChangesHasContent;
# ABSTRACT: Ensure Changes has content before releasing

# Dependencies
use Dist::Zilla 2.100950 (); # XXX really the next release after this date
use autodie 2.00;
use File::pushd 0 ();
use Moose 0.99;
use namespace::autoclean 0.09;

# extends, roles, attributes, etc.

with 'Dist::Zilla::Role::BeforeRelease';

has changelog => ( 
  is => 'ro', 
  isa => 'Str',
  default => 'Changes' 
);

# methods

sub before_release {
  my $self = shift;
  my $changes_file = $self->changelog;
  my $newver = $self->zilla->version;

  $self->zilla->ensure_built_in;
  
  # chdir in
  my $wd = File::pushd::pushd($self->zilla->built_in);

  # Must have Changes file
  -e $changes_file or $self->log_fatal("No $changes_file found");

  # Changes must have content
  $self->_get_changes 
    or $self->log_fatal("$changes_file has no content for $newver");

  return;
}

# _get_changes copied and adapted from Dist::Zilla::Plugin::Git::Commit
# by Jerome Quelin
sub _get_changes {
    my $self = shift;

    # parse changelog to find commit message
    my $changelog = Dist::Zilla::File::OnDisk->new( { name => $self->changelog } );
    my $newver    = $self->zilla->version;
    my @content   =
        grep { /^$newver\s+/ ... /^\S/ } # from newver to un-indented
        split /\n/, $changelog->content;
    shift @content; # drop the version line
    # drop unindented last line and trailing blank lines
    pop @content while ( @content && $content[-1] =~ /^(?:\S|\s*$)/ );

    # return number of non-blank lines
    return scalar @content;
} # end _get_changes

__PACKAGE__->meta->make_immutable;

1;

__END__

=for Pod::Coverage before_release

=begin wikidoc

= SYNOPSIS

  use Dist::Zilla::Plugin::CheckChangesHasContent;

= DESCRIPTION

This module might be cool, but you'd never know it from the lack
of documentation.

= USAGE

Good luck!

= SEE ALSO

Maybe other modules do related things.

=end wikidoc

=cut

