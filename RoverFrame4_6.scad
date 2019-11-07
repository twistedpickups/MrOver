use <MCAD/motors.scad>;
use <arduino2.scad>;
include <RoverGlobals.scad>;

render_all = false;
render_frame = true;
render_diff  = true;
render_susp  = true;
render_shell = false;
render_solar = false;
render_arm   = false;
render_head  = true;




module carbon_tube( length=500, c=false) {
  color("black")
    difference() {
      cylinder(length,8,8,center=c);
      translate([0,0,-0.5])
      cylinder(length+1,7,7,center=c);
    }        
}

module carbon_tube20( length=500, c=false) {
  color("black")
    difference() {
      cylinder(length,10,10,center=c);
      translate([0,0,-0.5])
      cylinder(length+1,9,9,center=c);
    }        
}

module tie_rod(length = 220) {

    union() {
      difference() {
        cylinder(12,12.5,12.5,center=true);
        cylinder(12,4,4,center=true);
      }
      translate([length,0,0])
      rotate([90,0,0])
      difference() {
        cylinder(12,12.5,12.5,center=true);
        cylinder(12,4,4,center=true);
      }
      translate([12,0,0])
        rotate([0,90,0])
          cylinder(length-24,6,6);
    }
}// end tie_rod module

module thrust_bearing(diam=20) {
if (diam==8)
  difference() {
    cylinder(5,8,8);
    translate([0,0,-1])    
    cylinder(5+2,4,4);
  }
else
  difference() {
    cylinder(10,37/2,37/2);
    translate([0,0,-1])    
    cylinder(12,diam/2,diam/2);
  }    
}

module solar_panel() {
 translate([0,0,35/2])
   color("white")
   difference() {
     cube([996,665,35],center=true);
     translate([-(996-20)/2,-(665-20)/2,-35/2])
       cube([996-20,665-20,35-5]);
   }
   color("blue")
   translate([-950/2,-630/2,35])
   cube([950,630,1]);
}

module bolt_8mm(length=30) {
  rotate([180,0,0])
  union() {
      cylinder(5,6,6,$fn=6);
      translate([0,0,5])
        cylinder(length,r=4);    
  }
}

module bolt_16mm(length=30) {
  rotate([180,0,0])
  union() {
      cylinder(5,r=10,$fn=6);
      translate([0,0,5])
        cylinder(length,r=8);    
  }
}

module panHead() {
  translate([0,0,0])
  rotate([0,180,180])
   color("green")
    import("..\\Solar\\Heliostat\\AziMotorBracket4.stl");
  // azi motor
  translate([0,0,-6])
    stepper_motor_mount(17);
    
  // alt bracket  
  translate([0,-3,100])
    rotate([-90,0,0])
     color("purple")
      import("..\\Solar\\Heliostat\\AltMotorBracket2.stl");


  translate([0,4,100])
  rotate([90,95,0]) {
    translate([0,0,45])
      color("white") import("..\\Solar\\Heliostat\\AltWheel.stl");
    color("black") rotate([-90,0,0]) cylinder(80,r=25);
    }

  translate([0,-130,100])
  rotate([-90,0,0])
  translate([0,0,45])
  color("green") import("..\\Solar\\Heliostat\\AltMotorShroud.stl");
}

module shell() {
// bottom
    translate([0,0,-corner_offset])
      cube([frame_width*2,frame_width,2],center=true);
// top
    translate([0,0,frame_z+corner_offset])
      cube([frame_width*2,frame_width,2],center=true);
// front
    translate([frame_width+corner_offset,0,frame_z/2])
      cube([2,frame_width,frame_z],center=true);
// back
  translate([-(frame_width+corner_offset)-2,0,frame_z/2])
      cube([2,frame_width,frame_z],center=true);
// right
    translate([0,-frame_width/2-corner_offset,frame_z/2])
      cube([frame_width*2,2,frame_z],center=true);
// left
    translate([0,frame_width/2+corner_offset,frame_z/2])
      cube([frame_width*2,2,frame_z],center=true);
}

pan_x = 250;
pan_y = 400;
pan_z = 50;
module midPan() {
  difference() {
    translate([-pan_x/2-1,-pan_y/2-1,0])
      cube([pan_x+2,pan_y+2,pan_z]);
    translate([-pan_x/2,-pan_y/2,1])
      cube([pan_x,pan_y,pan_z]);
  }
}

