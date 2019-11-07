pan_x = 250;
pan_y = 400;

color("gray") cube([pan_x,pan_y,2]);
translate([-50,-12,0])
  cube([50,pan_y+24,1]);
translate([pan_x,-12,0])
  cube([50,pan_y+24,1]);
color("orange") {
translate([0,-50,0])
  cube([pan_x,50,1]);
translate([0,pan_y,0])
  cube([pan_x,50,1]);
  
echo("width=",pan_y+100,(pan_y+100)/25.4);
echo("height",pan_x+100,(pan_x+100)/25.4);  
}