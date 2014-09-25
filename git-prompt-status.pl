#!/usr/bin/env perl

use strict;
use warnings;
use 5.016;
use utf8;

use Term::ANSIColor;

sub main() {
  my $current_branch = @{exec_cmd("git symbolic-ref HEAD")}[0];
  if($current_branch =~ m/fatal: Not a git repository/) {
    exit(0);
  } else {
    my $branch = $1 if $current_branch =~ /refs\/heads\/(.+)/;
    $branch //= "-"; # if in 'detached HEAD' state
    my $commit = @{exec_cmd("git rev-parse --short HEAD")}[0]; # gives the current commit
    printout("[ $branch | $commit ]", "bold bright_red on_white");
    
    my $stash = exec_cmd("git stash list");
    printout("[stash:" . scalar @$stash ."]", "bold black on_white", "true") if defined $stash;
    
    my $status = {};
    my $changes = exec_cmd("git status --porcelain");
    foreach my $change (@$changes) {
      $status->{$1} += 1 if $change =~ /^([ \w\?]+)? /;
    }
    foreach my $k (sort keys %$status) {
      printout("[X:$status->{$k}]", "bold bright_black on_bright_red") if $k =~ /U/; # conflicts
      printout("[?:$status->{$k}]", "bold bright_black on_bright_cyan") if $k =~ /\?\?/; # untracked files
      printout("[N+:$status->{$k}]", "bold right_black on_bright_green") if $k =~ /^A/; # added completely new files, staged
      printout("[M+:$status->{$k}]", "bold black on_green") if $k =~ /^M/; # modified files, staged
      printout("[M-:$status->{$k}]", "bold bright_black on_bright_yellow") if $k =~ /^ M/; # modified, unstaged
      printout("[D+:$status->{$k}]", "bold black on_bright_blue") if $k =~ /^D/; # deleted files, staged
      printout("[D-:$status->{$k}]", "bold black on_blue") if $k =~ /^ D/; # deleted files, unstaged 
    }
  }
}

sub printout() {
  my ($out, $color_spec, $space) = @_;
  print " " if defined $space;
  print colored ($out, $color_spec);
  print color 'reset';
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

=item B<printout()>

Takes as arguments two strings - first one with a text to print and second one with color specification
and prints our already formated string. As a third argument can take a true or false in case 
if a space should be printed in front of new stat

=back

=head1 AUTHOR

Oleksandr Kylymnychenko, oleksandr@nerdydev.net

=head1 COPYRIGHT AND LICENSE

GNU GPL, Version 2

=cut
