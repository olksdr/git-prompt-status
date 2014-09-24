#!/usr/bin/env perl

use strict;
use warnings;
use 5.016;
use utf8;

use Term::ANSIColor;

sub main() {
  my $current_branch = exec_cmd("git symbolic-ref HEAD");
  if($current_branch->[0] =~ m/fatal: Not a git repository/) {
    exit(0);
  } else {
    my $branch = $+{branch} if $current_branch->[0] =~ /refs\/heads\/(?<branch>.+)/;
    $branch //= "-"; # if in 'detached HEAD' state
    my $commit = @{exec_cmd("git rev-parse --short HEAD")}[0]; # gives the current commit
    print colored ['bright_red on_white'], "[ $branch | $commit ]"; 

    my $changes = exec_cmd("git status --porcelain");
    my $untracked = 0; 
    my $added = 0;
    my $modified = 0;
    my $conflicts = 0;
    foreach my $line (@$changes) {
      if ($line =~ m/^\?\?/) {
        $untracked += 1;
      } elsif ($line =~ m/^[AMD]/) {
        $added += 1;
      } elsif ($line =~ m/^\sM/) {
        $modified += 1;
      } elsif ($line =~ m/^U/) {
        $conflicts += 1;
      }
    }
    print " [?:$untracked] [+:$added] [-:$modified] [X: $conflicts] ";
  }
}

sub exec_cmd() {
  my $command = shift;
  open(FH, '-|', "$command 2>&1") || die "can't run the command $!";
  my $result = ();
  while (<FH>) {
    chomp;
    push @$result, $_;
  }
  close FH;
  return $result;
}

main();


__END__

=pod

=head1 NAME

Git Prompt Status - Information about the current GIT repo

=head1 DESCRIPTION

This simple script intents to beautify GIT prompt status in BASH. This makes it easier 
to manage repositories using some additional information. 

=head2 METHODS

=over 4


=item B<exec_cmd()>

Executes a command passed to this function as a string. Returns all the STDOUT and STDERR 
which was produced by the command as an array of strings.

=back

=head1 AUTHOR

Oleksandr Kylymnychenko, oleksandr@nerdydev.net

=head1 COPYRIGHT AND LICENSE

GNU GPL, Version 2

=cut
