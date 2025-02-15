% MATLAB代码: 三相正弦电压波形的生成和绘制（包括相加后的波形）

% 清空工作区，关闭所有图窗，清空命令窗口
clear;
clc;
close all;

% 参数设置
Vm = 1;          % 最大电压幅值
f = 50;          % 频率 (Hz)
omega = 2 * pi * f; % 角频率 (rad/s)
T = 1 / f;       % 周期 (s)
t = linspace(0, 2*T, 1000); % 时间向量，两个周期

% 三相正弦电压波形
V_A = Vm * sin(omega * t);
V_B = Vm * sin(omega * t - 2*pi/3); % 相位延迟120度
V_C = Vm * sin(omega * t - 4*pi/3); % 相位延迟240度

% 三相电压相加
V_sum = V_A + V_B + V_C;

% 绘制三相正弦电压波形及其相加后的波形
figure;
plot(t, V_A, 'r', 'LineWidth', 1.5); hold on;
plot(t, V_B, 'g', 'LineWidth', 1.5);
plot(t, V_C, 'b', 'LineWidth', 1.5);
plot(t, V_sum, 'k--', 'LineWidth', 2); % 相加后的结果用黑色虚线表示

% 设置图形属性
title('三相正弦电压波形及其相加后的波形');
xlabel('时间 (s)');
ylabel('电压 (V)');
legend('V_A', 'V_B', 'V_C', 'V_A + V_B + V_C');
grid on;
axis tight;

% 显示图形
hold off;
