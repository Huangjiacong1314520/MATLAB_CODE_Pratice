
%-------------------------------------
%˵��������ͶӰ���ݶȵ���ǰ������ P-GDIFFT
%By: SONG
%-------------------------------------

clear; 
clc; 
close all;
format long g;

ts = 0.0002;  

%����---------
mass  = 477;
num_P = [1];
den_P = [mass 0 0];
P = tf(num_P,den_P);

%����������----
num_Cfb = [179824.76349148  33696607.3425078  876981355.154548];
den_Cfb  = [0.00109873559912302  1  0];
Cfb = tf(num_Cfb,den_Cfb); 


%�Ŷ�----
global theta_true;
theta_true = [23.85 1.4 -2.4 1.9 4.3 1.0 -4.2]'*20;
n = 7;

%�ο��켣-----------
m_reference;

N = length(r); 
t_end = (N-1)*ts;
t = 0:ts:t_end; t = t';

%����Psi_rf-----
tao = 0.012;
w1 = pi/tao; 
w2 = pi/(2/3*tao);
PSI_rf = [a -sin(w1*r) -cos(w1*r) -sin(2*w1*r) -cos(2*w1*r) ...
         -sin(w2*r) -cos(w2*r)];

Z = PSI_rf;
[F,R] = Function_QRdecompos(Z);  %QR�ֽ�  % F = Z;

%--------��ʼ��----------
TIMES = 30;
theta      = zeros(n,TIMES);
uff        = zeros(N,TIMES);
err        = zeros(N,TIMES);
err_norm   = zeros(1,TIMES);
theta_norm = zeros(1,TIMES);
for i = 1:TIMES
    theta(:,i) = [1 0 zeros(1,n-2)]';
end
    
%--------����---------
for j = 1:TIMES
    
    uff(:,j) = PSI_rf*theta(:,j);
    
    %Experiment 
    simin_r = [t r];
    simin_u = [t uff(:,j)];
    simin_d = [t randn(N,1)*0.1]; 
    simin_v = [t randn(N,1)*1e-9]; 
    sim('Sim_singleDOF');
    err(:,j) = r - y;
    
    %����PHI_rf
    flag = 1;
    m_CalculatePHI_rf; 
    
    %���²�����
    Omega_rf = F'*PHI_rf;
    theta(:,j+1) = theta(:,j) + 0.7*inv(Omega_rf)*F'*err(:,j);
    
    %����Norm
    err_norm(j) = norm(err(:,j));
    theta_norm(j) = norm(theta(:,j) - theta_true);
    
    %��ͼ
    set(figure(2),'Name', '����ͶӰ���ݶȷ�P_GDIFFT');
    m_Plot;
end





