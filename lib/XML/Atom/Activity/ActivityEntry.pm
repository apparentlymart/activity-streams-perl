#!/usr/bin/perl

package XML::Atom::Activity::ActivityEntry;

use strict;
use base qw(XML::Atom::Entry);

use Carp;
use XML::Atom;
use XML::Atom::Util ();
use XML::Atom::Activity::ObjectEntry;
use XML::Atom::Activity qw(ACTIVITY_NAMESPACE_URI ACTIVITY_NAMESPACE);

sub rebless_plain_entry {
    my ($class, $entry) = @_;

    Carp::croak("Can't rebless a ".ref($entry)." to $class") unless ref($entry) eq 'XML::Atom::Entry';

    bless $entry, $class;

    # We don't return the feed here to make it explicit
    # that we've reblessed the object in-place.
    1;
}

sub activity_verbs {
    my $entry = shift;

    if (@_) {
        my $verbs = shift;
        Carp::croak("Verbs must be given as an ARRAY ref") unless ref $verbs eq 'ARRAY';
        my $add = 0;
        foreach my $verb (@$verbs) {
            $entry->set(ACTIVITY_NAMESPACE, 'verb', $verb, undef, $add);
            $add = 1; # After the first iteration, we want to add rather than replace.
        }
    }
    else {
        # FIXME: This currently returns all decendent verbs, not just
        # children. This might get troublesome if, for example,
        # there's ever an activity entry with an activity as its
        # object, or something crazy like that.
        return [ $entry->getlist(ACTIVITY_NAMESPACE, 'verb') ];
    }
}

sub activity_object {
    my $entry = shift;

    if (@_) {
        my $object = shift;
        $entry->set(ACTIVITY_NAMESPACE, 'object', $object);
        $object;
    }
    else {
        my ($object_elem) = XML::Atom::Util::childlist($entry->elem, ACTIVITY_NAMESPACE_URI, 'object');
        return defined $object_elem ? XML::Atom::Activity::ObjectEntry->from_element($object_elem) : undef;
    }
}

sub entry_is_activity {
    my $entry = shift;

    my $verbs = $entry->XML::Atom::Activity::ActivityEntry::activity_verbs;
    return scalar(@$verbs) ? 1 : 0;
}

1;

=head1 NAME

XML::Atom::Activity::ActivityEntry - An Atom Activity Entry

=head1 SYNOPSIS

    # If you've got an object of this class, call its methods directly
    my @verbs = $entry->activity_verbs;
    
    # Alternatively, you can call methods of this class on bare
    # XML::Atom::Entry objects
    my @verbs = $entry->XML::Atom::Activity::ActivityEntry->activity_verbs;

=head1 DESCRIPTION

Instances of this class represent entries in an activity feed. An activity
entry can be said to represent an activity.

=head1 PROPERTIES

In addition to the standard properties of L<XML::Atom::Entry> objects,
this class provides the following activity-related properties.

=head2 $entry->activity_verbs

Returns a reference to an array of verb URIs for this activity.

    my $verbs = $entry->activity_verbs;

=head2 $entry->activity_object

Returns an L<XML::Atom::Activity::ObjectEntry> object representing the
direct object of this activity, or C<undef> if no object is provided.


