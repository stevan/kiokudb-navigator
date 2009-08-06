package KiokuDB::Cmd::Command::Nav;
use Moose;

use KiokuDB::Navigator;
use Path::Class;
use Class::Inspector;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

extends 'KiokuDB::Cmd::Base';
   with 'KiokuDB::Cmd::WithDSN::Read';

augment 'run' => sub {
    my $self = shift;

    KiokuDB::Navigator->new(
        db       => KiokuDB->new( backend => $self->backend ),
        doc_root => Path::Class::File->new(
                        Class::Inspector->loaded_filename( __PACKAGE__ )
                    )->parent # Command
                     ->parent # Cmd
                     ->parent # KiokuDB
                     ->parent # lib
                     ->parent->subdir('doc_root'),
    )->run;
};

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

KiokuDB::Cmd::Command::Nav - A Moosey solution to this problem

=head1 SYNOPSIS

  use KiokuDB::Cmd::Command::Nav;

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item B<>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
