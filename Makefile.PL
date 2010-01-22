use strict;
use warnings;
use inc::Module::Install;

name 'KiokuDB-Navigator';
all_from 'lib/KiokuDB/Navigator.pm';
license 'perl';

# prereqs
requires 'KiokuDB';
requires 'KiokuDB::Cmd';
requires 'JSORB';
requires 'MooseX::Types::Path::Class';
requires 'File::ShareDir';

install_share;

# things the tests need
build_requires 'Test::More'      => '0.62';
build_requires 'Test::Exception' => '0.21';

tests('t/*.t t/*/*.t');

WriteAll();

