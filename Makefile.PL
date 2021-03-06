use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.17;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Ensure Changes has content before releasing",
  "AUTHOR" => "David Golden <dagolden\@cpan.org>, Karen Etheridge <ether\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.17"
  },
  "DISTNAME" => "Dist-Zilla-Plugin-CheckChangesHasContent",
  "LICENSE" => "apache",
  "MIN_PERL_VERSION" => "5.006",
  "NAME" => "Dist::Zilla::Plugin::CheckChangesHasContent",
  "PREREQ_PM" => {
    "Data::Section" => "0.200002",
    "Dist::Zilla" => 6,
    "Dist::Zilla::File::InMemory" => 0,
    "Dist::Zilla::Role::BeforeRelease" => 0,
    "Dist::Zilla::Role::FileGatherer" => 0,
    "Dist::Zilla::Role::FileMunger" => 0,
    "Dist::Zilla::Role::TextTemplate" => 0,
    "List::Util" => 0,
    "Moose" => 2,
    "Moose::Util::TypeConstraints" => 0,
    "Sub::Exporter::ForMethods" => 0,
    "autodie" => "2.00",
    "namespace::autoclean" => "0.28",
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Capture::Tiny" => 0,
    "Cwd" => 0,
    "Dist::Zilla::Tester" => 0,
    "ExtUtils::MakeMaker" => 0,
    "File::Spec" => 0,
    "Path::Tiny" => 0,
    "Test::Fatal" => 0,
    "Test::Harness" => 0,
    "Test::More" => "0.88"
  },
  "VERSION" => "0.012",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Capture::Tiny" => 0,
  "Cwd" => 0,
  "Data::Section" => "0.200002",
  "Dist::Zilla" => 6,
  "Dist::Zilla::File::InMemory" => 0,
  "Dist::Zilla::Role::BeforeRelease" => 0,
  "Dist::Zilla::Role::FileGatherer" => 0,
  "Dist::Zilla::Role::FileMunger" => 0,
  "Dist::Zilla::Role::TextTemplate" => 0,
  "Dist::Zilla::Tester" => 0,
  "ExtUtils::MakeMaker" => 0,
  "File::Spec" => 0,
  "List::Util" => 0,
  "Moose" => 2,
  "Moose::Util::TypeConstraints" => 0,
  "Path::Tiny" => 0,
  "Sub::Exporter::ForMethods" => 0,
  "Test::Fatal" => 0,
  "Test::Harness" => 0,
  "Test::More" => "0.88",
  "autodie" => "2.00",
  "namespace::autoclean" => "0.28",
  "strict" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
