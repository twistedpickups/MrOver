
tube_offset = 35;
tube_rad = 8.2;
screw_rad = 2.7;

wall_thickness = 5;

con_height = 2*(tube_rad+wall_thickness);

//////////////////////////////////////////

difference() {
  union() {  
    hull() {
        cylinder(con_height,tube_rad+wall_thickness,tube_rad+wall_thickness,center=true);

        translate([tube_offset,con_height*3/2,0])
        rotate([90,0,0])
        cylinder(con_height*3,tube_rad+wall_thickness,tube_rad+wall_thickness);

        translate([tube_offset+tube_rad,-con_height*3/2,-(tube_rad+wall_thickness)])
        cube([tube_rad+wall_thickness,con_height*3,(tube_rad+wall_thickness)*2]);
    }
    cylinder(con_height,tube_rad+wall_thickness,tube_rad+wall_thickness);
    
    translate([-15-tube_rad,-5,-con_height/2])
      cube([15,10,con_height*1.5]);
  }
    translate([-15-tube_rad,-0.5,-con_height/2])
      cube([15,1,con_height*1.5]);

    translate([0,0,-con_height/2-1])
      cylinder(con_height*2,tube_rad,tube_rad,$fn=64);

    translate([tube_offset,(con_height+1)*3/2,0])
      rotate([90,0,0])
        cylinder(3*con_height+2,tube_rad,tube_rad,$fn=64);

// split halves
    translate([0,0,-0.5])
      cylinder(1,100,100);

// screw holes
  
    translate([tube_offset+tube_rad+wall_thickness+2,
        (con_height+1)*3/2-10,-con_height/2])
      cylinder(con_height*2,screw_rad,screw_rad,$fn=16);

    translate([tube_offset+tube_rad+wall_thickness+2,
        0,-con_height/2])
      cylinder(con_height*2,screw_rad,screw_rad,$fn=16);

    translate([tube_offset+tube_rad+wall_thickness+2,
        -((con_height+1)*3/2-10),-con_height/2])
      cylinder(con_height*2,screw_rad,screw_rad,$fn=16);

    translate([tube_offset-(tube_rad+wall_thickness+2),
        (con_height+1)*3/2-15,-con_height/2])
      cylinder(con_height*2,screw_rad,screw_rad,$fn=16);

    translate([tube_offset-(tube_rad+wall_thickness+2),
        0,-con_height/2])
      cylinder(con_height*2,screw_rad,screw_rad,$fn=16);

    translate([tube_offset-(tube_rad+wall_thickness+2),
        -((con_height+1)*3/2-15),-con_height/2])
      cylinder(con_height*2,screw_rad,screw_rad,$fn=16);


    translate([-(tube_rad+wall_thickness+5),
        0,con_height-8])
      rotate([90,0,0])
      cylinder(15,screw_rad,screw_rad,$fn=16,center=true);

    translate([-(tube_rad+wall_thickness+5),
        0,8])
      rotate([90,0,0])
      cylinder(15,screw_rad,screw_rad,$fn=16,center=true);

    translate([-(tube_rad+wall_thickness+5),
        0,-con_height/4])
      rotate([90,0,0])
      cylinder(15,screw_rad,screw_rad,$fn=16,center=true);

}