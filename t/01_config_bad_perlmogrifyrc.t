#!perl

# Test that all the problems in an rc file get reported and not just the first
# one that is found.

use 5.006001;
use strict;
use warnings;

use English qw< -no_match_vars >;
use Readonly;

use Test::More;

use Perl::ToPerl6::TransformerFactory (-test => 1);
use Perl::ToPerl6;
use Perl::ToPerl6::Utils::Constants qw< $_MODULE_VERSION_TERM_ANSICOLOR >;

#-----------------------------------------------------------------------------

my @color_necessity_params;
my $skip_color_necessity =
    eval {
        require Term::ANSIColor;
        Term::ANSIColor->VERSION( $_MODULE_VERSION_TERM_ANSICOLOR );
        1;
    }
        ? undef
        : "Term::ANSIColor $_MODULE_VERSION_TERM_ANSICOLOR is not available";

# We can not do the color-necessity tests if Term::ANSIColor is not available,
# because without Term::ANSIColor the parameters are not validated, so any
# value will be accepted and we will not get any errors from them.
$skip_color_necessity
    or @color_necessity_params = qw<
        color-necessity-highest
        color-necessity-high
        color-necessity-medium
        color-necessity-low
        color-necessity-lowest
    >;

plan tests => 13 + scalar @color_necessity_params;

Readonly::Scalar my $PROFILE => 't/01_bad_perlmogrifyrc';
Readonly::Scalar my $NO_ENABLED_POLICIES_MESSAGE =>
    q<There are no enabled transformers.>;
Readonly::Scalar my $INVALID_PARAMETER_MESSAGE =>
    q<The BuiltinFunctions::RequireBlockGrep transformer doesn't take a "no_such_parameter" option.>;
Readonly::Scalar my $REQUIRE_POD_SECTIONS_SOURCE_MESSAGE_PREFIX =>
    q<The value for the Variables::FormatHashKeys "source" option ("Zen_and_the_Art_of_Motorcycle_Maintenance") is not one of the allowed values: >;

eval {
    Perl::ToPerl6->new( '-profile' => $PROFILE );
};

my $test_passed;
my $eval_result = $EVAL_ERROR;

$test_passed =
    ok( $eval_result, 'should get an exception when using a bad rc file' );

die "No point in continuing.\n" if not $test_passed;

$test_passed =
    isa_ok(
        $eval_result,
        'Perl::ToPerl6::Exception::AggregateConfiguration',
        '$EVAL_ERROR',  ## no mogrify (RequireInterpolationOfMetachars)
    );

if ( not $test_passed ) {
    diag( $eval_result );
    die "No point in continuing.\n";
}

my @exceptions = @{ $eval_result->exceptions() };

my @parameters = (
    qw<
        exclude
        include
        profile-strictness
        necessity
        single-transformer
        theme
        top
        verbose
    >,
    @color_necessity_params,
);

my %expected_regexes =
    map
        { $_ => generate_global_message_regex( $_, $PROFILE ) }
        @parameters;

SKIP: {
    skip "XXX Exceptions don't behave just yet", 1;
my $expected_exceptions = 1 + scalar @parameters;
is(
    scalar @exceptions,
    $expected_exceptions,
    'should have received the correct number of exceptions'
);
if (@exceptions != $expected_exceptions) {
    foreach my $exception (@exceptions) {
        diag "Exception: $exception";
    }
}
}

while (my ($parameter, $regex) = each %expected_regexes) {
    is(
        ( scalar grep { m/$regex/xms } @exceptions ),
        1,
        "should have received one and only one exception for $parameter",
    );
}

is(
    ( scalar grep { $INVALID_PARAMETER_MESSAGE eq $_ } @exceptions ),
    0,
    'should not have received an extra-parameter exception',
);

# Test that we get an exception for bad individual transformer configuration.
# The selection of FormatHashKeys is arbitrary.
SKIP: {
    skip "XXX Not sure what to do with this", 1;
is(
    ( scalar grep { is_require_pod_sections_source_exception($_) } @exceptions ),
    1,
    'should have received an invalid source exception for FormatHashKeys',
);
}

sub generate_global_message_regex {
    my ($parameter, $file) = @_;

    return
        qr<
            \A
            The [ ] value [ ] for [ ] the [ ] global [ ]
            "$parameter"
            .*
            found [ ] in [ ] "$file"
        >xms;
}

sub is_require_pod_sections_source_exception {
    my ($exception) = @_;

    my $prefix =
        substr
            $exception,
            0,
            length $REQUIRE_POD_SECTIONS_SOURCE_MESSAGE_PREFIX;

    return $prefix eq $REQUIRE_POD_SECTIONS_SOURCE_MESSAGE_PREFIX;
}

#-----------------------------------------------------------------------------

# ensure we return true if this test is loaded by
# t/01_config_bad_perlmogrifyrc.t_without_optional_dependencies.t
1;


##############################################################################
# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
