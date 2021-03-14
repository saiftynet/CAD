# CAD

### Perl CAD Utilities

This is set of utilities that help drawing using Perl and exporting to SVG and DXF.
DXF utilities are rather limited in Perl.  These modules teach me CAD while allowing me to use scripts to generate drawings and 3D objects.

### CAD::Gear.pm

Draws gears. These are currently crude, while I learn the mathematics of drawing an involute gear profile.  It can outputs to SVG, but will allow the "borrowing" of the points generated for other uses.

### CAD::DXF::Minimal

Generates a valid minimalist DXF file. Currently only handles lines and polylines; other entities will be added on request, if time permits, and it becomes necessary to do so.

```
#!/usr/bin/perl
use strict; use warnings;
use lib "../lib/";
use CAD::Gear;
use CAD::DXF::DXFMinimal;

my $gear=Gear->new(nTeeth=>7,toothWidth=>5);
$gear->generate();
$gear->save("test.svg");

my $dxf=DXFMinimal->new();

$dxf->addEntity("polyline",1,4,[[23,42],[70,42],[70,52],[23,52],[23,42]]);
$dxf->addEntity("line",1,7,[[23,12,0],[70,12,0]]);
$dxf->addEntity("line",1,10,[[23,22,0],[70,22,0]]);
$dxf->addEntity("line",1,4,[[23,32,0],[70,32,0]]);
$dxf->addEntity("polyline",1,4,$gear->{points});
$dxf->save("Test.dxf");
```
