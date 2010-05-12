#!perl

use strict;
use warnings;

use Capture::Tiny qw/capture/;
use Dist::Zilla::Tester;
use Test::More 0.88; END { done_testing }
use Try::Tiny;

## Tests start here

{
  my $tzil;
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

{
  my $tzil;
  try {
    $tzil = Dist::Zilla::Tester->from_config(
      { dist_root => 'corpus/DZ' },
      {
        add_files => {
          'source/Changes' => <<'END',
Changes

{{$NEXT}}

END
        },
      },
    );
    ok( $tzil, "created test dist with stub Changes file");

    capture { $tzil->release };
  } catch {
    my $err = $_;
    like(
      $err,
      qr/Changes has no content for 1\.23/i,
      "saw empty Changes warning",
    );
    ok(
      ! grep({ /fake release happen/i } @{ $tzil->log_messages }),
      "FakeRelease did not happen",
    );
  }
}

{
  my $tzil;
  try {
    $tzil = Dist::Zilla::Tester->from_config(
      { dist_root => 'corpus/DZ' },
      {
        add_files => {
          'source/Changes' => <<'END',
Changes

{{$NEXT}}

1.22    2010-05-12 00:33:53 EST5EDT

  - not really released

END
        },
      },
    );
    ok( $tzil, "created test dist with no new Changes");

    capture { $tzil->release };
  } catch {
    my $err = $_;
    like(
      $err,
      qr/Changes has no content for 1\.23/i,
      "saw empty Changes warning",
    );
    ok(
      ! grep({ /fake release happen/i } @{ $tzil->log_messages }),
      "FakeRelease did not happen",
    );
  }
}


{
  my $tzil;
  try {
    $tzil = Dist::Zilla::Tester->from_config(
      { dist_root => 'corpus/DZ' },
      {
        add_files => {
          'source/Changes' => <<'END',
Changes

{{$NEXT}}

  - this is a change note, I promise

1.22    2010-05-12 00:33:53 EST5EDT

  - not really released

END
        },
      },
    );
    ok( $tzil, "created test dist with a new Changes entry");

    capture { $tzil->release };
  } catch {
    fail ("Caught an error") and diag $_;
  };

  ok(
    grep({ /Changes OK/i } @{ $tzil->log_messages }),
    "Saw Changes OK message",
  );
  ok(
    grep({ /fake release happen/i } @{ $tzil->log_messages }),
    "FakeRelease happened",
  );
}
