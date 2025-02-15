%% MAIN_PGNN.m 
% This model performs the PGNN training according to the specified
% settings following the structure:
%   1. Load and prepare data set;
%   2. Perform physics-based system identification (currently linear-in-the-parameters);
%   3. (PG)NN identification:
%       3.1. Initialize a (PG)NN with random weights, and optionally perform
%            the optimal initialization. 
%       3.2. Perform training using regularized cost function.
%       3.3. Save the trained (PG)NNs.
%   4. (PG)NN validation:
%       4.1. Show feedforward of trained PGNN.
%       4.2. Show regularization effect (when multiple regularization
%            parameters are inputted) in figures: lambda--MSE(validation),
%            L-curve.
% IMPORTANT: when first running this file, make sure that the variables
% "dataPath" and "fileName" contain the correct path and name of the
% input-output data file.
%
% For more information, see the accompanying paper: M. Bolderman, M. Lazar,
% H. Butler, "A MATLAB toolbox for training and implementing physics-guided
% neural network-based feedforward controllers", 2022. 
%
%--------------------------------------------------------------------------
% Author:   Max Bolderman,
% Contact:  m.bolderman@tue.nl.
% Affiliation: Control Systems Group, Eindhoven University of Technology. 
%--------------------------------------------------------------------------

%% MAIN_PGNN.m
% 该模型根据指定的设置按照以下结构执行 PGNN 训练：
%   1. 加载并准备数据集；
%   2. 执行基于物理的系统辨识（目前是参数线性的）；
%   3. (PG)NN 辨识：
%       3.1. 用随机权重初始化一个 (PG)NN，并可选择地执行最优初始化。
%       3.2. 使用正则化代价函数进行训练。
%       3.3. 保存训练好的 (PG)NN。
%   4. (PG)NN 验证：
%       4.1. 展示训练好的 PGNN 的前馈过程。
%       4.2. 在图中展示正则化效果（当输入多个正则化参数时）：lambda--MSE（验证），L 曲线。
% 重要提示：首次运行此文件时，请确保变量 “dataPath” 和 “fileName” 包含输入输出数据文件的正确路径和名称。
%
% 有关更多信息，请参阅随附的论文：M. Bolderman, M. Lazar, H. Butler, “用于训练和实现基于物理引导神经网络的前馈控制器的 MATLAB 工具箱”，2022 年。
%--------------------------------------------------------------------------
% 作者：Max Bolderman，
% 联系方式：m.bolderman@tue.nl。
% 所属机构：埃因霍温理工大学控制系统的团队。
%--------------------------------------------------------------------------

clear all; close all; clc; 



%--------------------------------------------------------------------------
%% BEGIN MODEL
%--------------------------------------------------------------------------

%% SPECIFY SETTINGS  
% 指定设置
%--------------------------------------------------------------------------
% Data
dataPath = '<insert data path>';
                                 % Location of the data file
fileName = 'IOData';

% PGNN settings
n_a = 5; n_b = 1; n_k = 2;      % Order of the dynamics
networkSize         = [16];     % 定义神经网络中每个隐藏层的神经元数量。例如，[16] 表示一个隐藏层有 16 个神经元。Specify the number of neurons per hidden layer, e.g., [16, 16] gives two 16-neuron layers
typeOfTransform     = 1;        % 被输入到 基于物理的转换 中的回归器类型 Type of regressor as inputted in the physics-based transform.

% Training settings
lambda              = logspace(-5, 1, 20);% 定义正则化参数λ的不同值，用于控制正则化项的强度。（这里采用对数间距分布）
lambda_phy          = 1;        %对物理模型的参数进行 L2 正则化。       L2正则化物理参数w.r.t的偏差。L2 regularize the deviation of the physical parameters w.r.t.       利用物理模型得到的物理参数，插入一个标量或具有维度的物理参数列physical parameters obtained using physical model, insert a scalar or a column with dimension of physical parameters
lambda_NN           = 0.1;      % 对神经网络的参数进行 L2 正则化。    L2 regularize the NN parameters, input a scalar or a column with dimension of the NN params
     %定义物理一致性正则化项的参数 γ，分别用于训练数据集 ZN 和物理一致性数据集 ZE。
gamma_ZN            = 0;        % PINNs regularization
gamma_ZE            = 0;        % PINNs regularization for evaluated over ZE
reg_params = {lambda_phy, lambda_NN, gamma_ZN, gamma_ZE};%将正则化参数存储为一个元胞数组。

