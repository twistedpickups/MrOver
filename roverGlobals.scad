// roverGlobals

ground_clearance = 245;
hub_tube_offset = 8.3+6;
corner_offset = 8.3 + 6;

frame_width = 500+corner_offset*2;

rocker_x = (frame_width-50+6)/3;
rocker_z = 86;

frame_z = 126.4;

steering_z = 122+3;  
rocker_y = frame_width/2+hub_tube_offset+5+20+40;
rocker_yz= 12.2;//tube center offset on y axis to model z
rfa = 123.6;//120; // rocker front tube angle
rocker_angle = -106.5;// rear 20mm tube angle
rocker_camber = 5.05;

bjrz = 15; // bogie joint rear z tube offset
bjrh = 34.4; // from model
bjry = rocker_y+rocker_yz+bjrz;
bogie_joint_z = -35.5;// random point in space that looked good!
bjfh= 31;
bjfz= 19; // tube z offset from model top
bjfy= bjry + 5;
bjfa = 108.4;// front angle
bjra = 108.9;// rear angle

wheel_rad = 75;
wheel_width = 90;
wheel_clear = 3;
whub_z = wheel_width/2-5;

front_x_angle = 34.18;
mid_x_angle = 28.2;
grub_rad = 1.5;