MEGA = 5;

module electronics() {
  color("orange")
  for (j=[-pan_y/2+6,pan_y/2-51])
  translate([74,j,0])
  for (i=[0:2])
    translate([0,0,i*17])
      minkowski() {
       cube([146,46,14]);
       sphere(2);
      }
  translate([149,-pan_y/2+52,0])
     color("red") cube([75,50,45]);
  translate([149,pan_y/2-101,0])
     color("red") cube([75,50,45]);

  translate([150,-50,0])
  rotate([0,0,90])
  import("..\\Solar\\Mega\\MegaBoardDesk.stl");
  translate([150,-50,10])
    rotate([0,0,90])
    translate([-28,-50,0])
      color("blue") arduino(MEGA);
  translate([150,50,0])
  rotate([0,0,90])
  import("..\\Solar\\Mega\\MegaBoardDesk.stl");
  translate([150,50,10])
    rotate([0,0,90])
    translate([-28,-50,0])
      color("blue") arduino(MEGA);


  // stepper driver board
  translate([30,0,0])
  rotate([0,0,0])
  import("..\\Solar\\Mega\\MegaBoardDesk.stl");
  translate([30,0,0])
    translate([-40,-50,0])
      color("blue") cube([80,100,20]);

}

////////////////////////////////////////////////////////

