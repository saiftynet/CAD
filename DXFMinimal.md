## DXFMinimal

This is minimalist DXF creator in PERL. Objectives is to be able to create 2d DXF Files which are valid and that can be read by most CAD applications.  DXF File format is reasonably well documented and not to difficult to reverse engineer, and the data is stored in human readable, newline separated, paired data groups, which makes for easy manipulation in PERL.  DXF creation is not too difficult in Python thanks to [Mozman's](https://github.com/mozman/ezdxf) efforts.  My attempt targets Perl, but is deliberately significantly more limited for greater simplicity.  It handles TEXT, LINE, LWPOLYLINE, HATCH, ARC, CIRCLE, ELLIPSE entities and more will be added as time permits.. borrowing a little form his example minimalist DXF files.

```
#!/usr/bin/perl
use strict; use warnings;
use lib "../lib/";
use CAD::Gear;
use CAD::DXF::DXFMinimal;

my $gear=Gear->new(nTeeth=>10,toothWidth=>3);
$gear->generate();
$gear->translate([50,100]);
my $dxf=DXFMinimal->new();

$dxf->addEntity("line",1,10,[[75,25,0],[75,125,0]]);                     # DXF Line
$dxf->addEntity("line",1,10,[[25,75,0],[125,75,0]]);                     # DXF Line
$dxf->addEntity("polyline",1,4,$gear->{points});                         # DXF Polyline
$gear->translate([0,-50]);                                               # translate object
$dxf->addEntity("spline",1,4,$gear->{points});                           # DXF Spline
$dxf->addEntity("circle",1,7,[[50,50],2.5]);                             # circle
$dxf->addEntity("circle",1,7,[[75,75],52]);                              # circle
$dxf->addEntity("ellipse",1,7,[[100,100],[10,10],0.5,0,6.283]);          # ellipse
$dxf->addEntity("ellipse",1,7,[[100,100],[10,-10],0.5,0,6.283]);         # ellipse
$dxf->addEntity("ellipse",1,7,[[100,100],[14.14,0],0.5,0,6.283]);        # ellipse
$dxf->addEntity("ellipse",1,7,[[100,100],[0,14.14],0.5,0,6.283]);        # ellipse
$dxf->addEntity("arc",1,7,[[75,75],50,90,180]);                          # arc
$dxf->addEntity("arc",1,7,[[75,75],50,270,0]);                           # arc
$dxf->addEntity("Text",1,7,[[40,80],2.5,"Hello World"]);                 # text
$gear->translate([50,0]);                                                # translate object
$dxf->addEntity("polyline",1,4,$gear->{points});                         # DXF Polyline
$dxf->addEntity("hatch",1,4,$gear->{points},{angle=>33, width=>2});      # DXF Polyline


$dxf->save("DXFTest2.dxf");
```

produces:-

![DXFMinimal](https://user-images.githubusercontent.com/34284663/111703612-d13cd080-8835-11eb-9604-03d066dc2e64.png)
