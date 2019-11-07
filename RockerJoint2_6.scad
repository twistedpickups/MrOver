include <RoverGlobals.scad>;

shaft_rad = 8;
tube_rad = 8+0.25;
screw_rad = 1.5;
wall_thickness = 4;
bearing_rad = (35+0.3)/2;
bearing_z = 8.75;
thrust_od = 35;
thrust_id = 20;
thrust_z = 5;

con_height = 2*(tube_rad+wall_thickness);
con_width  = 4*(tube_rad+wall_thickness);

// right side
//front_angle=124.6;
//front_camber=0;
//rear_angle=113.25;
//rear_camber =6;
//rear_rad = 10.2
//front_rad = tube_rad;

// left side
front_angle=-rocker_angle;
front_camber=rocker_camber;//6;
front_rad = 10.25;
rear_angle=rfa; //global
rear_camber =0;
rear_rad = tube_rad;

right_side = false;
label = "RJL2.6";
print = false;

module mock_bearing(bz) {

%translate([0,0,bz])
  difference() {
    cylinder(bearing_z,bearing_rad,bearing_rad);

    translate([0,0,-0.5])      
      cylinder(bearing_z+1,shaft_rad,shaft_rad);
  }    
    
}

//////////////////////////////////////////////////

module rockerJoint() {
  difference() {

    union() {
        cylinder(con_height*.75,con_width*.9,con_width*0.9);
                
        cylinder(con_height+bearing_z,bearing_rad+wall_thickness,
                  bearing_rad+wall_thickness,$fn=64);
        
  // diff arm/link shaft
      translate([-con_width/4-1,0,0])
        linear_extrude(height=con_height)
          square([con_width/2+2,con_width+5]);

  // 20mm shaft
      rotate([0,0,90-front_angle])
        translate([0,-(con_height+16)/2,0])
            cube([con_width,con_height+16,con_height+8]);
      translate([0,0,12])
        rotate([0,90-front_camber,90-front_angle])
          translate([0,0,20])
          cylinder(55,r=22);

  // front shaft
    rotate([0,0,rear_angle-180])
    translate( [0,0,wall_thickness+tube_rad])
      rotate([90-rear_camber,0,0])
        linear_extrude(height=con_width+tube_rad*2)
          square([(tube_rad+wall_thickness)*2+10,(tube_rad+wall_thickness)*2],center=true);

    }// end union
    ///////////////////////////
    // start difference section
    
    // clip z plane at zero
    translate([0,0,-10])
      cylinder(10,100,100);

  // front shaft
 #   rotate([0,0,90-front_angle])
      translate( [0,0,wall_thickness+tube_rad])
        rotate([0,90-front_camber,0])
        translate([0,0,bearing_rad+wall_thickness+7])
          cylinder(con_width+2,front_rad,front_rad,$fn=64);

  // rear shaft
    translate( [0,0,wall_thickness+tube_rad])
      rotate([90-rear_camber,0,rear_angle-180])
        translate([0,0,bearing_rad+wall_thickness+7])
        cylinder(con_width+tube_rad+1,
            rear_rad,rear_rad,$fn=64);

  // diff bar shaft
    translate( [0,0,wall_thickness+tube_rad])
      rotate([-90,0,0])
        translate([0,0,bearing_rad+wall_thickness])
        cylinder(con_width+5,tube_rad,tube_rad,$fn=64);


  // 16mm center hole
    translate([0,0,-0.5])
    cylinder(con_height+1,shaft_rad+0.3,shaft_rad+0.6,$fn=90);

  // thrust bearing    
  /*
  translate([0,0,-0.5])
    difference() {
    linear_extrude(height=thrust_z+0.3)
      circle(thrust_od/2);
      translate([0,0,-0.1])
        cylinder(thrust_z+0.5,thrust_id/2,thrust_id/2);
    }
  */

  // bearing    
    translate([0,0,thrust_z+5])
    linear_extrude(height=con_height)
      circle(bearing_rad,$fn=90);

  %mock_bearing(thrust_z+5);
  %mock_bearing(thrust_z+5+bearing_z);

  // air hole
    rotate([0,0,2])
      translate([0,-(bearing_rad+wall_thickness+8.5),-0.5])
      linear_extrude(height=con_height+1)
        circle(8);

  // air hole
    rotate([0,0,180+rear_angle/2])
      translate([0,-(bearing_rad+wall_thickness+8),-0.5])
      linear_extrude(height=con_height+1)
        circle(8);

  // air hole
    rotate([0,0,180-front_angle/2+11.5])
      translate([0,-(bearing_rad+wall_thickness+9),-0.5])
      linear_extrude(height=con_height+1)
        circle(7);

  // Rear Wire hole
    rotate([0,0,rear_angle-90-180])
      translate([bearing_rad+wall_thickness,-15/2,-0.5])
        linear_extrude(height=con_height/2+0.5+4)
          square([9,15]);

  // Front Wire hole
    rotate([0,0,90-front_angle])
      translate([bearing_rad+wall_thickness,-17/2,-0.5])
        linear_extrude(height=con_height/2+0.5+9)
          square([9,17]);

  // screw holes
  screw_hole_rad = bearing_rad+wall_thickness+24;

    translate([0,bearing_rad+wall_thickness+18,-0.1])
      cylinder(con_height+10,screw_rad,screw_rad);

    translate([cos(90-front_angle)*screw_hole_rad,sin(90-front_angle)*screw_hole_rad,-0.1])
      cylinder(con_height+20,screw_rad,screw_rad);

    translate([cos(90+rear_angle)*screw_hole_rad,sin(90+rear_angle)*screw_hole_rad,-0.1])
      linear_extrude(height=con_height+10)
        circle(screw_rad,center=true);

  }
}// end rockerJoint module

if (right_side)
  mirror([1,0,0]) rockerJoint();
else
  rockerJoint();

//rotate([0,-rear_camber,180])
translate([-10,bearing_rad+wall_thickness+8,con_height])
  linear_extrude(height=.3)
    text(label,5.0);
 
if (print)
  difference() {
    cylinder(0.3,75,75);
    translate([0,0,-0.1])
      cylinder(0.5,42,42);
  }