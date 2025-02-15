clear; 
clc; 
close all;

load('Generate_Data_NN_Input.mat')
load('Generate_Data_NN_Outputput.mat')
Combined_Input = [y];

%% 把生成的结构体导出
save('results.mat', 'results');
% 并复制粘贴到下一个文件夹中
save('E:\A_Motion_Control_Team\MATLAB_CODE_Pratice\MATLAB_NN_Toolbox\3NN_generate_ControlSignal\results.mat', 'results');
save('E:\A_Motion_Control_Team\MATLAB_CODE_Pratice\MATLAB_NN_Toolbox\3NN_generate_ControlSignal\Combined_Input.mat', 'Combined_Input');