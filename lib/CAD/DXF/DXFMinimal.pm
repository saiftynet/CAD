package DXFMinimal;
# just handles lines and polylines at the moment

our $VERSION=0.01;

sub new{
	my ($class, %args) = @_;  
    my $self={};
    $self->{data}=\%args;
    bless $self, $class;
    return $self;
}

sub build{
	my $self=shift;
	$self->{dxf}= $self->buildHeader().
	       $self->buildClasses().
	       $self->buildTables().
	       $self->buildBlocks().
	       $self->buildEntities().
	       $self->buildObjects().
	       "0\nEOF\n";
}

sub sectionWrap{
	return "0\nSECTION\n".$_[0]."0\nENDSEC\n";
}

sub coords{
	my ($index,$point)=@_;
	my ($x,$y,$z)=@$point;
	$x=sprintf " %.3f",$x;
	$y=sprintf " %.3f",$y;
	$z=sprintf " %.3f",$z if defined $z;
	return "1$index\n$x\n2$index\n$y\n3$index\n$z\n" if defined $z;
	return "1$index\n$x\n2$index\n$y\n" ;
}

sub buildHeader{
	my $comments=$args{comment} // "DXF created using Gears.pm";
	return "999\n$comments\n".
	       sectionWrap("2\nHEADER\n9\n\$ACADVER\n1\nAC1021\n".
	                   "9\n\$HANDSEED\n5\n2000\n".
	                   "9\n\$INSBASE\n".coords(0,[0.0,0.0,0.0]).  # insertion base point
	                   "9\n\$EXTMIN\n". coords(0,[0.0,0.0,0.0]).  # lower left point
	                   "9\n\$EXTMAX\n".coords(0, [300.0,400.0]).  # upper right point
	                   "9\n\$INSUNITS\n70\n4\n" )                 # measurement units 1=inches 2-feet 3=miles
	                                                              # 4=mm 5=cm 6=m  7=km
}

sub buildClasses{
	return sectionWrap( "2\nCLASSES\n");
}

sub buildTables{
	my ($self)=@_;
	my $tablesString="";
	unless ( defined $self->{data}{tables}){$self->baseTables()};
	foreach my $table (@{$self->{data}{tables}}){
		$tablesString.="0\nTABLE\n".$table."\n0\nENDTAB\n";
	}
	return sectionWrap( "2\nTABLES\n$tablesString");
}

