Git Prompt
==========

A simple perl script to beautify git prompt in BASH. This makes it easier to
manage repos using some additional stats.

### Setup

in ``$HOME/.bashrc`` or in ``$HOME/.bash_profile`` depends on what is used in
your system you should change the ``PS1`` variable to include the next:
```bash
GIT_PROMPT="<path to git-prompt.pl>"
PS1="\w:\h \$($GIT_PROMPT)\n > "
```

##### How it looks now:
``` bash
/home/gituser/repos/project:userhost 
[ issue/branch_name ] [ last: 8d726fd ] [ pending changes: 439 ] 
> _
```
