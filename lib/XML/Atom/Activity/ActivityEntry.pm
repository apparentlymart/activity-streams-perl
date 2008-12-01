#!/usr/bin/perl

package XML::Atom::Activity::ActivityEntry;

use strict;
use base qw(XML::Atom::Entry);

use XML::Atom;

my $activity_namespace = XML::Atom::Namespace->new(
    'activity',
    'http://activitystrea.ms/spec/1.0',
);

sub rebless_plain_entry {
    my ($class, $entry) = @_;

    Carp::croak("Can't rebless a ".ref($entry)." to $class") unless ref($entry) eq 'XML::Atom::Entry';

    bless $entry, $class;

    # We don't return the feed here to make it explicit
    # that we've reblessed the object in-place.
    1;
}

sub activity_verbs {
    my ($entry) = @_;
    return $entry->getlist($activity_namespace, 'verb');
}

sub activity_object_types {
    my ($entry) = @_;
    return $entry->getlist($activity_namespace, 'object-type');
}

1;

=head1 NAME

XML::Atom::Activity::Entry - An AtomActivity Entry

