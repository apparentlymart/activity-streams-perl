
package XML::Atom::Activity;

use XML::Atom;

use strict;
use constant ACTIVITY_NAMESPACE_URI => "http://activitystrea.ms/spec/1.0";
use constant ACTIVITY_NAMESPACE => XML::Atom::Namespace->new(
    'activity' => ACTIVITY_NAMESPACE_URI,
);
use constant POST_VERB_URI => "http://actionstrea.ms/schema/1.0/post";

use Exporter 'import';
our @EXPORT_OK = qw(
    ACTIVITY_NAMESPACE_URI
    ACTIVITY_NAMESPACE
    POST_VERB_URI
);

use XML::Atom::Activity::ActivityEntry;
use XML::Atom::Activity::ActivityFeed;
use XML::Atom::Activity::ObjectEntry;

1;

=head1 NAME

XML::Atom::Activity - AtomActivity Extensions for XML::Atom

