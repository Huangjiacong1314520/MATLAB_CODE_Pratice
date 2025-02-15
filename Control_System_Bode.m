% double-mass system定义参数
m1 = 1;    % the mass of the actuator (specifically, its mover)
m2 = 1;    % the mass of the load (e.g., the mirror block)
m = m1 + m2;

%    系数定义与赋值 In the general practice, it is common to have k1 = k2 = 0. For air/magnetic levitation case, it also follows that c1 = c2 = 0.
k1 = 0;    % k1 represent the stiffness of the actuator towards ground
c1 = 0;    % c1 represent the viscous damping of the actuator towards ground
k2 = 0;    % the equivalents for the load
c2 = 0;    % the equivalents for the load

k12 = 1;   % k12 and c12 indicate the stiffness and viscous damping between the actuator and the load
c12 = 1;   % 阻尼系数 c12

% 计算分母多项式系数
a3 = c2*m1 + c1*m2 + (m1+m2)*c12;
a2 = k1*m2 + k2*m1 + (m1+m2)*k12 + c1*c2 + (c1+c2)*c12;
a1 = k1*c2 + k2*c1 + (k1+k2)*c12 + (c1+c2)*k12;
a0 = k1*k2 + (k1+k2)*k12;

% 定义分母多项式的系数
denominator_Y12 = [m1*m2, a3, a2, a1, a0];
denominator_Ycog = [ m, 0, 0];

% 创建传递函数 Y1/U              tf 函数用于创建传递函数型
numerator_Y1 = [m2, (c2+c12), (k2+k12)];
sys_Y1 = tf(numerator_Y1, denominator_Y12);

% 创建传递函数 Y2/U
numerator_Y2 = [c12, k12];
sys_Y2 = tf(numerator_Y2, denominator_Y12);

% 创建传递函数 Ycog/U
numerator_Ycog = 1;
sys_Ycog = tf(numerator_Ycog, denominator_Ycog);


% 绘制波特图
figure;
bode(sys_Y1);
title('Bode Plot of Y1/U');
grid on;

figure;
bode(sys_Y2);
title('Bode Plot of Y2/U');
grid on;

figure;
bode(sys_Ycog);
title('Bode Plot of Ycog/U');
grid on;