module frame() {
// left side
translate([-50,frame_width/2+hub_tube_offset,frame_z+hub_tube_offset])
rotate([90,90,0])
import("d:\\users\\markm\\3D Objects\\rover\\framehub2.stl");

// right side
translate([50,-frame_width/2-hub_tube_offset,frame_z+hub_tube_offset])
rotate([-90,90,0])
import("d:\\users\\markm\\3D Objects\\rover\\framehub2.stl");

// center cross braces
rotate([90,0,0])
carbon_tube(500,true);

translate([0,0,frame_z])
rotate([90,0,0])
carbon_tube(500,true);

translate([rocker_x,0,frame_z])
rotate([90,0,0])
carbon_tube(500,true);

translate([rocker_x,0,0])
rotate([90,0,0])
carbon_tube(500,true);

// right rocker hub
translate([50+rocker_x,-(frame_width/2+hub_tube_offset),
    frame_z+hub_tube_offset])
rotate([-90,90,0])
import("d:\\users\\markm\\3D Objects\\rover\\FrameHub3R.stl");


// left rocker hub
translate([-50+rocker_x,frame_width/2+hub_tube_offset,frame_z+hub_tube_offset])
rotate([90,90,0])
import("d:\\users\\markm\\3D Objects\\rover\\frameHub3L.stl");


// right top side tube
translate([-hub_tube_offset,-frame_width/2,frame_z])
rotate([0,-90,0])
carbon_tube();

translate([500+hub_tube_offset,-frame_width/2,frame_z])
rotate([0,-90,0])
carbon_tube();

// right bottom side tube
translate([-hub_tube_offset,-frame_width/2,0])
rotate([0,-90,0])
carbon_tube();

translate([500+hub_tube_offset,-frame_width/2,0])
rotate([0,-90,0])
carbon_tube();

// left top side tube
translate([-hub_tube_offset,frame_width/2,frame_z])
rotate([0,-90,0])
carbon_tube();

translate([500+hub_tube_offset,frame_width/2,frame_z])
rotate([0,-90,0])
translate([0,0,28.5])
//#carbon_tube(274);
carbon_tube();

// left bottom side tube
translate([-hub_tube_offset,frame_width/2,0])
rotate([0,-90,0])
carbon_tube();

translate([500+hub_tube_offset,frame_width/2,0])
rotate([0,-90,0])
carbon_tube();

// front horizontal tubes
translate([500+hub_tube_offset+corner_offset,-frame_width/2+corner_offset,0])
rotate([-90,0,0])
carbon_tube();

translate([500+hub_tube_offset+corner_offset,-frame_width/2+corner_offset,frame_z])
rotate([-90,0,0])
carbon_tube();


// rear horizontal tubes
translate([-500-hub_tube_offset-corner_offset,-frame_width/2+corner_offset,0])
rotate([-90,0,0])
carbon_tube();

translate([-500-hub_tube_offset-corner_offset,-frame_width/2+corner_offset,frame_z])
rotate([-90,0,0])
carbon_tube();


// front vertical tubes
translate([500+hub_tube_offset+corner_offset,-frame_width/2,-8])
carbon_tube(140);

translate([500+hub_tube_offset+corner_offset,frame_width/2,-8])
carbon_tube(140);

// rear vertical tubes
translate([-500-hub_tube_offset-corner_offset,-frame_width/2,-8])
carbon_tube(140);

translate([-500-hub_tube_offset-corner_offset,frame_width/2,-8-6.5])
carbon_tube(160);


// rear bottom diagonal tubes
translate([0,-frame_width/2,0])
rotate([0,0,45])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(320);

translate([0,frame_width/2,0])
rotate([0,0,135])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(320);

translate([-frame_width,-frame_width/2,0])
rotate([0,0,-45])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(320);

translate([-frame_width,frame_width/2,0])
rotate([0,0,-135])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(320);

// rear upper diagonal tubes
translate([0,-frame_width/2,frame_z])
rotate([0,0,45])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
//translate([0,0,15])
carbon_tube(296+22);

translate([0,frame_width/2,frame_z])
rotate([0,0,135])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(318);

translate([-frame_width,-frame_width/2,frame_z])
rotate([0,0,-45])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(318);

translate([-frame_width,frame_width/2,frame_z])
rotate([0,0,-135])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(318);
/*
translate([rocker_x,-frame_width/2,frame_z])
rotate([0,0,45])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(320);

translate([rocker_x,frame_width/2,frame_z])
rotate([0,0,135])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(320);
*/
/* front lower diagonal tubes
translate([0,-frame_width/2,0])
rotate([0,0,-45])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(320);

translate([0,frame_width/2,0])
rotate([0,0,-135])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(320);

translate([frame_width,-frame_width/2,0])
rotate([0,0,45])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(320);

translate([frame_width,frame_width/2,0])
rotate([0,0,135])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(320);
*/

//front_x_angle = 34.18; -- in globals
// front upper diagonal tubes
translate([frame_width,-frame_width/2,frame_z])
rotate([0,0,front_x_angle])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
//translate([0,0,22])
carbon_tube(242+23);
//so tube length is 264 (1mm each end)

translate([frame_width,frame_width/2,frame_z])
rotate([0,0,180-front_x_angle])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(580);
//lower
translate([frame_width,-frame_width/2,0])
rotate([0,0,front_x_angle])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(580);

translate([frame_width,frame_width/2,0])
rotate([0,0,180-front_x_angle])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(580);


// middle upper diagonal tubes
//mid_x_angle = 29; -- in globals

translate([rocker_x-8.2,-frame_width/2,frame_z])
rotate([0,0,mid_x_angle])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
translate([0,0,-2])
 carbon_tube(260);

translate([rocker_x-8.2,frame_width/2,frame_z])
rotate([0,0,180-mid_x_angle])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(260);

translate([rocker_x-8.2,-frame_width/2,0])
rotate([0,0,mid_x_angle])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(260);

translate([rocker_x-8.2,frame_width/2,0])
rotate([0,0,180-mid_x_angle])
translate([0,2*hub_tube_offset,0])
rotate([-90,0,0])
carbon_tube(260);
////////////////////////////////////////////////////////

// rear corner brackets

translate([-frame_width-corner_offset,frame_width/2+hub_tube_offset,frame_z-corner_offset])
rotate([0,0,270])
import("d:\\users\\markm\\3D Objects\\rover\\16mmcorner6mmWall.stl");

translate([-frame_width-corner_offset,frame_width/2+hub_tube_offset,-corner_offset])
rotate([0,0,270])
import("d:\\users\\markm\\3D Objects\\rover\\16mmcorner6mmWall.stl");

translate([-frame_width-corner_offset,-frame_width/2-hub_tube_offset,-hub_tube_offset])
//rotate([-90,-90,0])
import("d:\\users\\markm\\3D Objects\\rover\\16mmcorner6mmWall.stl");

translate([-frame_width-corner_offset,-frame_width/2-hub_tube_offset,frame_z-hub_tube_offset])
//rotate([-90,-90,0])
import("d:\\users\\markm\\3D Objects\\rover\\16mmcorner6mmWall.stl");


// front corner brackets
//bottom
translate([frame_width,frame_width/2,0])
rotate([0,0,180])
import("FrontCornerLeft.stl");

translate([frame_width,-frame_width/2,0])
rotate([0,0,180])
import("FrontCornerRight.stl");

//top
translate([frame_width,frame_width/2,frame_z])
  rotate([0,0,180])

