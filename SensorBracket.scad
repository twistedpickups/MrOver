include <RoverGlobals.scad>;
ps_y = 38;
ps_x = 25.4;
tube_rad = 8;
screw_rad = 1.5;

module proxSensor()
{
  difference() {
    union() {
      color("green") translate([-ps_x/2,-ps_y/2,0])
        cube([ps_x,ps_y,1.6]);
      color("black") translate([-4,-11,1.6])
        cube([8,22,8]);
    }
    translate([0,-15,-0.1])
      cylinder(3,r=1.5,$fn=30);
    translate([0,15,-0.1])
      cylinder(3,r=1.5,$fn=30);
    translate([-3,-2,7.6])
      cube([6,4,3]);
    translate([0,-7,6.6])
      difference() {
        cylinder(5,r=3,$fn=30);
        sphere(r=3,$fn=30);
      }
    translate([0,7,6.6])
      difference() {
        cylinder(5,r=3,$fn=30);
        sphere(r=3,$fn=30);
      }
  }
}

module bracketClamp() {
  difference() {
    translate([-(tube_rad+6),-(tube_rad+6),0])
      cube([tube_rad*2 + 6, tube_rad*2+6,35]);
    cylinder(50,r=tube_rad);
    translate([0,-tube_rad,-0.1]) cube([tube_rad+1,30,50]);
    translate([-tube_rad,0,-0.1]) cube([30,tube_rad+1,50]);

    translate([-(tube_rad+3),tube_rad-10,30])
      rotate([0,90,90]) cylinder(20,r=screw_rad,$fn=16);
    translate([-(tube_rad+3),tube_rad-10,5])
      rotate([0,90,90]) cylinder(20,r=screw_rad,$fn=16);

    translate([-tube_rad+4,-tube_rad-3,30])
      rotate([90,0,90]) cylinder(20,r=screw_rad,$fn=16);
    translate([-tube_rad+4,-(tube_rad+3),5])
      rotate([90,0,90]) cylinder(20,r=screw_rad,$fn=16);
  }  
  
}

module SensorBracket() {
  difference() {
    union() {
      difference() {
        translate([-(tube_rad+2.4),-(tube_rad+2.4),0])
          cube([tube_rad*2 + 2.4, tube_rad*2+2.4,45]);
        cylinder(50,r=tube_rad);
        translate([0,-tube_rad,-0.1]) cube([tube_rad+1,30,50]);
        translate([-tube_rad,0,-0.1]) cube([30,tube_rad+1,50]);
      }
      translate([-(tube_rad+2.4),0,0]) cube([2.4,60,45]);
      translate([0,-(tube_rad+2.4),0]) cube([60,2.4,45]);
    }
    translate([-tube_rad-2.4-1,ps_y-11.5,22.5-4.5])
      cube([10,23,9]);
    translate([ps_y-11.5,-tube_rad-2.4-5,22.5-4.5])
      cube([23,10,9]);
    
    //screw holes
    translate([-(tube_rad+3),tube_rad+3,35])
      rotate([0,90,0]) cylinder(20,r=screw_rad,$fn=16);
    translate([-(tube_rad+3),tube_rad+3,10])
      rotate([0,90,0]) cylinder(20,r=screw_rad,$fn=16);

    translate([tube_rad+3,-tube_rad+1,35])
      rotate([90,0,0]) cylinder(20,r=screw_rad,$fn=16);
    translate([(tube_rad+3),-tube_rad+1,10])
      rotate([90,0,0]) cylinder(20,r=screw_rad,$fn=16);
  }  
}
//////////////////////////////
*color("silver") cylinder(100,r=tube_rad,$fn=60);
SensorBracket();

translate([0,0,5])
  rotate([0,0,180])
    bracketClamp();

translate([-tube_rad+1.6,ps_y,22.5])
  rotate([0,90,180])
    proxSensor();
translate([ps_y,-tube_rad+1.6,22.5])
  rotate([0,90,-90])
    proxSensor();
