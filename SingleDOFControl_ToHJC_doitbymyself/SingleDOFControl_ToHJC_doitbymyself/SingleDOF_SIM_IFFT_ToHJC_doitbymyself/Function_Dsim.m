%-----------------------------------------
%By:   Fazhi SONG
%Data: 20180518
%说明：
%num为分子各阶次系数，按z的高次幂到低次幂排列；
%den为分母各阶次系数，按z的高次幂到低次幂排列；
%u:输入向量
%y:输出向量
%------------------------------------------

function [ y ] = Function_Dsim( num,den,u)

m = length(num)-1; %分子阶数
n = length(den)-1; %分母阶数

num = num/den(1);
den = den/den(1); %分母最高次幂系数变为1

if m < n
    num = [zeros(1,n-m) num];
end

N = length(u); %数据长度

u = [zeros(n,1); u];
y = zeros(N+n,1);
for k = n+1:N+n
    for i = 1:n
        psi(i) = -y(k-i);
    end
    for i = n+1:(2*n+1)
        psi(i) = u(k+n+1-i);
    end
    y(k) = psi*[den(2:n+1) num]';
end
u(1:n) = [];
y(1:n) = [];

% function [ y ] = Function_Dsim( num,den,u)
% 
% m = length(num)-1; %分子阶数
% n = length(den)-1; %分母阶数
% 
% den = den/den(1); %分母最高次幂系数变为1
% num = num/den(1);
% 
% N = length(u); %数据长度
% 
% u = [zeros(n,1); u];
% y = zeros(N+n,1);
% for k = n+1:N+n
%     psi = zeros(1,n+m+1);
%     for i = 1:n
%         psi(i) = -y(k-i);
%     end
%     for i = n+1:n+m+1
%         psi(i) = u(k+m+1-i);
%     end
%     y(k) = psi*[den(2:n+1) num]';
% end
% u(1:n) = [];
% y(1:n) = [];


% function [ y_t ] = Function_DsimT( num,den,u,y,t)
% 
% m = length(num)-1; %分子阶数
% n = length(den)-1; %分母阶数
% 
% den = den/den(1); %分母最高次幂系数变为1
% num = num/den(1);
% 
% u = [zeros(n,1); u(1:t)];
% y = [zeros(n,1); y(1:t)];
% 
% k = n + t;
% 
% psi = zeros(1,n+m+1);
% for i = 1:n
%     psi(i) = -y(k-i);
% end
% for i = n+1:n+m+1
%      psi(i) = u(k+m+1-i);
% end
% y(k) = psi*[den(2:n+1) num]';
% 
% y_t = y(k);
% 
% end


