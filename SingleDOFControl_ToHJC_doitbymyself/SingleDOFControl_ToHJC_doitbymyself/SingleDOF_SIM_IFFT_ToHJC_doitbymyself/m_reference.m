

load DATA\SDATA_Position.dat;
load DATA\SDATA_Velocity.dat;
load DATA\SDATA_Acceleration.dat;
load DATA\SDATA_Jerk.dat;
load DATA\SDATA_Snap.dat;

r = SDATA_Position; 
v = SDATA_Velocity;
a = SDATA_Acceleration;

clear SDATA_Position SDATA_Velocity SDATA_Acceleration;

save('DATA\Reference.mat','r','v','a');

