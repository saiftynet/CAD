#!/usr/bin/perl
use strict; use warnings;
use lib "../lib/";
use CAD::Gear;
use CAD::DXF::DXFMinimal;

my $gear=Gear->new(nTeeth=>7,toothWidth=>5);
$gear->generate();
$gear->save("test.svg");

my $dxf=DXFMinimal->new();
$dxf->addEntity("polyline",1,4,$gear->{points});
$dxf->save("test.dxf");
