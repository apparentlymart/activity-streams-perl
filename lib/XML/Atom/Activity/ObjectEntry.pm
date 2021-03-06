#!/usr/bin/perl

package XML::Atom::Activity::ObjectEntry;

use strict;
use base qw(XML::Atom::Entry);

use XML::Atom;
use XML::Atom::Util ();

use XML::Atom::Activity qw(ACTIVITY_NAMESPACE_URI ACTIVITY_NAMESPACE);

sub rebless_plain_entry {
    my ($class, $entry) = @_;

    Carp::croak("Can't rebless a ".ref($entry)." to $class") unless ref($entry) eq 'XML::Atom::Entry';

    bless $entry, $class;

    # We don't return the feed here to make it explicit
    # that we've reblessed the object in-place.
    1;
}

sub from_element {
    my ($class, $elem) = @_;

    my $self = $class->SUPER::new(Elem => $elem);

    # If we're holding an activity:object element then our primary
    # namespace will be set wrong, so let's put it back.
    XML::Atom::Util::set_ns($self, { Version => "1.0" });

    return $self;
}

sub object_types {
    my ($entry) = @_;
    return [ $entry->getlist(ACTIVITY_NAMESPACE, 'object-type') ];
}

sub best_object_type {
    my ($entry, $selector) = @_;

    my $types = $entry->XML::Atom::Activity::ObjectEntry::object_types;
    return $selector->find_best_type($types);
}

sub make_implied_activity {
    my ($entry) = @_;

    my $activity = XML::Atom::Activity::ActivityEntry->new(Version => 1.0);

    # FIXME: Should try to grab the author out of the feed's author
    # and the entry's author to include in the title here.
    $activity->title('posted '.$entry->title) if $entry->title;
    $activity->published($entry->published) if $entry->published;

    my $implied_verbs = $entry->XML::Atom::Activity::ActivityEntry::activity_verbs;
    if (scalar(@$implied_verbs)) {
        $activity->activity_verbs($implied_verbs);
    }
    else {
        $activity->activity_verbs([ XML::Atom::Activity::POST_VERB_URI ]);
    }

    # Round-trip through ActivityEntry to get an activity:object element rather than
    # an atom:entry element. (Blech?)
    $activity->activity_object($entry);
    my $object = $activity->activity_object;

    # Don't want the implied verbs in the object.
    $object->XML::Atom::Activity::ActivityEntry::activity_verbs([]);

    if (! $activity->has_activity_verb(XML::Atom::Activity::POST_VERB_URI)) {
        # If the verb isn't post, then we don't know when the object was published.
        $object->published(undef);
    }

    $activity->activity_object($object);

    return $activity;
}

1;

=head1 NAME

XML::Atom::Activity::ObjectEntry - An Atom Object Entry

=head1 DESCRIPTION

Instances of this class represent entries in an object feed. An object
entry can be said to represent a social object, such as a weblog entry
or a photo.

=head1 PROPERTIES

In addition to the standard properties of L<XML::Atom::Entry> objects,
this class provides the following object-related properties.

=head2 $entry->object_types

Returns a list of object type URIs for this object.

    my @types = $entry->object_types;

This property may return an empty list, which indicates that the object
has no known type. In this case, it's best to just call the object
by its title and ignore the type. For example:

    Martin posted "Blah blah blah"

Here, "Blah blah blah" is the title of this object.

=head2 $entry->best_object_type($selector)

Given a L<XML::Atom::Activity::TypeSelector> instance, will find the best
object type using the configured type heirarchy.

=head1 METHODS

=head2 $entry->make_implied_activity

Any object entry has an implied activity associated with it.
This method will create a L<XML::Atom::Activity::ActivityEntry>
instance that represents this implied activity.
