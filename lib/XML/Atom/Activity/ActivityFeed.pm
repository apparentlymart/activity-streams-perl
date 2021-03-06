#!/usr/bin/perl

package XML::Atom::Activity::ActivityFeed;

use strict;
use base qw(XML::Atom::Feed);

use XML::Atom::Activity::ActivityEntry;

use XML::Atom;
use Carp;

sub rebless_plain_feed {
    my ($class, $feed) = @_;

    Carp::croak("Can't rebless a ".ref($feed)." to $class") unless ref($feed) eq 'XML::Atom::Feed';

    bless $feed, $class;

    # We don't return the feed here to make it explicit
    # that we've reblessed the object in-place.
    1;
}

sub entries {
    my ($feed, @other_args) = @_;

    my @entries = $feed->SUPER::entries(@other_args);

    my $idx = 0;
    foreach my $entry (@entries) {
        if ($entry->XML::Atom::Activity::ActivityEntry::entry_is_activity($entry)) {
            XML::Atom::Activity::ActivityEntry->rebless_plain_entry($entry);
        }
        else {
            $entries[$idx] = $entry->XML::Atom::Activity::ObjectEntry::make_implied_activity;
        }
        $idx++;
    }

    return @entries;
}

1;

=head1 NAME

XML::Atom::Activity::Feed - An AtomActivity Feed

=head1 DESCRIPTION

This class has the same interface as L<XML::Atom::Feed> except that
all entries returned from the C<entries> method will be instances
of L<XML::Atom::Activity::ActivityEntry>.

If given a feed that contains object entries rather than activity
entries they will be transformed into the implied activity
as described in the AtomActivity specification.

