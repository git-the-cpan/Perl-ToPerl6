package Perl::ToPerl6::Exception::Configuration::Generic;

use 5.006001;
use strict;
use warnings;

use Readonly;

our $VERSION = '0.03';

#-----------------------------------------------------------------------------

use Exception::Class (
    'Perl::ToPerl6::Exception::Configuration::Generic' => {
        isa         => 'Perl::ToPerl6::Exception::Configuration',
        description =>
            q{A problem with Perl::ToPerl6 configuration that isn't related to an option.},
        alias       => 'throw_generic',
    },
);

#-----------------------------------------------------------------------------

Readonly::Array our @EXPORT_OK => qw< throw_generic >;

#-----------------------------------------------------------------------------

1;

__END__

#-----------------------------------------------------------------------------

=pod

=for stopwords

=head1 NAME

Perl::ToPerl6::Exception::Configuration::Generic - A problem with L<Perl::ToPerl6|Perl::ToPerl6> configuration that doesn't involve an option.

=head1 DESCRIPTION

A representation of a problem found with the configuration of
L<Perl::ToPerl6|Perl::ToPerl6>, whether from a F<.perlmogrifyrc>, another
profile file, or command line.

This covers things like file reading and parsing errors.


=head1 INTERFACE SUPPORT

This is considered to be a public class.  Any changes to its interface
will go through a deprecation cycle.


=head1 CLASS METHODS

=over

=item C<< throw( message => $message, source => $source ) >>

See L<Exception::Class/"throw">.


=item C<< new( message => $message, source => $source ) >>

See L<Exception::Class/"new">.


=back


=head1 AUTHOR

Elliot Shank <perl@galumph.com>

=head1 COPYRIGHT

Copyright (c) 2007-2011 Elliot Shank.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

=cut

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
