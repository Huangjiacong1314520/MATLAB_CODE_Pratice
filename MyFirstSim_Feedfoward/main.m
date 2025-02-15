clear; 
clc; 
close all;
format long g;                                                             %format：控制数值在命令行窗口的显示格式（长、短、最简分数），不改变工作区中变量的实际值。                                                   


% 控制对象传递函数建模与参数赋值
mass = 477;
numerator_P = [1];
denominator_P = [mass 0 0];
P = tf(numerator_P,denominator_P);



% 参考轨迹
reference_in_main;



% 扰动

% 已知结构的扰动----直接simulink框图中加入进去的（名称为sfun_Cogging的S-Function）
% 这里是给扰动的参数赋值
global theta_true;
theta_true = [23.85 1.4 -2.4 1.9 4.3 1.0 -4.2]'*20;                        
n = 7;                                                                     %在sfun_Cogging.m文件中可以找到详细的扰动量设置（为了展示扰动前馈的效果，所以这里设置的扰动是已知的，我们也就通过这个已知的量去设置扰动前馈） 

%在后面就需要用到仿真参数了
% 仿真参数设置
ts = 0.0002;                                                               %MATLAB会根据赋给变量的值自动推断其数据类型（整数也识别为double）：double、字符串、逻辑类型。可以强转。
k_uf = 1/20;                                                               %e = int32(a); % 将 a 转换为 32 位整数   f = single(b); % 将 b 转换为单精度浮点数

N = length(r);                                                      
t_end = (N-1)*ts;                                                          %计算每次仿真总时间：参考轨迹的数据点，这是相当于一个对齐复原采样操作，把数据点和时间结合起来
t = 0:ts:t_end; t = t';                                                    %创建一个时间行向量 t，从 0 开始，以步长 ts 递增，直到 t_end。并转置为列向量。


% 随机扰动&测量噪声 在控制上都无能为力

simin_d = [t randn(N,1)*0.1];                                              
simin_v = [t randn(N,1)*1e-9]; 

% 未知结构但并不随机的扰动——未补充



% 反馈控制器----
num_Cfb = [179824.76349148  33696607.3425078  876981355.154548];           %这些值是怎么得到的呢？
den_Cfb  = [0.00109873559912302  1  0];
Cfb = tf(num_Cfb,den_Cfb); 



% 前馈控制器的三种情况 通过相同的simulink模型进行仿真，因此变量设置需要一致，不断重新赋值

% 无前馈
simin_r = [t r];                                                           % simin_r 是一个矩阵，它将时间向量 t 和参考信号 r 组合在一起。                                                                         % t表示仿真的时间点，而 r 表示在这些时间点下的参考输入或目标值。这个矩阵通常用于给 Simulink 模型提供参考信号。
simin_u = [t zeros(N,1)];                                                  % 时间t 与 控制输入u，但这里u是0，即没有控制输入（无前馈）                     
simin_d = [t randn(N,1)*0.1];                                              % 时间t 与 随机扰动1
simin_v = [t randn(N,1)*1e-9];                                             % 时间t 与 随机扰动2 测量噪声
sim('Sim_MyFirst');                                                        % 调用simulink模型Sim_singleDOF1.slx仿真。sim是用于启动simulink模型仿真的命令。
err0 = r - y;

save('E:\A_Motion_Control_Team\MATLAB_CODE_Pratice\MyFirstSim_Feedfoward\DATA\matlab_nn_train.mat', 'y');    %用于生成MATLAB神经网络工具箱训练数据，作为神经网络的输入


%仿真 - 加速度前馈
simin_r = [t r];
uff = a*mass;                                                              %改变了uff，前馈控制输入是ma
simin_u = [t uff];      
simin_d = [t randn(N,1)*0.1]; 
simin_v = [t randn(N,1)*1e-9]; 
sim('Sim_MyFirst');
err1 = r - y;

%仿真 - 加速度前馈+扰动前馈（解决空间扰动sfun_Cogging）
%%扰动误差包括三部分：首先是已知结构的，也就是我们这里进行前馈想要消除的；其次是随机扰动，无法进行控制；最后还有未知结构的扰动，这种扰动我们不知道形式，但是可以用神经网络前馈解决
simin_r = [t r];
uff1 = a*mass;                                                             %控制对象模型是1/ms^2，则加速度前馈的传函是ms^2，s相当于微分，r*s^2就是a，mr*s^2就是ma。即加速度前馈的输入控制值。
tao = 0.012;                                                               %时间常数τ
w1 = pi/tao; 
w2 = pi/(2/3*tao);
PSI_rf = [a -sin(w1*r) -cos(w1*r) -sin(2*w1*r) -cos(2*w1*r) ...            %怪不得扰动参数向量第一个数是477呢，477就是mass的值。PSI_rf与theta_true相乘，相当于给a,sin(w1*r),cos(w1*r)等都乘上了系数。477a-28sin(w1*r)+……
            -sin(w2*r) -cos(w2*r)];
uff = PSI_rf*theta_true;

simin_u = [t uff];       
simin_d = [t randn(N,1)*0.1]; 
simin_v = [t randn(N,1)*1e-9]; %1e-9
sim('Sim_MyFirst');
err2 = r - y;


figure(2);
plot(t,err0,'k','linewidth',1.2);
hold on;
plot(t,err1,'b','linewidth',1.2);
plot(t,err2,'r','linewidth',1.2);
set(figure(2),'Name', '误差比较');
title('控制误差比较');
xlabel('时间（s）');
ylabel('误差（m）');