% Specialized settings (type of training, data processing)
partValData         = 0.3;      % 定义用于验证的训练数据集的比例，这里为 30%。Part of the data that is used for validation
downSampling        = 1;        % 下采样因子，即每<下采样>点保留1点。Factor to downsample, i.e., keep 1 point every <downSampling> points
numberOfTrainings   = 20;       % 为每个配置执行的独立训练数，然后选择表现最好的一个。Number of independent trainings to be performed for each configuration, after which the best performing one is chosen
useInitialization   = 1;        % 是否使用优化的参数初始化。If == 1 ->使用优化的初始化更新初始化NN参数，If == 0 ->不更新初始化NN参数If == 1 -> update initial (PG)NN parameters using optimized initialization, if == 0 -> do not
randomInitAlways    = 0;        % 是否在每次训练时始终进行随机初始化。If == 1 ->随机初始化训练，If == 0 ->使用先前训练的PGNN的tathat初始化（当选择多个lambda值时）。If == 1 -> initialize training randomly, if == 0 -> initialize using thetahat of the previously trained PGNN (when multiple values for lambda are chosen)

% To be implemented
typeOfInverse       = 0;        % 定义逆模型的类型0: Direct inverse ARX, 1: Direct forward ARX; 2: Direct inverse OE; 3: Direct forward OE; etc.





%% 1. LOAD AND PREPARE DATA SET
%--------------------------------------------------------------------------
fprintf('1/4. Load and prepare data.\n');
addpath(dataPath); load(fileName); rmpath(dataPath);    % Load the data
Ts = (t(end)-t(1))/(length(t)-1);       % Compute sampling time

% Construct phi and output
[phi, output, phi_val, output_val, phi_E] = generatePhiOutput(u, y, [n_a,n_b,n_k], typeOfInverse, partValData, reg_params, Ts);
% Downsample the amount of training data to allow for quick training
phi = phi(:, 1:downSampling:size(phi,2)); output = output(:, 1:downSampling:size(output,2));

%% 2. PERFORM PHYSICS-BASED ID AND INITIALIZE NN
%--------------------------------------------------------------------------
fprintf('2/4. Perform physics-based identification.\n');
% Perform identification of the physics-based parameters
theta_PGstar = identifyPhysicsBasedParameters(phi, output, Ts, typeOfTransform);
save(['theta_PG_ToT',num2str(typeOfTransform)], 'theta_PGstar');



%% 3. PERFORM PGNN TRAININGS
%--------------------------------------------------------------------------
fprintf('3/4. Perform PGNN training:\n');
for ii = 1:1:size(lambda, 2)
    fprintf(['  ', num2str(ii), '/', num2str(size(lambda,2)), ' regularizations:\n']);
    if ((ii == 1) || (randomInitAlways == 1))   % If training is performed for the first time, do regular training
        for jj = 1:1:numberOfTrainings
            fprintf(['      ', num2str(jj), '/', num2str(numberOfTrainings), ' trainings: ']);
            % Initialize PGNN
            [theta_0, n_params] = PGNN_Initialize(output, phi, phi_E, Ts, typeOfTransform, theta_PGstar, networkSize, lambda(ii), reg_params, useInitialization);     
            fprintf([' initialized X']);
            % Train PGNN
            [theta(:,jj), resNorm(jj), resNormVal(jj)] = PGNN_Optimization(output, phi, output_val, phi_val, phi_E, Ts, typeOfTransform, theta_0, theta_PGstar, networkSize, n_params, lambda(ii), reg_params);
            fprintf([', trained X.\n']);
        end
    else% Initialize according to parameters obtained for previous value of regularization parameter lambda
        % Observe: we do not use random initialization and the solver is
        % deterministic, hence we only require one training.
        fprintf(['      1/1: use thetahat of previous lambda for initialization.\n']);
        clear theta resNorm resNormVal;     % Clear these variables, to ensure correct dimensions
        % Initialize theta_0 using thetahat of previous lambda
        %load(['PGNN_ARX_', num2str(networkSize), '_Phi', num2str(typeOfTransform), '_lambda', num2str(ii-1)]);
        load(['PGNN_ARX_', num2str(ii-1)]);
        theta_0 = thetahat;
        % Train PGNN
        [theta, resNorm, resNormVal] = PGNN_Optimization(output, phi, output_val, phi_val, phi_E, Ts, typeOfTransform, theta_0, theta_PGstar, networkSize, n_params, lambda(ii), reg_params);
    end
    % Save the trained PGNN
    [~, best] = min(resNorm); thetahat = theta(:, best);
    %save(['PGNN_ARX_', num2str(networkSize), '_Phi', num2str(typeOfTransform), '_lambda', num2str(ii)], 'thetahat', 'networkSize', 'n_params', 'Ts');
    save(['PGNN_ARX_', num2str(ii)], 'thetahat', 'networkSize', 'n_params', 'Ts')
end



%% 4. VISUALIZE AND VALIDATE RESULTS
%--------------------------------------------------------------------------
fprintf('4/4. Visualize and validate results.\n');
visualize_Results;








