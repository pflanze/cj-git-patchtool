# Todo / open issues

- reuse original author as well, not only time, if it's the same for
  all patches. right?

- handle CR vs CRLF etc gracefully somehow (repo with CRLF or
  something gives patches that don't apply)

- `wig` should not remove newly created files out of a patchfile
  (i.e. a patch creates new files, and has some conflict in a change
  to an existing file; wig will update the change to an existing file,
  but ditch the newly created files. fix that.)

- (would it be possible to handle merge commits usefully? i.e. reuse
  conflict merges that might already have been solved there.)

- "git am" fails with 'Patch does not have a valid e-mail address.' if
  the commit message body has a line that starts with 'from:'

- 'wig' removes the executable flag from files, fix that
  (not so simple, will have to parse patch file to know which paths
  are modified? Or can we rely on $rejfile ?)

- test suite

- port `cj-git-applypatches` to using functional-perl (and make it an
  example?)

- at least since the "-a" flag was added to the command to commit, it doesn't
  work with submodules (anymore): it commits to the current submodule
  in the first commit, then fails when trying to apply any submodule
  change commits. How to solve this?

- die when not on a branch instead of running into odd error

- binary files: at least stop with an error message

- in some situations, moving a patch will not lead to a conflict but
  to it being dropped without any error popping up (if the same patch
  and its reversal were before it, but now after it). This leads to
  potentially hard to track down differences in the end result. Parse
  git output for such cases, and/or offer to hard group the patches
  somehow (i.e. make a single patch out of a group *before* the
  re-ordering)?

- set GIT_COMMITTER_TIME to the same current time for the whole of an
  `app` run.