    import("FrontCornerLeft.stl");

translate([frame_width,-frame_width/2,frame_z])
rotate([0,0,180])
  import("FrontCornerRight.stl");

// lower front cross brace
translate([(frame_width+rocker_x)/2+4,0,-12.2])
//rotate([0,0,-45])
import("d:\\users\\markm\\3D Objects\\rover\\CrossBraceFront.stl");

// upper front cross brace
translate([(frame_width+rocker_x)/2+4,0,frame_z-12.2])
//rotate([0,0,-45])
import("d:\\users\\markm\\3D Objects\\rover\\CrossBraceFront.stl");
}
// end frame() module
////////////////////////////////////////////////////
// Differential Bar Section
////////////////////////////////////////////////////
tie_rod_len = 210;
diff_bar_z = 170;
module diffBar() {
// lower rear bar cross brace
translate([-frame_width/2,0,-12.2])
rotate([0,0,135])
import("d:\\users\\markm\\3D Objects\\rover\\crossBrace2Whole.stl");

// upper rear cross brace
translate([-frame_width/2,0,frame_z-12.2])
rotate([0,0,135])
import("d:\\users\\markm\\3D Objects\\rover\\crossBrace2Whole.stl");

// diff bar mounting shaft
translate([rocker_x-tie_rod_len,0,-corner_offset])
  carbon_tube(180);

// diff mount bung
translate([rocker_x-tie_rod_len,0,diff_bar_z-corner_offset+10])
rotate([180,0,0])
import("d:\\users\\markm\\3D Objects\\rover\\DiffBung.stl");

  
// Differential Bar  
translate([rocker_x-tie_rod_len,0,diff_bar_z])
rotate([0,0,90]) color("grey")
import("d:\\users\\markm\\3D Objects\\rover\\DiffBar690.stl");

color("LightGray")
translate([rocker_x-tie_rod_len,0,diff_bar_z+35])
  bolt_8mm(50);
  
// Bearing block  
translate([rocker_x-tie_rod_len,0,diff_bar_z+2])
rotate([0,0,90]) color("white")
import("d:\\users\\markm\\3D Objects\\rover\\DiffBarCenterBearings.stl");
  
// left diff link tube
translate([rocker_x,rocker_y+rocker_yz,rocker_z+21.6])
carbon_tube(66);

color("LightGray")
translate([rocker_x,rocker_y+rocker_yz,diff_bar_z+27])
  bolt_8mm(50);

// left tie rod
translate([rocker_x,rocker_y+rocker_yz,diff_bar_z+14])
rotate([0,0,180])
color("Blue")
tie_rod(tie_rod_len);

color("LightGray")
translate([-tie_rod_len+rocker_x,rocker_y+rocker_yz+12,diff_bar_z+26.7/2])
rotate([-90,0,0])
  bolt_8mm(50);


// right tie rod
translate([rocker_x,-(rocker_y+rocker_yz),diff_bar_z+14])
rotate([0,0,180])
color("Blue")
tie_rod(tie_rod_len);

color("LightGray")
translate([rocker_x-tie_rod_len,-(rocker_y+rocker_yz+12),diff_bar_z+26.7/2])
rotate([90,0,0])
  bolt_8mm(50);

// right diff link tube
translate([rocker_x,-(rocker_y+rocker_yz),rocker_z+21.6])
carbon_tube(66);

color("LightGray")
translate([rocker_x,-(rocker_y+rocker_yz),diff_bar_z+27])
  bolt_8mm(50);

// left diff link bung
translate([rocker_x,rocker_y+rocker_yz,diff_bar_z+5])
rotate([180,0,0])
import("d:\\users\\markm\\3D Objects\\rover\\DiffBung.stl");


// right diff link bung
translate([rocker_x,-(rocker_y+rocker_yz),diff_bar_z+5])
rotate([180,0,0])
import("d:\\users\\markm\\3D Objects\\rover\\DiffBung.stl");

// upper diff bar mount
translate([rocker_x-tie_rod_len,0,frame_z])
//rotate([180,0,0])
import("d:\\users\\markm\\3D Objects\\rover\\DiffBarMount2.stl");

// lower diff bar mount
translate([rocker_x-tie_rod_len,0,0])
//rotate([180,0,0])
import("d:\\users\\markm\\3D Objects\\rover\\DiffBarMount2.stl");
}
//////////////////////////////////////////
// end Differential Section
//////////////////////////////////////////
/*
steering_z = 122+3;  
rocker_y = frame_width/2+hub_tube_offset+5+20;
rocker_yz= 12.2;//tube center offset on y axis to model z
rfa = 123.6;//120; // rocker front tube angle
rocker_angle = -106.5;// rear 20mm tube angle
rocker_camber = 5.05;
*/

