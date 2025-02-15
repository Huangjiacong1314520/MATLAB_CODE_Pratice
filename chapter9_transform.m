% 定义边界条件
P0 = 0; % 初始位置
Pf = 10; % 目标位置
V0 = 0; % 初始速度
Vf = 0; % 最终速度
T = 5; % 总时间

% 确定系数
a0 = P0;
a1 = V0;
a2 = (3*(Pf - P0) - (2*V0 + Vf)*T) / T^2;
a3 = (-2*(Pf - P0) + (V0 + Vf)*T) / T^3;

% 定义时间向量
t = linspace(0, T, 100);

% 计算位置、速度和加速度
P = a3*t.^3 + a2*t.^2 + a1*t + a0;
V = 3*a3*t.^2 + 2*a2*t + a1;
A = 6*a3*t + 2*a2;

% 绘制位置、速度和加速度曲线
figure;
subplot(3, 1, 1);
plot(t, P);
title('位置');
xlabel('时间 (s)');
ylabel('位置 (m)');

subplot(3, 1, 2);
plot(t, V);
title('速度');
xlabel('时间 (s)');
ylabel('速度 (m/s)');

subplot(3, 1, 3);
plot(t, A);
title('加速度');
xlabel('时间 (s)');
ylabel('加速度 (m/s^2)');
