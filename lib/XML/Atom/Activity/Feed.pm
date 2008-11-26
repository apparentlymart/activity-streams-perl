#!/usr/bin/perl

package XML::Atom::Activity::Feed;

use strict;
use base qw(XML::Atom::Feed);

use XML::Atom::Activity::Entry;

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

    foreach my $entry (@entries) {
        XML::Atom::Activity::Entry->rebless_plain_entry($entry);
    }

    return @entries;
}

1;

=head1 NAME

XML::Atom::Activity::Feed - An AtomActivity Feed

