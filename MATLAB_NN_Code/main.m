clear; clc; close all;
format long g;

%% ================= 系统参数 =================
mass = 477;
numerator_P = [1];
denominator_P = [mass 0 0];
P = tf(numerator_P,denominator_P);

% 参考轨迹
reference_in_main;

%% ================= 生成激励信号 =================
ts = 0.0002;                            % 采样时间
N = length(r);
t_end = (N-1)*ts;                                                          %计算每次仿真总时间：参考轨迹的数据点，这是相当于一个对齐复原采样操作，把数据点和时间结合起来
t = 0:ts:t_end; t = t'; 
N = length(t);

% 生成复合参考信号（包含扫频+阶跃+随机）
r_sweep = chirp(t, 1, t_end, 20, 'linear')';  % 1Hz到20Hz扫频
r_step = 0.5*(t > 0.5 & t < 1.5);             % 幅值0.5的阶跃
r_rand = 0.2*randn(N,1);                      % 随机噪声
r = r_sweep + r_step + r_rand;

% 生成训练用扰动信号
global theta_true;
theta_true = [23.85 1.4 -2.4 1.9 4.3 1.0 -4.2]'*20;  % 保持原有已知扰动
simin_d = [t randn(N,1)*0.1];               % 随机扰动1
simin_v = [t randn(N,1)*1e-9];              % 测量噪声

%% ================= 反馈控制器配置 =================
num_Cfb = [179824.76349148  33696607.3425078  876981355.154548];
den_Cfb  = [0.00109873559912302  1  0];
Cfb = tf(num_Cfb,den_Cfb); 

%% ================= 数据采集仿真 =================
% 配置输入信号
simin_r = [t r];                           % 参考轨迹
simin_u = [t zeros(N,1)];                  % 初始化前馈输入为0
simin_d = [t randn(N,1)*0.1];              
simin_v = [t randn(N,1)*1e-9]; 

% 运行仿真采集闭环数据
sim('Sim_MyFirst');

% 提取关键信号
u_total = u.Data;              % 总控制输入(反馈+前馈)
y_output = y.Data;             % 系统输出
r_input = r;                   % 参考轨迹

%% ================= 数据预处理 =================
% 去除瞬态过程（前0.1秒）
idx = t > 0.1;
u_clean = u_total(idx);
y_clean = y_output(idx);
r_clean = r_input(idx);
t_clean = t(idx)';

% 构建输入特征矩阵（包含历史信息）
input_features = [];
output_target = [];
window_size = 5;  % 使用过去5个时刻的信息

for i = window_size+1:length(t_clean)
    % 输入特征：[当前参考, 过去参考(1-4步), 当前输出, 过去输出(1-4步)]
    input_features(i-window_size,:) = [...
        r_clean(i), r_clean(i-1), r_clean(i-2), r_clean(i-3), r_clean(i-4),...
        y_clean(i), y_clean(i-1), y_clean(i-2), y_clean(i-3), y_clean(i-4)];
    
    % 目标输出：当前时刻的理想控制量
    output_target(i-window_size,:) = u_clean(i);
end

% 归一化处理
[input_normalized, input_ps] = mapminmax(input_features');
[output_normalized, output_ps] = mapminmap(output_target');

% 保存数据集
save('nn_training_data.mat',...
     'input_normalized', 'output_normalized',...
     'input_ps', 'output_ps', 't_clean');

%% ================= 数据可视化 =================
figure;
subplot(3,1,1);
plot(t_clean, r_clean, 'b', 'LineWidth', 1);
title('参考轨迹');
grid on;

subplot(3,1,2);
plot(t_clean, y_clean, 'r', 'LineWidth', 1);
title('系统输出');
grid on;

subplot(3,1,3);
plot(t_clean, u_clean, 'k', 'LineWidth', 1);
title('控制输入');
grid on;