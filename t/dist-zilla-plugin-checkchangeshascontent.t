use strict;
use warnings;

use Test::More 0.88; END { done_testing }
use Test::Exception 0.29;

# Work around buffering that can show diags out of order
Test::More->builder->failure_output(*STDOUT) if $ENV{HARNESS_VERBOSE};

my ($obj);
require_ok( 'Dist::Zilla::Plugin::CheckChangesHasContent' );
$obj = new_ok( 'Dist::Zilla::Plugin::CheckChangesHasContent' ); # add \@args, if needed

