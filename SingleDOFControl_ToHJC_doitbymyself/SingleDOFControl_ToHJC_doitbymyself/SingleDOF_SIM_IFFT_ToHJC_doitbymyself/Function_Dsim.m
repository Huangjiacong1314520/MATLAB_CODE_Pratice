%-----------------------------------------
%By:   Fazhi SONG
%Data: 20180518
%˵����
%numΪ���Ӹ��״�ϵ������z�ĸߴ��ݵ��ʹ������У�
%denΪ��ĸ���״�ϵ������z�ĸߴ��ݵ��ʹ������У�
%u:��������
%y:�������
%------------------------------------------

function [ y ] = Function_Dsim( num,den,u)

m = length(num)-1; %���ӽ���
n = length(den)-1; %��ĸ����

num = num/den(1);
den = den/den(1); %��ĸ��ߴ���ϵ����Ϊ1

if m < n
    num = [zeros(1,n-m) num];
end

N = length(u); %���ݳ���

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
% m = length(num)-1; %���ӽ���
% n = length(den)-1; %��ĸ����
% 
% den = den/den(1); %��ĸ��ߴ���ϵ����Ϊ1
% num = num/den(1);
% 
% N = length(u); %���ݳ���
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
% m = length(num)-1; %���ӽ���
% n = length(den)-1; %��ĸ����
% 
% den = den/den(1); %��ĸ��ߴ���ϵ����Ϊ1
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