// right rocker joint
translate([rocker_x,-rocker_y,rocker_z])
rotate([90,0,0])
color("green")
import("d:\\users\\markm\\3D Objects\\rover\\RockerJoint2_5Right.stl");

// left rocker shaft
translate([rocker_x,rocker_y-110,rocker_z])
rotate([90,0,180]) color("white")
  cylinder(150,8,8);

// right rocker shaft
translate([rocker_x,-rocker_y+110,rocker_z])
rotate([90,0,0]) color("white")
  cylinder(150,8,8);
  
// left rocker joint
translate([rocker_x,rocker_y,rocker_z])
rotate([90,0,180])
  color("green")
    import("d:\\users\\markm\\3D Objects\\rover\\RockerJoint2_6Left.stl");

translate([rocker_x,rocker_y+5,rocker_z])
rotate([90,0,0]) color("red")
  thrust_bearing();
translate([rocker_x,-(frame_width/2+18),rocker_z])
rotate([-90,0,0]) color("red")
  thrust_bearing();
  
// rocker bushing
translate([rocker_x,rocker_y-5,rocker_z])
rotate([90,0,0]) color("purple")
  difference() {
    cylinder(30,r=19);
    cylinder(20,8,8);
  }

// front left wheel tubes
translate([rocker_x,rocker_y+rocker_yz,rocker_z])
  rotate([0,rfa,0])
   translate([0,0,31])
    carbon_tube(319);

// front left steering bracket
translate([frame_width-50,rocker_y+rocker_yz,-ground_clearance+steering_z])//+27.3])
rotate([0,0,90])
  color("green")
    import("d:\\users\\markm\\3D Objects\\rover\\SteeringMotorBracketFront2_4.stl");

translate([frame_width-43,rocker_y+rocker_yz,-ground_clearance+steering_z])
  rotate([180,0,0])
    stepper_motor_mount(17,0,true);

// front left thrust bushing
translate([frame_width-43,rocker_y+rocker_yz,-ground_clearance+steering_z-10])
  color("red")
    thrust_bearing();

// front left wheel bracket
translate([frame_width-43,rocker_y+rocker_yz-8,-ground_clearance+25])
rotate([90,0,180]) 
union() {
  color("green")
    import("d:\\users\\markm\\3D Objects\\rover\\WheelHub3_3.stl");
color([0.1,0.1,0.1])
    translate([0,0,-45+3]) // 3mm wheel clearance to motor
    rotate([0,180,0])
    import("d:\\users\\markm\\3D Objects\\rover\\RoverWheel3_1.stl");

    translate([0,0,0]) // 3mm wheel clearance to motor
    stepper_motor_mount(17.1,0,true);
}
    
// left rocker tube
translate([rocker_x,rocker_y+rocker_yz+1,rocker_z])
  rotate([-rocker_camber,rocker_angle,0])
   translate([0,0,31])
    carbon_tube20(371);
// right rocker tube
translate([rocker_x,-rocker_y-rocker_yz,rocker_z])
  rotate([rocker_camber,rocker_angle,0])
   translate([0,0,31])
    carbon_tube20(371);

//////////////////////////
// Right Rocker/Front Wheel

// front right wheel tube
translate([rocker_x,-(rocker_y+rocker_yz),rocker_z])
  rotate([0,rfa,0])
   translate([0,0,31])
    carbon_tube(321.5);

