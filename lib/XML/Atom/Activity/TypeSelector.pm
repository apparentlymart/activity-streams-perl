#!/usr/bin/perl

package XML::Atom::Activity::TypeSelector;

use strict;
use warnings;
use Carp;

sub new {
    my ($class) = @_;
    return bless {}, $class;
}

sub add_base_type {
    my ($self, $uri) = @_;

    $self->{$uri} = 0;
}

sub add_derived_type {
    my ($self, $uri, $parent_uri) = @_;

    my $parent_weight = $self->{$parent_uri};
    Carp::croak("Cannot derive undeclared type $parent_uri") unless defined($parent_weight);

    $self->{$uri} = $parent_weight + 1;
}

sub find_best_type {
    my ($self, $choices) = @_;

    my $best_uri = undef;
    my $best_weight = -1;

    foreach my $uri (@$choices) {
        if (defined($self->{$uri}) && $self->{$uri} > $best_weight) {
            $best_uri = $uri;
            $best_weight = $self->{$uri};
        }
    }

    return $best_uri;
}

sub sort_types {
    my ($self, $choices) = @_;

    return [ sort {
        my $weight_a = $self->{$a};
        my $weight_b = $self->{$b};
        return $weight_b <=> $weight_a;
    } grep { defined $self->{$_} } @$choices ];
}

1;

=head1 NAME

XML::Atom::Activity::TypeSelector - Chooses the most specific from a set of types identified by URIs

=head1 SYNOPSIS

    my $object_type_selector = XML::Atom::Activity::TypeSelector->new();
    $object_type_selector->add_base_type('http://example.com/mediaobject');
    $object_type_selector->add_derived_type('http://example.com/photo', 'http://example.com/mediaobject');
    my $best_type = $object_type_selector->find_best_type([
        'http://example.com/mediaobject',
        'http://example.com/photo',
    ]);

In the above example, C<$best_type> will contain the 'photo' URL, since it is the most specific
of the URLs specified.
