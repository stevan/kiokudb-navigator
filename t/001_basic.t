#!/usr/bin/perl

use strict;
use warnings;
use FindBin;

use Test::More no_plan => 1;
use Test::Exception;

BEGIN {
    use_ok('KiokuDB::Navigator');
}

use KiokuDB;

{
    package Person;
    use Moose;
    use MooseX::AttributeHelpers;

    has ['first_name', 'last_name'] => (is => 'rw', isa => 'Str');
    has 'age'      => (is => 'rw', isa => 'Int');
    has 'spouse'   => (is => 'rw', isa => 'Person');

    has ['mother', 'father'] => (
        is        => 'ro',
        isa       => 'Person',
        weak_ref  => 1,
        trigger   => sub {
            my ($self, $parent) = @_;
            $parent->add_child($self);
        }
    );

    has 'children' => (
        metaclass => 'Collection::Array',
        is        => 'rw',
        isa       => 'ArrayRef[Person]',
        lazy      => 1,
        default   => sub { [] },
        provides  => {
            'push' => 'add_child'
        }
    );

    has 'car' => (is => 'rw', isa => 'Car');

    package Car;
    use Moose;

    has 'owner' => (
        is       => 'rw',
        isa      => 'Person',
        weak_ref => 1,
        trigger  => sub {
            my ($self, $owner) = @_;
            $owner->car($self);
        }
    );

    has [ 'make', 'model', 'vin' ] => (is => 'rw');
}

my $root_id;

{
    my $db = KiokuDB->connect("bdb:dir=data", create => 1);

    my $s = $db->new_scope;

    my $homer = Person->new(first_name => 'Homer', last_name => 'Simpson', age => 35);
    my $marge = Person->new(first_name => 'Marge', last_name => 'Simpson', age => 32, spouse => $homer);
    $homer->spouse($marge);

    my $minivan = Car->new(make => 'Toyota', model => 'Sienna', vin => '12345abcdefghijklmno', owner => $marge);
    my $volvo   = Car->new(make => 'Volvo', model => 'Sedan', vin => '12345abcdefghijklmno', owner => $homer);

    my %parents = (father => $homer, mother => $marge);

    my @children = (
        Person->new(first_name => 'Bart',  last_name => 'Simpson', age => 11, %parents),
        Person->new(first_name => 'Lisa',  last_name => 'Simpson', age => 9,  %parents),
        Person->new(first_name => 'Magie', last_name => 'Simpson', age => 1,  %parents),
    );

    ($root_id) = $db->txn_do(sub {
        $db->store( $homer, $marge, @children, $minivan, $volvo );
    });
}

my $n = KiokuDB::Navigator->new(
    db       => KiokuDB->connect("bdb:dir=data"),
    doc_root => [ $FindBin::Bin, '..', 'doc_root' ],
    root_id  => $root_id,
);

$n->run;