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
    my $status = {};
    my $changes = exec_cmd("git status --porcelain");
    foreach my $line (@$changes) {
      $status->{$1} += 1 if $line =~ /^([ \w\?]+)? /;
    }
    # prints out beautiful results 
    foreach my $k (keys %$status) {
      print colored ['bright_black on_bright_cyan'], "[?:$status->{$k}]" if $k =~ /\?\?/; # untracked files
      print colored ['bright_black on_bright_yellow'], "[M-:$status->{$k}]" if $k =~ /^ M/; # modified, unstaged
      print colored ['bright_black on_bright_red'], "[X:$status->{$k}]" if $k =~ /U/; # conflicts
      print colored ['bright_black on_bright_green'], "[N+:$status->{$k}]" if $k =~ /^A/; # added completely new files, staged
      print colored ['black on_green'], "[M+:$status->{$k}]" if $k =~ /^M/; # modified files, staged
      print colored ['black on_bright_blue'], "[D+:$status->{$k}]" if $k =~ /^D/; # deleted files, staged
      print colored ['black on_blue'], "[D-:$status->{$k}]" if $k =~ /^ D/; # deleted files, unstaged 
    }
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
