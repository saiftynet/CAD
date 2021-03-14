#!/usr/bin/perl
use strict; use warnings;
use lib "../lib/";
use CAD::Gear;
use CAD::DXF::DXFMinimal;

my $gear=Gear->new(nTeeth=>10,toothWidth=>3);
$gear->generate();
$gear->translate([50,100]);
$gear->save("test.pff","pff");               # for Points-from-file
$gear->translate([50,0]);
$gear->save("test.svg","svg");               # svg output
my $dxf=DXFMinimal->new();

$dxf->addEntity("spline",1,4,[[23,42],[70,42],[70,52],[23,52],[23,42]]); # DXF Spline
$dxf->addEntity("line",1,10,[[75,25,0],[75,125,0]]);                     # DXF Line
$dxf->addEntity("line",1,10,[[25,75,0],[125,75,0]]);                     # DXF Line
$dxf->addEntity("polyline",1,4,$gear->{points});                         # DXF Polyline
$gear->translate([0,-50]);                                               # translate object
$dxf->addEntity("spline",1,4,$gear->{points});                           # DXF Spline
$dxf->addEntity("circle",1,7,[[50,50],2.5]);                             # circle
$dxf->addEntity("circle",1,7,[[100,50],2.5]);                            # circle
$dxf->addEntity("circle",1,7,[[100,100],2.5]);                           # circle
$dxf->addEntity("circle",1,7,[[50,100],2.5]);                            # circle
$dxf->addEntity("Text",1,7,[[40,80],2.5,"2dff spline"]);                 # text
$dxf->addEntity("Text",1,7,[[90,80],2.5,"DXF Polyline"]);                # text
$dxf->addEntity("Text",1,7,[[40,30],2.5,"DXF  spline"]);                 # text
$dxf->addEntity("Text",1,7,[[90,30],2.5,"DXF  spline"]);                 # text
$dxf->save("Test.dxf");
