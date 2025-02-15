%从DATA文件夹中加载名为SDATA_Position.dat的文件，并将其内容存储到变量SDATA_Position中
%load命令默认将文件名（不包括路径和扩展名）用作变量的名称
load DATA\SDATA_Position.dat;
load DATA\SDATA_Velocity.dat;
load DATA\SDATA_Acceleration.dat;
load DATA\SDATA_Jerk.dat;
load DATA\SDATA_Snap.dat;

%为了方便打字调用，将变量重命名为简单且易懂的
r = SDATA_Position; 
v = SDATA_Velocity;
a = SDATA_Acceleration;

%清除原变量，释放内存
clear SDATA_Position SDATA_Velocity SDATA_Acceleration;

%将多个数据变量保存到一个.mat文件中，方便访问调用
%为什么.dat转.mat可以方便调用:.mat文件可以同时存储多个变量，将多个数据集保存到一个文件，且是二进制文件格式，加载速度非常快。而.dat文件通常是文本文件，MATLAB需要逐行读取并解析文本数据，过程相对较慢。
save('DATA\Reference.mat','r','v','a');