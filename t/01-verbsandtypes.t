
use strict;
use Test::More tests => 12;
use XML::Atom::Activity::ActivityFeed;
use XML::Atom::Activity::ActivityEntry;

my $data = join('', <DATA>);

my $feed = XML::Atom::Activity::ActivityFeed->new(\$data);

ok(defined($feed), "instantiate feed");

my @entries = $feed->entries;

ok(scalar(@entries) == 1, "one entry in feed");

my $entry = $entries[0];

ok($entry->isa('XML::Atom::Activity::ActivityEntry'), "entry is of the right class");

my $object = $entry->activity_object;
ok(defined($object), "Activity has an object");

my $verbs = $entry->activity_verbs;
my $object_types = $object->object_types;

ok(ref($verbs) eq 'ARRAY', "Verbs came back in an ARRAY ref");
ok(ref($object_types) eq 'ARRAY', "Object types came back in an ARRAY ref");
ok(scalar(@$verbs) == 2, "Two verbs in entry");
ok(scalar(@$object_types) == 2, "Two object_types in entry");

my @correct_verbs = qw(
   http://example.com/urgle
   http://example.com/posted
);

my @correct_object_types = qw(
   http://example.com/blurgle
   http://example.com/thing
);

for (my $i = 0; $i < 2; $i++) {
    ok($verbs->[$i] eq $correct_verbs[$i], "$verbs->[$i] eq $correct_verbs[$i]");
    ok($object_types->[$i] eq $correct_object_types[$i], "$object_types->[$i] eq $correct_object_types[$i]");
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
        <activity:object>
                <title>My Blurgle</title>
                <link rel="alternate" href="http://example.com/myblurgle" type="text/html" />
                <activity:object-type>http://example.com/blurgle</activity:object-type>
                <activity:object-type>http://example.com/thing</activity:object-type>
                <published>2008-12-25T00:00:00Z</published>
                <source>
                        <title>Joe's Blurgles</title>
                        <link rel="alternate" href="http://example.com/joe/blurgles" type="text/html" />
                </source>
        </activity:object>
    </entry>

</feed>

