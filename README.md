Git Prompt
==========

A simple perl script to beautify git prompt status in BASH. This makes it easier to
manage repos using some additional information.

### Setup

in ``$HOME/.bashrc`` or in ``$HOME/.bash_profile`` depends on what is used in
your system the ``PS1`` variable should be set to include
a ``git-prompt-status.pl``. For example:
```bash
GIT_PROMPT="/path/to/git-prompt-status.pl"
PS1="\h@[\w]\n\$($GIT_PROMPT)\n> "
````
#####Result in the repo:
``` bash
userhostname@[/home/gituser/repos/project]
[ test22 | 65bce87][M-:1][M+:1][D-:1][D+:1][?:1] 
> _
```
![git prompt status](git-prompt-status.png)