sub baseTables{
	my ($self)=@_;
	$self->{data}{tables}=[
	
       join ("\n",(2,"VPORT",5,8,330,0,100,"AcDbSymbolTable",70,1,
                   0,"VPORT",5,31,330,2,100,"AcDbSymbolTableRecord",100,"AcDbViewportTableRecord",
                   2,"*ACTIVE",
                   70,0,10,0,20,0,11,1,21,1,12,209.475294253,22,86.0026335861,
		13,0,23,0,14,10,24,10,15,10,25,10,16,0,26,0,36,1,17,0,27,0,37,0,40,319.744231092,
		41,2.12946428571,42,50,43,0,44,0,50,0,51,0,71,0,72,100,73,1,74,3,75,0,76,0,
		77,0,78,0,281,0,65,1,110,0,120,0,130,0,111,1,121,0,131,0,112,0,122,1,132,0,79,
		0,146,0,348,10020,60,7,61,5,292,1,282,1,141,0,142,0,63,250,421,3358443)),

        join ("\n",(2,"LTYPE",5,5, 330,0,100,"AcDbSymbolTable",70,4,
                    0,"LTYPE",5,14,330,5,100,"AcDbSymbolTableRecord",100,"AcDbLinetypeTableRecord",
                    2,"ByBlock",70,0,3,"",72,65,73,0,40,0,
                    0,"LTYPE",5,15,330,5,100,"AcDbSymbolTableRecord",100,"AcDbLinetypeTableRecord",
                    2,"ByLayer",70,0,3,"",72,65,73,0,40,0,
                    0,"LTYPE",5,16,330,5,100,"AcDbSymbolTableRecord",100,"AcDbLinetypeTableRecord",
                    2,"Continuous",70,0,3,"Solid line",72,65,73,0,40,0)),
        
        join ("\n",(2,"LAYER",5,2, 330,0,100,"AcDbSymbolTable",70,1,
                    0,"LAYER",5,10,330,2,100,"AcDbSymbolTableRecord",100,"AcDbLayerTableRecord",
                      2,0,70,0,62,7,6,"CONTINUOUS",370,-3,390,"F")),
                      
        join ("\n",( 2,"STYLE",5,3, 330,0,100,"AcDbSymbolTable",70,3,
                     0,"STYLE",5,45,330,2,100,"AcDbSymbolTableRecord",100,"AcDbTextStyleTableRecord",
                     2,"Standard",70,0,40,0,41,1,50,0,71,0,42,1,3,"txt",4,"")),
                     
        join ("\n",(2,"VIEW",5,6,   330,0,100,"AcDbSymbolTable",70,0)),
         
        join ("\n",(2,"UCS",5,7,    330,0,100,"AcDbSymbolTable",70,0)),
            
        join ("\n",(2,"APPID",5,9,  330,0,100,"AcDbSymbolTable",70,1,
                    0,"APPID",5,12, 330,9,100,"AcDbSymbolTableRecord",100,"AcDbRegAppTableRecord",
                    2,"ACAD",70,0)),	
                    
        join ("\n",(2,"DIMSTYLE",5,"A", 330,0,100,"AcDbSymbolTable",70,1,100,"AcDbDimStyleTable",71,1,
                    0,"DIMSTYLE",105,46,330,"A",100,"AcDbSymbolTableRecord",100,"AcDbDimStyleTableRecord",
                    2,"Standard",70,0,
                       40,1,41,0.18,42,0.0625,43,0.38,44,0.18,45,0,46,0,47,0,48,0,
                       140,0.18,141,0.09,142,0,143,25.4,144,1,145,0,146,1,147,0.09,148,0,
                       71,0,72,0,73,0,74,1,75,0,76,0,77,0,78,0,79,0,
                       170,0,171,2,172,0,173,0,174,0,175,0,176,0,177,0,178,0,179,0,
                       271,4,272,4,273,2,274,2,275,0,276,0,277,2,278,46,279,0,
                       280,0,281,0,282,0,283,1,284,0,285,0,286,0,288,0,289,3,
                       340,"Standard",341,"",371,-2,372,-2)),
                       
        join ("\n",(2,"BLOCK_RECORD",5,1,   330,0,100,"AcDbSymbolTable",70,2,
                    0,"BLOCK_RECORD",5,"1F",330,1,100,"AcDbSymbolTableRecord",100,"AcDbBlockTableRecord",
                    2,"*Model_Space",70,0,280,1,281,0,
                    0,"BLOCK_RECORD",5,"1E",330,1,100,"AcDbSymbolTableRecord",100,"AcDbBlockTableRecord",
                    2,"*Paper_Space",70,0,280,1,281,0))
	];
}

sub buildBlocks{
	my ($self)=@_;
	my $blocksString="";
	unless ( defined $self->{data}{blocks}){$self->baseBlocks()};
	foreach my $block (@{$self->{data}{blocks}}){
		$blocksString.="0\nBLOCK\n".$block."\n0\nENDBLK\n";
	}
	return sectionWrap( "2\nBLOCKS\n");
}
sub baseBlocks{
	my ($self)=@_;
	$self->{data}{blocks}=[
        join ("\n",(5,20,330,"1F",100,"AcDbEntity",8,0,100,"AcDbBlockBegin",
                    2,"*Model_Space",70,0,10,0,20,0,30,0,
                    3,"*Model_Space",1,"",5,21,330,"1F",100,"AcDbEntity",
                    8,0,100,"AcDbBlockEnd")),
                    
        join ("\n",(5,"1C",330,"1B",100,"AcDbEntity",8,0,100,"AcDbBlockBegin",
                    2,"*Paper_Space",70,0,10,0,20,0,30,0,
                    3,"*Paper_Space",1,"",5,"1D",330,"1E",100,"AcDbEntity",
                    8,0,100,"AcDbBlockEnd")),	
	
	
  ];	
}


	
sub buildEntities{
	my ($self)=@_;
	my @entities=@{$self->{data}{entities}};
	my $entityString="";
	foreach my $entity (@entities){
		$entityString.=$self->entity(@$entity);
	}
	return sectionWrap( "2\nENTITIES\n".$entityString);
}

