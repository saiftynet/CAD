# CAD

### Perl CAD Utilities

This is set of utilities that help drawing using Perl and exporting to SVG and DXF.
DXF utilities are rather limited in Perl.  These modules teach me CAD while allowing me to use scripts to generate drawings and 3D objects.

### CAD::Gear.pm

Draws gears. These are currently crude, while I learn the mathematics of drawing an involute gear profile.  It can outputs to SVG, but will allow the "borrowing" of the points generated for other uses.  Currently allows exporting of data ina "points-from-file" format that can be imported into VariCAD using 2dff.

### CAD::DXF::Minimal

Generates a valid minimalist DXF file. Currently only handles lines, polylines, splines, text; other entities will be added on request, if time permits, and it becomes necessary to do so. One may generate complex drawings, in the future, but depends on interest.  For more details see [DXFMinimal](DXFMinimal)

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

$dxf->addEntity("line",1,4,[[23,32,0],[70,32,0]]);
$dxf->addEntity("polyline",1,4,$gear->{points});
$dxf->save("Test.dxf");
```
### example output

![dxf vs 2dff](https://user-images.githubusercontent.com/34284663/111084811-3332c880-850c-11eb-81b2-c514f8598638.png)

