package Perl::ToPerl6::TransformerParameter::Behavior::String;

use 5.006001;
use strict;
use warnings;

use Perl::ToPerl6::Utils;

use base qw{ Perl::ToPerl6::TransformerParameter::Behavior };

#-----------------------------------------------------------------------------

sub _parse {
    my ($transformer, $parameter, $config_string) = @_;

    my $value = $parameter->get_default_string();

    if ( defined $config_string ) {
        $value = $config_string;
    }

    $transformer->__set_parameter_value($parameter, $value);

    return;
}

#-----------------------------------------------------------------------------

sub initialize_parameter {
    my ($self, $parameter, $specification) = @_;

    $parameter->_set_parser(\&_parse);

    return;
}

#-----------------------------------------------------------------------------

1;

__END__

#-----------------------------------------------------------------------------

=pod

=for stopwords

=head1 NAME

Perl::ToPerl6::TransformerParameter::Behavior::String - Actions appropriate for a simple string parameter.


=head1 DESCRIPTION

Provides a standard set of functionality for a string
L<Perl::ToPerl6::TransformerParameter|Perl::ToPerl6::TransformerParameter> so that
the developer of a transformer does not have to provide it her/himself.

NOTE: Do not instantiate this class.  Use the singleton instance held
onto by
L<Perl::ToPerl6::TransformerParameter|Perl::ToPerl6::TransformerParameter>.


=head1 INTERFACE SUPPORT

This is considered to be a non-public class.  Its interface is subject
to change without notice.


=head1 METHODS

=over

=item C<initialize_parameter( $parameter, $specification )>

Plug in the functionality this behavior provides into the parameter.
At present, this behavior isn't customizable by the specification.


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
