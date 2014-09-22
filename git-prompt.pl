#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

# let's color our output
use Term::ANSIColor;

## SUBS ##
sub main() {
    git_exec("branch -v", \&branch_parse, "true");
    git_exec("rev-list HEAD...origin/master --count", \&pending);
}

# parser and printer for branches 
sub branch_parse() {
    my $branch_name = shift;
    if($branch_name =~ /^\* (?<branch>.+?) \s*(?<commit>.+?) .+/) {
        print colored ['red'], "[ $+{branch} ]";
        print " [ last: $+{commit} ] ";
    }
}

# prints how many commits between current branch and origin/master
sub pending() {
    my $count = shift;
    print colored ['black on_bright_red'], "[ pending changes: $count ]" if $count > 0;
}

# executes keys and passes result to given sub for further parsin/output
sub git_exec() {
    my $git_bin = "/usr/bin/git";
    my ($cmd, $subref, $newline) = @_;
    $newline //= "false";

    say "" if $newline eq "true";
    open FH, "-|", "$git_bin $cmd 2>/dev/null" or die "";
    while(<FH>) {
        chomp;
        $subref->($_);
    }
    close FH;
}

## calling MAIN ##
main();

