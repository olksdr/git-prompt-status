#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use Term::ANSIColor;

sub main() {
  my $current_branch = exec_cmd("git symbolic-ref HEAD");
  if($current_branch->[0] =~ m/fatal: Not a git repository/) {
    exit(0);
  } else {
    my $branch = $+{branch} if $current_branch->[0] =~ /refs\/heads\/(?<branch>.+)/;
    say colored ['bright_red on_white'], "[ $branch ]"; 
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


=item N<exec_cmd>

Executes a command passed to this function as a string. Returns all the STDOUT and STDERR 
which was produced by the command as an array of strings.

=back

=head1 AUTHOR

Oleksandr Kylymnychenko, oleksandr@nerdydev.net

=head1 COPYRIGHT AND LICENSE

GNU GPL, Version 2

=cut
