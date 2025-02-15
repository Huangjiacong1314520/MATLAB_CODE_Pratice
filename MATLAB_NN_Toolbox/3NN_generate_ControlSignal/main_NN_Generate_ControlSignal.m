clear; 
clc; 
close all;

%将文件夹中训练好的神经网络导入到工作区中
load('results.mat')
%将想要达到的效果（参考轨迹）导入工作区中，后续作为神经网络输入，用于生成控制信号
load('Reference.mat')
%用于测试的输入信号是r
Test_Input=r;
%r是列向量还是横向量也很重要，不然维度对不上
Test_Input = Test_Input'; % 将列向量转置为行向量
%% 

%运行神经网络（访问结构体中的字段）
% 访问 NN_results 中的 Network 字段
net = results.Network;

ControlSignal=sim(net,Test_Input);

%把工作区中的变量导出
save('ControlSignal.mat', 'ControlSignal');   
%并复制粘贴到下一个文件夹中
save(['E:\A_Motion_Control_Team\MATLAB_CODE_Pratice\MATLAB_NN_Toolbox\4NN_Cff_test\' ...
    'ControlSignal.mat'], 'ControlSignal'); 