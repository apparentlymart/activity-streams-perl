
use strict;
use XML::Atom::Activity::TypeSelector;

my @tests;
BEGIN {
    @tests = (
        [
            [qw(thing)],
            [qw(thing)],
        ],
        [
            [qw(thing weblogentry)],
            [qw(weblogentry thing)],
        ],
        [
            [qw(weblogentry thing)],
            [qw(weblogentry thing)],
        ],
        [
            [qw(thing mediaobject)],
            [qw(mediaobject thing)],
        ],
        [
            [qw(thing mediaobject photo)],
            [qw(photo mediaobject thing)],
        ],
        [
            [qw(thing photo)],
            [qw(photo thing)],
        ],
        [
            [qw(mediaobject video)],
            [qw(video mediaobject)],
        ],
        [
            [qw(video thing)],
            [qw(video thing)],
        ],
        [
            [qw(thing widget)],
            [qw(thing)],
        ],
        [
            [qw(thing widget video)],
            [qw(video thing)],
        ],
        [
            [qw(widget)],
            [],
        ],
        [
            [],
            [],
        ],
    );
};
use Test::More tests => scalar(@tests) * 3;

my $selector = XML::Atom::Activity::TypeSelector->new();

$selector->add_base_type('thing');
$selector->add_derived_type('weblogentry', 'thing');
$selector->add_derived_type('mediaobject', 'thing');
$selector->add_derived_type('photo', 'mediaobject');
$selector->add_derived_type('video', 'mediaobject');

foreach my $test (@tests) {
    my $in = $test->[0];
    my $correct_out = $test->[1];
    my $correct_out_first = $correct_out->[0];

    my $actual_out = $selector->sort_types($in);
    my $actual_out_first = $selector->find_best_type($in);

    my $test_name = '('.join(',', @$in).')';
    my $output_string = '('.join(',', @$correct_out).')';

    ok(scalar(@$correct_out) == scalar(@$actual_out), "$test_name got ".scalar(@$correct_out)." results");

    my $ok = 1;
    for (my $i = 0; $i < scalar(@$correct_out); $i++) {
        $ok = 0 if $actual_out->[$i] ne $correct_out->[$i];
    }

    ok($ok, "$test_name returned $output_string");

    if (defined($correct_out_first)) {
        ok($actual_out_first eq $correct_out_first, "$test_name best result is $correct_out_first");
    }
    else {
        ok(!defined($actual_out_first), "$test_name has no best result");
    }

}
