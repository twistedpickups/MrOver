// Left/Right Hand side Bogie Joint

include <RoverGlobals.scad>;

shaft_rad = 8;
tube_rad = 8+0.2;
screw_rad = 1.5;
wall_thickness = 4;
bearing_rad = (35+0.6)/2;
bearing_z = 8.75;
thrust_od = 35+1;
thrust_id = 20-1;
thrust_z = 5;
//con_height = 2*(8+wall_thickness)+4;
con_height = (tube_rad+wall_thickness)*2+6;
con_width  = 3*(8+wall_thickness);
core_rad = bearing_rad+wall_thickness+1;
con_rad = con_width*0.9;

//bjfa = 108.4; -- global
//tube_angle = 360-(bjfa+109.7);//132
tube_angle = 360-(bjfa+bjra);
front_camber = 0;// rear on left side
rear_camber=0;
shaft_z = 15;
ver = "BJ3.7";

module air_hole(angle) {
    
  rotate([0,0,angle])
    translate([0,-2.8*tube_rad,-0.25])
    difference() {
      cylinder(con_height+0.5,6,6);
      translate([0,core_rad,-1])
        cylinder(con_height+2,core_rad,core_rad,$fn=90);
    }
}

module mock_bearing(bz) {

%translate([0,0,bz])
  difference() {
    cylinder(bearing_z,bearing_rad,bearing_rad);

    translate([0,0,-0.5])      
      cylinder(bearing_z+1,shaft_rad,shaft_rad);
  }    
    
}
///////////////////////////////////////////////

rotate([0,-rear_camber,180])
translate([-44,8.5,(tube_rad+wall_thickness)*2+6])
  linear_extrude(height=0.3)
    text(ver,6.0);

difference() {

  union() {
    cylinder(con_height*.75,con_rad,con_rad);
    cylinder(con_height+4,core_rad,core_rad,$fn=90);
echo("height=",con_height+4);
    
// rear shaft support
    rotate([0,rear_camber,0])
    translate([0,-(con_height)/2,
           shaft_z - con_height/2])
      cube([thrust_od/2+wall_thickness+4*tube_rad-10,
            con_height,con_height]);
    translate([0,0,con_height/2-1])
      rotate([0,90-rear_camber,0])
        translate([0,0,22])
          cylinder(45,r=18);

// front shaft support
    rotate([0,front_camber,tube_angle])
    translate( [0,-con_height/2,
        shaft_z - con_height/2])
      cube([thrust_od/2+wall_thickness+4*tube_rad-10,
        con_height,con_height]);
    
    translate([0,0,con_height/2-1])
    rotate([0,90-front_camber,tube_angle])
    translate([0,0,22])
      cylinder(45,r=18);

  }// end union
    
// rotational shaft
  translate([0,0,-0.5])
  linear_extrude(height=con_height+1)
    circle(shaft_rad+0.3,$fn=90);

// thrust bearing    
  translate([0,0,-0.5])
  difference() {
  linear_extrude(height=thrust_z+0.3)
    circle(thrust_od/2);
    translate([0,0,-0.1])
      cylinder(thrust_z+0.5,thrust_id/2,thrust_id/2,$fn=90);
  }

// rear shaft
    translate( [0,0,shaft_z])
      rotate([0,90+rear_camber,0])
        translate([0,0,thrust_od/2+wall_thickness+7])
        cylinder(con_width+tube_rad+10,tube_rad,tube_rad,$fn=90);

    translate( [0,0,shaft_z])
      rotate([0,90+rear_camber,0])
        translate([0,0,thrust_od/2+wall_thickness])
        cylinder(10,tube_rad-1,tube_rad-1,$fn=90);

// front shaft
   translate( [0,0,shaft_z])
    rotate([0,90+front_camber,tube_angle])
//    rotate([0,90,0])
     translate([0,0,thrust_od/2+wall_thickness+7])
      cylinder(con_width+tube_rad+100,tube_rad,tube_rad,$fn=90);

    translate( [0,0,shaft_z])
      rotate([0,90+rear_camber,tube_angle])
        translate([0,0,thrust_od/2+wall_thickness])
        cylinder(10,tube_rad-1,tube_rad-1,$fn=90);

echo(con_height/3-5);
// bearing    
  translate([0,0,con_height/3])
  linear_extrude(height=con_height)
    circle(bearing_rad,$fn=90);
    
  mock_bearing(con_height/3);
  mock_bearing(con_height/3+bearing_z);

// air hole
  air_hole(90-(360-tube_angle)/4 -12);

// air hole
  air_hole(90-2*(360-tube_angle)/4);

// air hole
  air_hole(90-3*(360-tube_angle)/4+12);

// air hole
  air_hole(90+tube_angle/2);


//screw holes
  translate([cos(0)*4.5*tube_rad,sin(0)*4.5*tube_rad,0])
    cylinder(con_height+5,screw_rad,screw_rad);

  translate([cos(tube_angle)*4.5*tube_rad,sin(tube_angle)*4.5*tube_rad,0])
    cylinder(con_height+5,screw_rad,screw_rad);

//wire holes
  rotate([0,0,tube_angle])
  translate([thrust_od/2+wall_thickness,-6.5,-1])
    linear_extrude(height=con_height/2+1)
      square([7,13]);

  translate([thrust_od/2+wall_thickness,-6.5,-1])
    linear_extrude(height=con_height/2+1)
      square([7,13]);

// clear bottom of tubes from camber angle for flat print
  translate([-75,-50,-10])
    linear_extrude(height=10)
    square([150,120]);

}
