#
# Copyright 2020 by , ch at christianjaeger ch
# Published under the same terms as perl itself
#

=head1 NAME

Chj::Git::Patchtool

=head1 SYNOPSIS

=head1 DESCRIPTION


=cut


package Chj::Git::Patchtool;

use strict; use warnings; use warnings FATAL => 'uninitialized';

use Exporter 'import';

our @EXPORT=qw();
our @EXPORT_OK=qw(git_commit_options);
our %EXPORT_TAGS=(all=>[@EXPORT,@EXPORT_OK]);


our $git_commit_options= [
    '--no-verify', # ignore hooks, e.g. pre-commit
    ];

sub git_commit_options {
    @$git_commit_options
}

1
