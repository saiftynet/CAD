package Gear;
use strict;use warnings;

our $VERSION=0.01;

our $pi=atan2(0,-1);
sub acos{atan2(sqrt(1 - $_[0] * $_[0]), $_[0])}
sub tan { sin($_[0]) / cos($_[0])  }
sub deg2rad{ return $_[0]*$pi/180}

sub new{
	my ($class, %args) = @_;  
    my $self={};
    $self->{points}=[];
    $self->{data}=\%args;
    bless $self, $class;
    $self->initialise();
    return $self;
}

sub set{  # change parameters
	my ($self,%args) =@_;
	foreach my $key (keys %args){$self->{data}{$key}=$args{$key}} ;
	$self->initialise();
}

sub modulo{  # distance from origin
	my $a=shift;
	return sqrt($$a[0]**2+$$a[1]**2)
}

sub angleToXAxis{ #angle of vector to origin
	my $a=shift;
	if ($$a[1]==0){
		return ($$a[0]>=0)?0:$pi
	}
	return ($$a[1]/abs($$a[1]))*acos($$a[0]/modulo($a))
}

sub rotatePoints{ # rotate a set of points by angle, about a center
	my($P, $angle, $center)=@_;
	my @R=();
	my ($s,$c)=(sin($angle),cos($angle) );
	translatePoints($P,$center,-1) if ($center);
	foreach my $pt (@$P){
		push @R,[$$pt[0]*$c-$$pt[1]*$s,$$pt[0]*$s+$$pt[1]*$c]
	}
	translatePoints($P,$center,1) if ($center);
	return \@R;
}

sub rotate{  #rotates the gear
	my($self, $angle, $center)=@_;
	$self->{points}=rotatePoints($self->{points}, $angle, $center);
}

sub translatePoints{ # translate a set of points by a certain vector
	my ($points,$offset,$direction)=@_;
	$direction //=1;
	my @R;
	foreach my $a (@$points){
		push @R, [$$a[0]+$$offset[0]*$direction,$$a[1]+$$offset[1]*$direction]
	}
	return \@R;
}

sub translate{ # translates the gear
	my($self,$offset,$direction)=@_;
	$self->{points}=translatePoints($self->{points},$offset,$direction);
}

sub save{
	my ($self,$fileName,$fileType)=@_;
	$fileType //="svg";
	open(my $FH, '>', $fileName) or die $!;
	if ($fileType eq"svg")     {print $FH $self->svg("polyline")}
	elsif ($fileType eq "pff") {
		foreach my $pt (@{$self->{points}}){
			print $FH "$$pt[0],$$pt[1],"
		}
	}
	close($FH);
}
	
sub initialise{
	my $self=shift;
	$self->{data}{nTeeth} //= 20;
	$self->{data}{toothWidth} //= 5;
	$self->{data}{pressureAngle} //= 20;
	$self->{data}{pressureAngleRad}=$self->{data}{pressureAngle}*$pi/180;
	$self->{data}{backlash} //= 0;
	$self->{data}{frameCount} //= 16;
	$self->{data}{profile} //= "basic";
	$self->{data}{turnAngle}= 2*$pi/$self->{data}{nTeeth};
	$self->{data}{pitchCircumference} = $self->{data}{toothWidth} * 2 * $self->{data}{nTeeth};
	$self->{data}{pitchRadius} = $self->{data}{pitchCircumference} / (2 * $pi);
	$self->{data}{addendum} =$self->{data}{toothWidth}*2/3;
	$self->{data}{dedendum} =$self->{data}{addendum};
	$self->{data}{outerRadius} = $self->{data}{pitchRadius}+$self->{data}{addendum};
}


sub generate{     # generate a pointset for a gear;
	my $self=shift;
    my $profile=profileMaker($self,"basic");
	  $self->{points}=[];   
	my @polyList=();
	
	foreach (1..$self->{data}{nTeeth}){
		push @polyList,@$profile;
		$profile=rotatePoints($profile,$self->{data}{turnAngle});
	}
	@polyList=(@polyList,$polyList[0]);
	$self->{points}=\@polyList;
}

sub profileMaker{
	my ($self,$type)=@_;   # type and parameters
	if ($type eq "basic"){
		my ($pr,$d,$a,$tw,$pa,$ta)=@{$self->{data}}{qw/pitchRadius dedendum addendum toothWidth pressureAngleRad turnAngle/};
		return [
			 [$pr-$d  , -.5 * $tw-$d * tan($pa-$ta/2) ],
			 [$pr     , -.5 * $tw                     ],
			 [$pr+$a  , -.5 * $tw+$a * tan($pa)       ],
			 [$pr+$a  ,  .5 * $tw-$a * tan($pa)       ],
			 [$pr     ,  .5 * $tw                     ],
			 [$pr-$d  ,  .5 * $tw+$d * tan($pa-$ta/2) ]
			 ];	
	}	
}


# convert a set of 2D points into an SVG shape, return the ghape in a view box
# sized to accommodate the gear

sub svg{
  my ($self,$type)=@_;
  $type //="polyline";
  my $size=int($self->{data}{outerRadius}*2+2.5);
  return "<svg  width='$size' height='$size'  viewbox='0 0 $size $size'>\n".
      svgItem($self,$type),
      "\n</svg>";
}

sub svgItem{   # creates an svg polyline or polygon or group of lines from points
	my ($self,$type)=@_;
    $type //="polyline";
    my $item="";
	my $maxX=0;my $minX=0;my $maxY=0;my $minY=0; my @points=();my ($x,$y);
	@points=@{$self->{points}};
	
	# polygons close themselves, poly lines and lines need that extra closing line
	#@points=($points[-1],@points) if ($type=~/line/); 
	
	if ($type =~/poly/i){
		my $i=0; #counter for making output easier to check 
		foreach my $pt (@points){
			($x,$y)=@$pt;
			
			# because svg viewbox cannot have negative values
			$minX=$x if $minX> $x;  
			$minY=$y if $minY> $y;
			
			#numbers rounded to 2dp for smaller output files, and 6 
			$item.= (sprintf " %.2f,%.2f", $x,$y). ((++$i % 6)?" ":"\n"); 
		}	
	    $item="<$type points='$item' transform='translate(".(sprintf " %.2f,%.2f", 1-$minX,1-$minY).")'
             fill='none' stroke='black'  />"
	}
	else{
		
		
		
	}
	return $item;
}

1;

