
use strict;
use Test::More tests => 9;
use XML::Atom::Activity::Feed;
use XML::Atom::Activity::Entry;

my $data = join('', <DATA>);

my $feed = XML::Atom::Activity::Feed->new(\$data);

ok(defined($feed), "instantiate feed");

my @entries = $feed->entries;

ok(scalar(@entries) == 1, "one entry in feed");

my $entry = $entries[0];

ok($entry->isa('XML::Atom::Activity::Entry'), "entry is of the right class");

my @verbs = $entry->activity_verbs;
my @object_types = $entry->activity_object_types;

ok(scalar(@verbs) == 2, "Two verbs in entry");
ok(scalar(@object_types) == 2, "Two object_types in entry");

my @correct_verbs = qw(
   http://example.com/urgle
   http://example.com/posted
);

my @correct_object_types = qw(
   http://example.com/blurgle
   http://example.com/thing
);

for (my $i = 0; $i < 2; $i++) {
    ok($verbs[$i] eq $correct_verbs[$i], "$verbs[$i] eq $correct_verbs[$i]");
    ok($object_types[$i] eq $correct_object_types[$i], "$object_types[$i] eq $correct_object_types[$i]");
}

1;

__DATA__
<?xml version="1.0" encoding="utf-8"?>

<feed xmlns="http://www.w3.org/2005/Atom" xmlns:activity="http://activitystrea.ms/spec/1.0">
    <title>Test Activity Stream</title>
    <id>tag:example.com,2008:activity-streams-perl-test1</id>

    <entry>
        <title>Joe urgled a blurgle</title>
        <activity:verb>http://example.com/urgle</activity:verb>
        <activity:verb>http://example.com/posted</activity:verb>
        <activity:object-type>http://example.com/blurgle</activity:object-type>
        <activity:object-type>http://example.com/thing</activity:object-type>
    </entry>

</feed>

