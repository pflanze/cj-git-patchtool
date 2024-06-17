# About cj-git-patchtool

cj-git-patchtool is a tool to edit the history of a Git repository.

In that regard it is similar to `git rebase -i`; but unlike it, with
cj-git-patchtool you edit the history in a file that persists across
modification runs, so you can modify your changes incrementally
without risk of loosing your editing work. But not only the history is
kept in a file, but the patches as well: this allows to edit
individual patches persistently, too. There's also a tool included
called `wig` which uses `wiggle` to try to resolve conflicts that can
arise from history changes; and it saves the resolutions back into the
patch files, too. So, it always gives you access to the state in the
form of disk files, and you can change it and re-"run" the
modifications until you're done. It even checks the files into a new
Git repository on its own, so that you can commit your changes to the
state if you want, to keep a history of your history editing work :).


## Installation

Installation can either be done via a tool or manually:

### Via chjize

[chjize](https://github.com/pflanze/chjize) is a tool to install
dependencies that my software uses. Follow the instructions there and
then run `make cj-git-patchtool`.

### Manually

* Install chj-scripts and chj-perllib:

        # cd /opt; mkdir chj; cd chj
        # git clone https://github.com/pflanze/chj-perllib.git perllib
        # git clone https://github.com/pflanze/chj-scripts.git bin
        # mkdir -p /usr/local/lib/site_perl/Class
        # ln -s /opt/chj/perllib/Chj /usr/local/lib/site_perl/
        # ln -s /opt/chj/perllib/Class/Array.pm /usr/local/lib/site_perl/Class

    and add /opt/chj/bin to your PATH (through your .bash_profile or
    similar)

* Install wiggle (Debian has it in the "wiggle" package)

* Make cj-git-patchtool accessible

        # cd /opt/chj
        # git clone https://github.com/pflanze/cj-git-patchtool.git

    and add /opt/chj/cj-git-patchtool to your PATH


## Usage

In a terminal window, go to the root of the working directory of the
Git repository whose history you want to change, and check out the
branch that you want to change, with HEAD being the last commit of the
history that you want to edit.

If you run this tool the first time, from within the working directory
of the repository that you want to change:

    $ mkdir PATCHES
    $ git config --global core.excludesfile ~/.gitignore_global
    $ echo /PATCHES/ >> ~/.gitignore_global

Find the commit before the oldest commit you want to edit, then run
(-s and --start are equivalent):

    $ cj-git-patchtool -s $commitbeforeoldest

This will open two windows, (a) an editor window with a file named
`_list` containing a list of all patches (the history), and (b) a
terminal window with the shell prompt in the directory that contains
the file that has been opened in the editor, as well as all the
individual patch files (as well as a file `_baseid` that contains
$commitbeforeoldest), as well as a .git dir with these files already
checked in (in case you want to commit your editing work).

Now edit the `_list`, adhering to these rules:

* Patches on subsequent lines are squashed. Put an empty line between
  each pair of patches or groups of patches that should become a new
  commit.

* Within each group, put a star `*` at the start of a line to indicate
  the patch that determines the message, author time and author of the
  new commit.

* Alternatively, within each group, put a double quote `"` at
  the start of a line to indicate the patch that determines the
  message of the new commit. The author time is instead taken to be
  the latest author time of all patches in the series.

  And/or put a `t` at the start of a line to indicate the patch that
  determines the author time (but not the message).
  
  Also, put a `a` at the start of a line to indicate the patch that
  determines the author name/email.

* Alternatively, insert a group of lines somewhere in the group,
  starting and ending in square brackets that contains the commit
  message, like:
  
        [
        commit-message

        multiple lines are possible
        ]

* Existing commit messages can also be modified by adding a line
  starting with `prefix: ` and then a string; the string will be
  prepended to the commit message.

* A line starting with `postfix: ` and then a string leads to the
  string being appended to the commit message; `postfix-line: ` will
  also append a newline to the message, and `postfix-paragraph: ` or
  `postfix-para: ` will lead to two newlines, then the string, then a
  newline to be appended.

* A line that starts with `%` is taken to be a shell script to run at
  that point during application of the patch series.

  For example `% bash` will run a subshell, which gives you the
  possibility to access the working directory of the partially applied
  history interactively. Or, `% make test` might run your test suite,
  etc.

  If the script fails (does not exit 0), patch application is
  aborted.

* Any line that starts with `#` is ignored.

(I suggest you run `gitk &` and step through the history to see the
full commit messages and diffs easily while editing `_list`.)

If you want to apply the changed history, go to the terminal where you
ran cj-git-patchtool. It should now display
`PATCHES/$name_of_the_patch_subdirectory` as part of the prompt; this
is a reminder that you're in a subshell there. The subshell sees some
new commands, and those know where to find the directory with the
history state without further ado. To apply the history, run:

    $ app

If the history applies cleanly, it will say "Ok" at the
end. Otherwise, fix your _list, or if it's a conflict, try:

    $ wig

This will run `wiggle` and if it worked, will save the resolved diff
back to the patch file so that you don't have to run `wig` in
subsequent `app` runs.

If you're done, just close the editor buffer, exit the terminal with
the state files, and exit the subshell (hit ctl-d). To minimize space
use of the subdirectory in `PATCHES`, run `cj-git-patchtool-done`
before exiting the terminal with the state file (it adds and commits
all changes, removes all files from the working directory except for
`.git`, and runs `git gc`).

If you later decide that you didn't actually finish, run:

    $ cj-git-patchtool --resume PATCHES/$name_of_the_patch_subdirectory

to get back into the subshell. (Currently, you'll have to reopen the
`_list` file and terminal with the state directory manually, and if
you ran `cj-git-patchtool-done` then you'll have to run `git reset
--hard` to get back the files first.)


## Tips

Use the `dupa` tool from chj-scripts.git for duplicating patches (for
splitting them)

Use the `cj-git-filter-branch--add-emptytail` tool from the same place
if you want to modify the initial commit in a repository (it grafts a
temporary empty commit to the tail.)

You could use the `cj-git-graftwrite` tool from the same place to
change the grafts file (somewhat) more easily. If you need to work up
to the very first commit in the history, it may be useful to prefix
the history with a commit with an empty tree, which can be created
with `cj-git-null`.

When in the cj-git-patchtool shell context, `help-cj-git-patchtool`
will show a synopsis of the usage.