sub entity{
	my ($self,$entityType,$handle,$layer,$colour, $pointSet,$extras)=@_;
	if($entityType =~/polyline/i){
		my $vertices="";
		foreach my $pt (@$pointSet){
			$vertices.=coords(0,$pt)
		};
		return join( "\n",(0,"LWPOLYLINE",5,$handle,330,"1F",100,"AcDbEntity",8,"Layer_$layer",100,"AcDbPolyline",
		      $vertices));
	}
	if($entityType =~/spline/i){
		my $vertices=coords(1,$$pointSet[-1]);
		foreach my $pt (@$pointSet){
			$vertices.=coords(1,$pt)
		};
		return join( "\n",(0,"SPLINE",5,$handle,330,"1F",100,"AcDbEntity",8,"Layer_$layer",100,"AcDbSpline",
		   70,11,71,3,72,68,73,0,74,scalar @$pointSet,44,0.00001,
		      $vertices));
	}
	elsif ($entityType =~/line/i){
		if (scalar @$pointSet !=2){ warn "LINE requires 2 points"; return "";}
		return join( "\n",(0,"LINE",5,$handle,100,"AcDbEntity",8,"Layer_$layer",62,$colour,100,"AcDbLine",
		       coords(0,$$pointSet[0]).coords(1,$$pointSet[1])));
    }
    elsif ($entityType =~/circle/i){
		@points=@$pointSet;
		if (scalar @points !=2){ warn "CIRCLE requires one point and one radius"; return "";}
		
		return join( "\n",(0,"CIRCLE",5,$handle,100,"AcDbEntity",8,"Layer_$layer",62,$colour,100,"AcDbCircle",
		       40,$points[1], coords(0,$points[0]) ));
    }
    elsif ($entityType =~/text/i){
		@points=@$pointSet;
		if (scalar @points !=3){ warn "TEXT requires one point, one size, one string"; return "";}
		
		return join( "\n",(0,"TEXT",5,$handle,100,"AcDbEntity",8,"Layer_$layer",62,$colour,100,"AcDbText",
		       40,$points[1],41,1,1,$points[2],coords(0,$points[0]) ));
    }		
	elsif($entityType =~/face/i){
		my $vertices="";
		my @points=@$pointSet;
		if (scalar @points == 3){@points=(@points,$points[-1])};
		if (scalar @points !=4){ warn "3DFACE reuires 3 or 4 points"; return "";}
		foreach my $index (1..@points){
			$vertices.=coords($index,$point[$index])
		};
		return join( "\n",(0,"3DFACE",5,$handle,100,"AcDbEntity",8,"Layer_$layer",62,$colour,100,
		   "AcDbFace",$vertices));
	}
	elsif($entityType =~/vertex/i){
		return "0\nVERTEX\n8\nLAYER\n$layer\n70\n$colour\n66\n1\n70\n32\n".
		      coords(0,@points[0])
	}
}

sub addEntity{
	my ($self,$entityType,$layer,$colour, @points)=@_;
	my $handle=sprintf("0x%X", scalar @{$self->{data}{entities}}+150);
	push @{$self->{data}{entities} }, [$entityType,$handle,$layer,$colour, @points];
}

sub buildObjects{
	my ($self)=@_;
	my $objectsString="";
	unless ( defined $self->{data}{objects}){$self->baseObjects()};
	foreach my $object (@{$self->{data}{objects}}){
		$objectsString.=$object;
	}
	return sectionWrap( "2\nOBJECTS\n");
}

sub baseObjects{
	my ($self)=@_;
	$self->{data}{objects}=[
        join ("\n",(0,"DICTIONARY",5,"C",330,0,100,"AcDbDictionary",281,1,3,"ACAD_GROUP",350,"D",)),
        
        join ("\n",(0,"DICTIONARY",5,"D",330,"C",100,"AcDbDictionary",281,1))
        ];
	
}

sub save{
	my ($self,$fileName)=@_;
	open(my $FH, '>', $fileName) or die $!;
	print $FH $self->build();
	close($FH);
}
	

1;