// front right steering bracket
translate([frame_width-50,-(rocker_y+rocker_yz),-ground_clearance+steering_z])
rotate([0,0,90]) color("green")
import("d:\\users\\markm\\3D Objects\\rover\\SteeringMotorBracketFront2_4.stl");

translate([frame_width-43,-(rocker_y+rocker_yz),-ground_clearance+steering_z])
  rotate([180,0,0])
    stepper_motor_mount(17.1,0,true);
// front right thrust bushing
translate([frame_width-43,-(rocker_y+rocker_yz),-ground_clearance+steering_z-10])
  color("red")
    thrust_bearing();

// front right wheel bracket
translate([frame_width-43,-(rocker_y+rocker_yz-8),-ground_clearance+25])
rotate([90,0,0]) 
union() {
  color("green")
    import("d:\\users\\markm\\3D Objects\\rover\\WheelHub3_3.stl");
color([0.1,0.1,0.1])
    translate([0,0,-45+3]) // 3mm wheel clearance to motor
    rotate([0,180,0])
    import("d:\\users\\markm\\3D Objects\\rover\\RoverWheel3_1.stl");

    translate([0,0,0]) // 3mm wheel clearance to motor
    stepper_motor_mount(17.1,0,true);
}


///////////////////////////////////////////////
// Bogie Sections
////////////////////////////////////////////////
//echo(asin((59-rocker_yz)/530));

/*
bjrz = 15; // bogie joint rear z tube offset
bjrh = 34.4; // from model
bjry = rocker_y+rocker_yz+bjrz;
bogie_joint_z = -35.5;// random point in space that looked good!
bjfh= 31;
bjfz= 19; // tube z offset from model top
bjfy= bjry + 5;
bjfa = 108.4;// front angle
bjra = 108.9;// rear angle
*/
// left front bogie joint
translate([-250,bjfy,bogie_joint_z])
rotate([-90,90+rocker_angle+0.5,0])
color("green")
  import("d:\\users\\markm\\3D Objects\\rover\\BogieJointFrontLeft2_4.stl");

//color("white")
translate([-250,bjfy+32-77,bogie_joint_z])
rotate([90,0,0])
//  bolt_8mm(80);
  %bolt_16mm(80);

// thrust bearing
translate([-250,bjfy-10,bogie_joint_z])
rotate([-90,0,0])
color("Red")
  thrust_bearing(16);

translate([-250,bjfy-10,bogie_joint_z])
rotate([-90,0,0])
color("blue")
import("d:\\users\\markm\\3D Objects\\rover\\ThrustBushing16mm.stl");


//left rear/bogie joint
translate([-250,bjry,bogie_joint_z])
rotate([90,270-bjra,0])
color("green")
import("d:\\users\\markm\\3D Objects\\rover\\BogieJoint3_7.stl");

// left center/front bogie wheel tube
translate([-250,bjry-bjrz,bogie_joint_z])
  rotate([0,bjfa,0])
  //rotate([camber,0,0])
  // bearing_rad+wall+7 = 17.6+4+7 = 28.6
   translate([0,0,28.6])
    carbon_tube(243);

// left rear bogie wheel tube
translate([-250,bjry-bjrz,bogie_joint_z])
  rotate([0,-bjra,0])
   rotate([0,0,0])
   translate([0,0,28.6])
    carbon_tube(188);

// center left wheel bracket
translate([0,rocker_y+rocker_yz-3,-ground_clearance+45-20])
rotate([90,0,180]) 
union() {
  color("green")
import("d:\\users\\markm\\3D Objects\\rover\\BogieWheelMotorLeft3_1.stl");
color([0.1,0.1,0.1])
    translate([0,0,-45+3]) // 3mm wheel clearance to motor
    rotate([0,180,0])
    import("d:\\users\\markm\\3D Objects\\rover\\RoverWheel3_1.stl");

    translate([0,0,0]) // 3mm wheel clearance to motor
    stepper_motor_mount(17.1,0,true);
}


// left rear steering bracket
translate([-frame_width+50-6.5,rocker_y+rocker_yz,-ground_clearance+steering_z])
rotate([0,0,-90])
color("green")
import("d:\\users\\markm\\3D Objects\\rover\\SteeringMotorBracketRear2_4.stl");

