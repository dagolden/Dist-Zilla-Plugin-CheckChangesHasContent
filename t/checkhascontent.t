#!perl

use strict;
use warnings;

use Capture::Tiny qw/capture/;
use Dist::Zilla::Tester;
use Test::More 0.88;
use Try::Tiny;

## Tests start here

{
  my ($tzil, $stdout, $stderr);
  try {
    $tzil = Dist::Zilla::Tester->from_config(
      { dist_root => 'corpus/DZ' },
    );
    ok( $tzil, "created test dist with no Changes file");

    capture { $tzil->release };
  } catch {
    my $err = $_;
    like(
      $err,
      qr/No Changes file found/i,
      "saw missing Changes file warning",
    );
    ok(
      ! grep({ /fake release happen/i } @{ $tzil->log_messages }),
      "FakeRelease did not happen",
    );
  }
}

#{
#  my $tzil = Dist::Zilla::Tester->from_config(
#    { dist_root => 'corpus/DZ' },
#    {
#      add_files => {
#        'source/xt/checkme.t' => $xt_pass,
#      },
#    },
#  );
#  ok( $tzil, "created test dist that will pass xt tests");
#
#  capture { $tzil->release };
#
#  ok(
#    ! grep({ /Fatal errors in xt/i } @{ $tzil->log_messages }),
#    "No xt errors logged",
#  );
#  ok(
#    grep({ /fake release happen/i } @{ $tzil->log_messages }),
#    "FakeRelease executed",
#  );
#
#}

done_testing;

