#!/usr/bin/perl
#
# Splits a chronologically ordered mbox file into per-year archives.
#
# USAGE: mboxsplit.pl foo.mbox
#     -> will create 2013.mbox.tmp, 2014.mbox.tmp, etc.
#
# Messages are delimited by ^From lines like this:
# From foo@bar.com  Wed Jan  6 11:55:35 2010
#

use Data::Dumper qw(Dumper);

$rx = qr/^From .* (\d{4})$/o;

$curyear = 1900;
$printing = 0;
%msgs = (); # map year -> #msgs
while (<>) {
    if ($_ =~ $rx) {
        if ($1 != $curyear) {
            $curyear = $1;
            close(FN); # if (tell(FN) != -1); # close FN if already open
            open(FN, ">$curyear.mbox.tmp");
            $printing = 1;
            $dline = $_; chomp $dline;
            print STDERR "Found $curyear [$dline] at line $.\n";
        }
        ++$msgs{$curyear};
    }
    if ($printing) { print FN $_; }
}
close(FN);
print Dumper(\%msgs);