translate([-frame_width+50-6.5,rocker_y+rocker_yz,-ground_clearance+steering_z+5])
  rotate([180,0,0])
    stepper_motor_mount(17,0,true);

// left rear thrust bushing
translate([-frame_width+50-6.5,rocker_y+rocker_yz,-ground_clearance+steering_z-10])
  color("red")
    thrust_bearing();
    
// left rear wheel bracket & wheel
translate([-(frame_width-43.5),rocker_y+rocker_yz-8,-ground_clearance+25])
rotate([90,0,180]) 
union() {
  color("green")
    import("d:\\users\\markm\\3D Objects\\rover\\WheelHub3_3.stl");
color([0.1,0.1,0.1])
    translate([0,0,-45+3]) // 3mm wheel clearance to motor
    rotate([0,180,0])
    import("d:\\users\\markm\\3D Objects\\rover\\RoverWheel3_1.stl");

    translate([0,0,0]) // 3mm wheel clearance to motor
    stepper_motor_mount(17.1,0,true);
}


/////////////////////////////////////////////
// end left bogie section
////////////////////////////////////////////

// RIGHT bogie section - copied from left

// right front bogie joint
translate([-250,-bjfy,bogie_joint_z])
rotate([90,90+rocker_angle+0.5,0])
  color("green")
    import("d:\\users\\markm\\3D Objects\\rover\\BogieJointFrontRight2_4.stl");

color("white")
translate([-250,-(bjfy+32-77),bogie_joint_z])
rotate([-90,0,0])
  bolt_16mm(80);

// thrust bearing
translate([-250,-(bjry-5),bogie_joint_z])
rotate([90,0,0])
color("Red")
  thrust_bearing();

translate([-250,-(bjfy-5),bogie_joint_z])
rotate([90,0,0])
color("Blue")
import("d:\\users\\markm\\3D Objects\\rover\\ThrustBushing16mm.stl");

// right rear/bogie joint
translate([-250,-bjry,bogie_joint_z])
rotate([-90,270+bjra,0]) color("green")
import("d:\\users\\markm\\3D Objects\\rover\\BogieJoint3_7.stl");

// right center/front bogie wheel tube
translate([-250,-(bjry-bjrz),bogie_joint_z])
  rotate([0,bjfa,0])
  //rotate([camber,0,0])
   translate([0,0,28.6])
    carbon_tube(243);

// right rear bogie wheel tube
translate([-250,-(bjry-bjrz),bogie_joint_z])
  rotate([0,-bjra,0])
   rotate([0,0,0])
   translate([0,0,28.6])
    carbon_tube(188);

// center right wheel bracket
translate([0,-(rocker_y+rocker_yz-8),-ground_clearance+45-20])
rotate([90,0,0]) 
union() {
  color("green")
import("d:\\users\\markm\\3D Objects\\rover\\BogieWheelMotor3_1Right.stl");
color([0.1,0.1,0.1])
    translate([0,0,-45+3]) // 3mm wheel clearance to motor
    rotate([0,180,0])
    import("d:\\users\\markm\\3D Objects\\rover\\RoverWheel3_1.stl");

    translate([0,0,0]) // 3mm wheel clearance to motor
    stepper_motor_mount(17.1,0,true);
}


// right rear steering bracket
translate([-frame_width+50-6.5,-(rocker_y+rocker_yz),-ground_clearance+steering_z])
rotate([0,0,-90]) color("green")
import("d:\\users\\markm\\3D Objects\\rover\\SteeringMotorBracketRear2_4.stl");

translate([-frame_width+50-6.5,-(rocker_y+rocker_yz),-ground_clearance+steering_z])
  rotate([180,0,0])
    stepper_motor_mount(17.1,0,true);

// right rear thrust bushing
translate([-frame_width+50-6.5,-(rocker_y+rocker_yz),-ground_clearance+steering_z-10])
  color("red")
    thrust_bearing();
    
// right rear wheel bracket
translate([-(frame_width-43.5),-(rocker_y+rocker_yz-8),-ground_clearance+45-20])
rotate([90,0,0]) 
union() {
  color("green")
    import("d:\\users\\markm\\3D Objects\\rover\\WheelHub3_3.stl");
color([0.1,0.1,0.1])
    translate([0,0,-45+3]) // 3mm wheel clearance to motor
    rotate([0,180,0])
    import("d:\\users\\markm\\3D Objects\\rover\\RoverWheel3_1.stl");

