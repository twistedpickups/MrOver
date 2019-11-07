include <RoverGlobals.scad>;
// included: front_x_angle
tube_rad = 8+0.3;
screw_rad = 1.5;
wall_thickness = 6;

con_height = 2*(tube_rad+wall_thickness);
con_width  = 4*(tube_rad+wall_thickness);

ver = "FC1.1";
left_side = true;

module frontCorner() {
  difference() {

  //    translate([tube_rad+wall_thickness,tube_rad+wall_thickness,0])
    union() {    
      translate([-(tube_rad+wall_thickness+1),-(tube_rad+wall_thickness+1),-con_height/2])
        cube([con_width+1,con_width+tube_rad+1,con_height]);
      translate([0,0,2.5])
      cylinder(con_height+5,tube_rad+wall_thickness,tube_rad+wall_thickness,center=true);
    }
      
  //  translate( [con_width/2,0,0])
      rotate([0,90,0])
       translate([0,0,15])
        cylinder(con_width,tube_rad,tube_rad,$fn=120);
      
      rotate([-90,0,0])
       translate([0,0,15])
        cylinder(con_width,tube_rad,tube_rad,$fn=120);

      translate([0,0,-con_height/2-1])
        linear_extrude(con_height+7)
          circle(tube_rad,center=true,$fn=120);
      
      translate([0,con_width+4,-con_height/2-1])
        rotate([0,0,-front_x_angle])
        linear_extrude(con_height+5)
          square(con_width);
      
      translate([0,0,0])
        rotate([0,90,90-front_x_angle])
          translate([0,0,27])
          cylinder(100,tube_rad,tube_rad,$fn=120);

      translate([con_width-tube_rad-(tube_rad+wall_thickness),0,0])
        cylinder(con_height,screw_rad,screw_rad);
                      
      translate([0,con_width-tube_rad-(tube_rad+wall_thickness)+5,0])
        cylinder(con_height,screw_rad,screw_rad);

      rotate([0,0,-front_x_angle])
      translate([0,con_width-tube_rad-(tube_rad+wall_thickness)+5,0])
        cylinder(con_height,screw_rad,screw_rad);

      translate([0,-(tube_rad+wall_thickness)-1,con_height*0.25])
        rotate([-90,0,0])
        cylinder(con_height,screw_rad,screw_rad);

      translate([0,-(tube_rad+wall_thickness)-1,-con_height*0.25])
        rotate([-90,0,0])
        linear_extrude(height=wall_thickness+2)
          circle(screw_rad,center=true);

      translate([-(tube_rad+wall_thickness)-1,0,con_height*0.25])
        rotate([0,90,0])
        linear_extrude(height=wall_thickness+2)
          circle(screw_rad,center=true);

      translate([-(tube_rad+wall_thickness)-1,0,-con_height*0.25])
        rotate([0,90,0])
        linear_extrude(height=wall_thickness+2)
          circle(screw_rad,center=true);
  }
}

if (left_side) {
  frontCorner();
  translate([0,20,con_height/2])
   linear_extrude(height=0.4)
    text(str(ver,"-L"),6);  
}
else
{
  mirror([0,1,0])
    frontCorner();
  translate([0,-25,con_height/2])
   linear_extrude(height=0.4)
    text(str(ver,"-R"),6);
}