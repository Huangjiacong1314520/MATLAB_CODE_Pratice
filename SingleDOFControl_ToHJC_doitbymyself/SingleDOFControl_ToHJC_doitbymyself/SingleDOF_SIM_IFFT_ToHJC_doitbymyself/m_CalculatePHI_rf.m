
%-------------数据驱动方式：基于迭代实验的估计方法----------------
%以下为连续方式
Cff = tf([theta(1,j)' 0 0],1);

C1 = 1/(Cfb + Cff)*tf([1 0 0],1);
C1d = c2d(C1,ts,'tustin');

C3 = 1/(Cfb);
C3d = c2d(C3,ts,'tustin');
    
[num,den] = tfdata(C1d);
num_C1d = cell2mat(num);
den_C1d = cell2mat(den);

[num,den] = tfdata(C3d);
num_C3d = cell2mat(num);
den_C3d = cell2mat(den);

PHI_rf(:,1) = Function_Dsim( num_C1d,den_C1d,y);

for i = 2:n
	PHI_rf(:,i)= Function_Dsim( num_C3d,den_C3d,PSI_rf(:,i));
end
        
  