    translate([0,0,0]) // 3mm wheel clearance to motor
    stepper_motor_mount(17.1,0,true);
}


/////////////////////////////////////////////
// end right bogie section
/////////////////////////////////////////////


// FRONT piece
dbmx = 77-15;
shoulder_y = -160;
if (render_all || render_frame) {
  frame();
  // upper front mount
  translate([500+dbmx,shoulder_y,frame_z])
  rotate([0,0,180])
  import("d:\\users\\markm\\3D Objects\\rover\\VertBarMount.stl");

  // lower front mount
  translate([500+dbmx,shoulder_y,0])
  rotate([0,0,180])
  import("d:\\users\\markm\\3D Objects\\rover\\VertBarMount.stl");
}

if (render_all || render_diff)
  diffBar();

if (render_all || render_head) {
  // neck
  translate([500+dbmx,shoulder_y,0])
    carbon_tube(300);
  // head
   translate([500+dbmx,shoulder_y,450])
//   cylinder(75,60,60);
     panHead();
}

if (render_all || render_arm) { 
  // lower arm/shoulder
  translate([500+dbmx,shoulder_y,60])
  rotate([90,0,80])
  import("d:\\users\\markm\\3D Objects\\rover\\ArmShoulder.stl");
  //humorous
    translate([500+dbmx,shoulder_y,60])
     rotate([0,90,80])
      carbon_tube(350);

  elbow_x = 500+dbmx+sin(10)*350;
  elbow_y = shoulder_y+350*cos(10);

  // elbow
  translate([elbow_x,elbow_y,60])
  rotate([90,0,260])
  import("d:\\users\\markm\\3D Objects\\rover\\ArmShoulder.stl");

    translate([elbow_x,elbow_y,0])
      carbon_tube(200);

  translate([elbow_x,elbow_y,60+60])
  rotate([90,0,260+60])
  import("d:\\users\\markm\\3D Objects\\rover\\ArmShoulder.stl");
  // ulna
  translate([elbow_x,elbow_y,60+60])
     rotate([0,90,260+60])
      carbon_tube(300);
}

// mock skin/shell for body
if (render_all || render_shell)
//color("Grey")
  %shell();

translate([frame_width/3,0,12.2])
 color("white") midPan();
translate([75,0,15])
  electronics();

if (render_all || render_solar)
{
  // solar panel for top
  // front mast base
  color("black")
    translate([(frame_width+rocker_x)/2+4,0,0])
      cylinder(350,11,11);
  // rear mast base
  color("black")
    translate([-264,0,0])
      cylinder(350,11,11);

  // polar axis tube
  color("cyan")
    translate([0,0,350+16])
      rotate([0,90,0])
      cylinder(1000,9,9,center=true);

/*/ adjacent tubes for mast cable support
color("black")
  translate([-264,0,0])
    cylinder(frame_z+140,9,9);

color("black")
  translate([-264-29,0,0])
    cylinder(frame_z+140,9,9);
*/
translate([0,0,400])
  rotate([-0,0,0])
    %solar_panel();
}

color("gray") {
translate([-frame_width,-frame_width/2,frame_z-82.5])
  import("SensorBracket.stl");
translate([-frame_width,frame_width/2,frame_z-82.5])
  rotate([0,0,-90])
  import("SensorBracket.stl");

translate([frame_width,0+22.5,frame_z-126])
  rotate([180,0,180])
  rotate([90,90,0])
  import("MoProxSensorBracket.stl");
translate([-frame_width,0-22.5,frame_z-126])
  rotate([180,0,0])
  rotate([90,90,0])
  import("MoProxSensorBracket.stl");

translate([frame_width,-frame_width/2,frame_z-82.5])
  rotate([0,0,90])
  import("SensorBracket.stl");
translate([frame_width,frame_width/2,frame_z-82.5])
  rotate([0,0,180])
  import("SensorBracket.stl");
}

// ground level
%translate([0,0,-ground_clearance-50])
  cube([1500,1500,1],center=true);
  
/*
translate([0,rocker_y+rocker_yz,-ground_clearance-50-1])
  cube([1500,1,2],center=true);
*/ 
 
  