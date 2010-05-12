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

  $self->log("Checking Changes");

  $self->zilla->ensure_built_in;

  # chdir in
  my $wd = File::pushd::pushd($self->zilla->built_in);

  if ( ! -e $changes_file ) {
    $self->log_fatal("No $changes_file file found");
  }
  elsif ( $self->_get_changes ) {
    $self->log("$changes_file OK");
  }
  else {
    $self->log_fatal("$changes_file has no content for $newver");
  }

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

  # in dist.ini

  [CheckChangesHasContent]

= DESCRIPTION

This is a "before release" Dist::Zilla plugin that ensures that your Changes
file actually has some content since the last release.  If it doesn't find any,
it will abort the release process.

The algorithm is very naive.  It looks for an unindented line starting with
the version to be released.  It then looks for any text from that line until
the next unindented line (or the end of the file), ignoring whitespace.

For example, in the file below, algorithm will find "- blah blah blah":

  Changes file for Foo-Bar

  {{$NEXT}}

    - blah blah blah

  0.001  Wed May 12 13:49:13 EDT 2010

    - the first release

If you had nothing but whitespace between { {{$NEXT}} } and { 0.001 },
the release would be halted.

If you name your change log something other than "Changes", you can configure
the name with the {changelog} argument:

  [CheckChangesHasContent]
  changelog = ChangeLog

= SEE ALSO

* [Dist::Zilla]

=end wikidoc

=cut

