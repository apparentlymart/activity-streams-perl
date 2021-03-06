
use strict;
use Test::More tests => 16;
use XML::Atom;
use XML::Atom::Activity::ActivityFeed;

# Test of ActivityFeed synthesizing an implied activity
# for an object entry with an explicit verb.

my $data = join('', <DATA>);
my $feed = XML::Atom::Activity::ActivityFeed->new(\$data);

ok(defined($feed), "instantiate feed");

my @entries = $feed->entries;

ok(scalar(@entries) == 1, "one entry in feed");

my $entry = $entries[0];

ok($entry->isa('XML::Atom::Activity::ActivityEntry'), "entry is of the right class");

my $verbs = $entry->activity_verbs;

ok(scalar(@$verbs) == 1, 'Activity has one verb');
ok($verbs->[0] eq 'http://example.com/blah', 'Verb is correct');

my $object = $entry->activity_object;

ok(defined($object), 'Activity has an object');

ok(! $object->published, 'Object has no publication time');
is($entry->published, '2008-12-25T00:00:00Z', 'Activity publication time is correct');

my $object_verbs = $object->XML::Atom::Activity::ActivityEntry::activity_verbs;
ok(scalar(@$object_verbs) == 0, 'Object has no verbs');

my $types = $object->object_types;

ok(scalar(@$types) == 1, 'Object has one type');

is($types->[0], 'http://activitystrea.ms/schema/1.0/weblog-entry', 'Object is a weblog entry');

is($object->title, 'Activity Streams are Great!', 'Object title is correct');

my @object_links = $object->link;

ok(scalar(@object_links) == 1, 'Object has one links');

is($object_links[0]->rel, 'alternate', "Link is rel=alternate");
is($object_links[0]->type, 'text/html', "Link is text/html");

my @activity_links = $entry->link;

ok(scalar(@activity_links) == 0, 'Activity has no links');

1;

__DATA__
<?xml version="1.0" encoding="utf-8"?>

<feed xmlns="http://www.w3.org/2005/Atom"
      xmlns:activity="http://activitystrea.ms/spec/1.0"
      xmlns:example="http://example.com/xmlns">
    <title>Test Object Stream</title>
    <id>tag:example.com,2008:activity-streams-perl-test1</id>

    <entry>
        <title>Activity Streams are Great!</title>
        <link rel="alternate" href="http://example.com/great" type="text/html" />
        <activity:object-type>http://activitystrea.ms/schema/1.0/weblog-entry</activity:object-type>
        <published>2008-12-25T00:00:00Z</published>
        <source>
            <title>ObjectBlog</title>
            <link rel="alternate" href="http://example.com/objectblog/" type="text/html" />
            <link rel="self" href="http://example.com/objectblog/atom.xml" type="application/atom+xml" />
        </source>
        <activity:verb>http://example.com/blah</activity:verb>
    </entry>

</feed>

