%-------S��������---------
% dx = A*x + B*u
% y  = C*x
% ����A = [0 1;0 0],B = [0;cos(pi*t)],C = 1,��ʼ״̬���ⲿ����

function [sys,x0,str,ts,simStateCompliance] = sfun_Cogging(t,x,u,flag)

switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;

  %%%%%%%%%%%%%%%
  % Derivatives % 
  % ��������״̬��΢��
  %%%%%%%%%%%%%%%
  case 1,  
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%
  % Update %
  % ������һ����ɢ״̬
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  % �������
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes

sizes = simsizes;

sizes.NumContStates  = 0;  % ģ������״̬�����ĸ���
sizes.NumDiscStates  = 0;  
sizes.NumOutputs     = 1;  % ģ����������ĸ���
sizes.NumInputs      = 1;  % ģ����������ĸ���
sizes.DirFeedthrough = 1;  % ģ���Ƿ����ֱ�ӹ�ͨ��ֱ�ӹ�ͨ�ҵ������������ֱ�ӿ�������� ����״̬����DΪ��ʲ�����
sizes.NumSampleTimes = 1;  % at least one sample time is needed
sys = simsizes(sizes);     % ������󸳸�sys���
x0  = [];                  % ��ֵ
str = [];                  % �������� str is always an empty matrix
ts  = [0 0];               % ����������Ϊ0��ʾ������ϵͳ initialize the array of sample times

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'DisallowSimState' < Error out when saving or restoring the model sim state
simStateCompliance = 'UnknownSimState';

%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
% ��������״̬��΢��
function sys=mdlDerivatives(t,x,u)

sys  = [];


%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

sys = [];

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
% �������
function sys=mdlOutputs(t,x,u)

global theta_true; 

tao = 0.012;
w1 = pi/tao; 
w2 = pi/(2/3*tao);

sys = theta_true(2)*sin(w1*u)    + theta_true(3)*cos(w1*u) + ...
      theta_true(4)*sin(2*w1*u)  + theta_true(5)*cos(2*w1*u) + ...
      theta_true(6)*sin(w2*u)   + theta_true(7)*cos(w2*u) ;
  




%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];


