// rc Car parts awa 20140619

// Oh so many changes, but still some German here!
// slightly thinned over 3.2b version rI=125/2 instead of 122/2
// but edge is slightly thicker
// 2mm higher hub
include <roverGlobals.scad>;

fnf = 60;
rA=wheel_rad;	//outer radius
dP=5;			//Lug thickness removed from outer radius
rI=125.6/2;		//Inner radius
wH=wheel_width;		//Wheel width
setscrew_rotate = -18;

hub_z = whub_z;

print = true;

module dshaft_6mm() {
    difference() {
          translate([0,0,0])
            linear_extrude(height=40)
            circle(3.3,$fn=32);

          translate([-4,2.25,0])
            linear_extrude(height=40)
            square([10,5]);
        
        }
}

module raftGrid(r=30, rI=20, x=1,y=2,d=2,step=10, h=0.2) {
	m=r*x*y*1.2;
	translate([0,0,h/2] )union() {
		scale([x,y,1]) difference() {
			cylinder( r=r, h=h, center=true, $fn=fnf );
			cylinder( r=r-d, h=h, center=true, $fn=fnf );
		}
		intersection() {
			scale([x,y,1]) cylinder( r=r, h=h, center=true, $fn=fnf );
			rotate([0,0,45]) 	difference() {	
				union() {
					for( s=[-m:step:m]) {
						translate([s,0,0]) cube([d,2*m,h],center=true);
						translate([0,s,0]) cube([2*m,d,h],center=true);
					}
				}
				//translate([-3,-3,0]) cube([42,42,2*h],center=true);
			cylinder(r=rI,h=2*h,center=true);
			}
		}
	}
}

module mitnehmer( d=12, h=5 ) {
	translate([0,0,-h/2]) union() {
//		cylinder( r=d/2, h=h, $fn=6, center=true );
		difference() {
			cylinder (r=1*d,h=h,center=true);
			union() {
				for (i=[0:1:5]) {
					rotate([0,0,i*60]) translate([d,0,0]) cube([d,1.1*d,1.01*h], center=true);
				}
			}
		}
		cylinder( r=2, h=20, $fn=40, center=true );
	}
}


module fin() {
  translate([8,0,0])
  difference()
  {
    translate([0,-1.5,0])
      cube([60,3,40]);
    translate([-1,-2,0])
      cube([2,4,40]);    
    translate([60,-2,40])
      rotate([-90,0,0])
        scale([3,2,1])
        cylinder(4,19,19);
  }
}

module hub( fnf=100 ) {
//	wHI=wH-6;
    wHI = wH;
	sp=5;
	difference() {
		translate([0,0,wH/2])
      cylinder( r=rA-dP, h=wH, $fn=fnf, center=true );
		// innen
		translate([0,0,wHI/2-5])
      cylinder( r1=rI+5, r2=rI, h=wHI+1, $fn=fnf, center=true );
		// aussen
		//translate([0,0,wHI+0.5+1]) cylinder( r=6, h=1, $fn=fnf, center=true );
		translate([0,0,2.5+wHI+2])
      cylinder( r1=7, r2=rA*0.8, h=5, $fn=fnf, center=true );
		// speichen
        // holes in hub
		for( i=[0:sp-1] ) {
			rotate([0,0,i*360/sp])
        translate([rI/2+8,0,0])
          scale([1.4,1.2,1])   
            cylinder( r=rI/4, h=2*wH+1, center=true, $fn=fnf );
		}// end for loop
		translate([0,0,wHI-10]) // mitnehmer(d=12.2);
          cylinder(12, 3,3,$fn=32);

    translate([0,0,wHI-18])// mitnehmer(d=12.2);
          translate([0,0,3])
            rotate([-90,0,setscrew_rotate])
              cylinder(60,1.5,1.5,$fn=16);

    }// end difference

    translate([0,0,wHI-4.5])
		for( i=[0:sp-1] ) {
			rotate([180,0,i*360/sp+36])
      fin();
    }
    echo(hub_z);
    translate([0,0,hub_z])// mitnehmer(d=12.2);
      difference() {
          union() {
            cylinder(wHI-hub_z, 10,10);
            translate([0,0,9])
              cylinder(wHI-hub_z-9, 8,17);
          }
          translate([0,0,-1])
          rotate([0,0,setscrew_rotate])
            dshaft_6mm();
          translate([0,0,6])
            rotate([-90,0,setscrew_rotate])
              cylinder(50,1.5,1.5,$fn=16);
      }
}// end module

module felge2( fnf=100 ) {
	wHI=75;
	sp=5;
	difference() {
		translate([0,0,wH/2])
      cylinder( r=rA-dP, h=wH, $fn=fnf, center=true );
		// innen
    difference() {
  		translate([0,0,wHI/2-5])
        cylinder( r1=rI+8, r2=rI, h=wHI+25, $fn=fnf, center=true );
  		translate([0,0,wHI*1.5+10])
        sphere(rA-4);
      }
		// aussen
		//translate([0,0,wHI+0.5+1]) cylinder( r=6, h=1, $fn=fnf, center=true );
		translate([0,0,(wH-wHI)/2+wHI+2])
      cylinder( r1=7, r2=rI+8, h=wH-wHI, $fn=fnf, center=true );
		// speichen
		for( i=[0:sp-1] ) {
			rotate([0,0,i*360/sp])
        translate([rI/2+4,0,0])
         scale([1.4,1.1,1])
           cylinder( r=rI/4, h=2*wH, center=true, $fn=fnf );
		}
		translate([0,0,wHI]) mitnehmer(d=12.2);
	}
}

module treadPattern(fnf=100) {
	steps=8;	//Number of lugs
	y=30;			//Length or lug halfs
	intersection() {
		union() {
			for( i=[0:steps-1] ) {
				for( j=[-1,1] ) {
					rotate([0,0,i*360/steps])
                      translate([rA-dP+dP/2,1,0])
                        rotate([j*35,0,0])
                          translate([0,0,j*(wH/2-y*0.3)]/2)
                            cube( [5*dP,5,wH], center=true );
				}
			}
		}
		difference() {
			cylinder( r=rA, h=wH, $fn=fnf, center=true );
			cylinder( r=rA-dP-1, h=wH+1, $fn=fnf, center=true );
		}
	}
}

module testWheel() {
	//mitnehmer();
	//projection( cut=true ) rotate([0,90,0])

    	
   difference() {
      union() {
       //Main wheel
       //	translate([0,0,wH])
       //   rotate([180,0,0])
        hub();
//        felge2();
        //Lugs
         translate([0,0,wH/2]) treadPattern();
      }
        translate([0,0,hub_z+6])// mitnehmer(d=12.2);
            rotate([-90,0,setscrew_rotate])
              translate([0,0,10])
              cylinder(80,2,2,$fn=16);
    }        
	
	//Uncomment to enable raft
//	raftGrid(r=rA, rI=rI+8, x=1.2,y=1.2,d=2,step=10, h=0.2);
}
color("grey")
rotate([180,0,0])
//intersection() {
  testWheel();
//  cylinder(100,30,30);}

if (print) {
  translate([0,0,-wH])
    difference() {
      cylinder(0.3,90,90);
      translate([0,0,-0.1])
        cylinder(0.5,45,45);
    }
}

