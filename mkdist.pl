#!/usr/bin/perl
# 11.11.1999, Sampo Kellomaki <sampo@iki.fi>
#
# Build a distribution or backup tarball. Files to include are
# described in file MANIFEST (or other file specified with -m option).
# If no version is specified, current timestamp is used. Maintains
# file called Version with history of invocations of mkdist.pl

use filex;

$manifest = 'MANIFEST';
if ($ARGV[0] eq '-m') {
    shift;
    $manifest = shift;
}

if ($ARGV[0] eq '-f') {
    $force = shift;
}

if ($ARGV[0] eq '-s') {
    shift;
    $sign_passwd = shift;  # on single user machine only!
}

($name,$version) = @ARGV;
die "Usage: ./mkdist.pl [-m MANIFEST] [-s sign_pw] smime 0.2\n" unless $name;

($ss, $mm, $hh, $dd, $mon, $yy) = gmtime;
$yyyymmddhhmmss = sprintf "%04d%02d%02d%02d%02d%02d",
    $yy+1900, $mon+1, $dd, $hh, $mm, $ss;

$version = $yyyymmddhhmmss unless $version;

$dist = "$name-$version";
if (-f "$dist.tgz") {
    die "$dist.tgz already exists\n" unless $force;
    warn "$dist.tgz already exists, deleting prefious version\n";
    system "rm -rf $dist.tgz $dist";
}

mkdir $dist, 0775 or die $!;

filex::barf('Version', "$yyyymmddhhmmss: $dist\n", filex::slurp('Version'));

@files = map { /^([\w._-]+)/ } split(/\r?\n/s, filex::slurp('MANIFEST'));
die "No MANIFEST?" unless @files;

$files = join ' ', @files;
#warn "Files:$files:";

system "cp $files $dist" and die "$@:$!";
system "tar czf $dist.tgz $dist" and die "$@:$!";
$siz = -s("$dist.tgz");
system "rm -rf $dist" if $siz>100;  # Dont delete if something went wrong

$md5 = `md5sum $dist.tgz`;
chomp $md5;
warn $md5, " ($siz bytes)\n";

if ($sign_passwd) {
    system("./smime -ds dist-id.pem '$sign_passwd' <$dist.tgz | cat - dist-cert.pem >$dist.sigcert");
    warn "signature in $dist.sigcert\n";
}

#EOF
