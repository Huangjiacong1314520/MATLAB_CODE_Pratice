
set(gcf,'Units','centimeters','Position',[2 5 35 20]);

subplot(231);
if(j==1)||(j==2)||(j==10)
	plot(t,err(:,j)); hold on;
end
xlabel('Time (s)'); ylabel('Tracking error (m)');
xlim([0 t_end+0.02]);ylim([-1.5e-4 1.5e-4]);

subplot(234);
plot(1:j,err_norm(1:j),'k','linewidth',1.2); 
xlabel('Iteration'); 
ylabel('Norm (m^2)');
xlim([1 TIMES]);
ylim([0 1.7e-3]);

subplot(232);
plot(1:j,theta(1,1:j),'b','linewidth',1.2);       hold on;
plot(1:TIMES,theta_true(1)*ones(1,TIMES),'k-.');  hold off;
xlabel('Iteration '); ylabel('Estimates');
xlim([1 TIMES]);
% ylim([0 500]);

subplot(233);
f1 = plot(1:j,theta(2,1:j),'r','linewidth',1.2); hold on;
plot(1:j,theta(3,1:j),'r','linewidth',1.2); 
f2 = plot(1:j,theta(4,1:j),'b','linewidth',1.2); 
plot(1:j,theta(5,1:j),'b','linewidth',1.2); 
plot(1:TIMES,theta_true(2)*ones(1,TIMES),'k-.');
plot(1:TIMES,theta_true(3)*ones(1,TIMES),'k-.');
plot(1:TIMES,theta_true(4)*ones(1,TIMES),'k-.');
plot(1:TIMES,theta_true(5)*ones(1,TIMES),'k-.'); hold off;
xlabel('Iteration '); ylabel('Estimates');
xlim([1 TIMES]);
ylim([-300 200]);
set(legend([f1 f2],'$w_1$','$2w1$'),'Interpreter','latex','FontSize',9,'Box','off','Location','Best');

subplot(236);
f3 = plot(1:j,theta(6,1:j),'r','linewidth',1.2); hold on;
plot(1:j,theta(7,1:j),'r','linewidth',1.2); 
plot(1:TIMES,theta_true(6)*ones(1,TIMES),'k-.');
plot(1:TIMES,theta_true(7)*ones(1,TIMES),'k-.'); hold off;
xlabel('Iteration '); ylabel('Estimates');
xlim([1 TIMES]);
ylim([-280 100]);
set(legend([f3],'$w_2$'),'Interpreter','latex','FontSize',9,'Box','off','Location','Best');

subplot(235);
plot(1:j,theta_norm(1:j),'k','linewidth',1.2); 
xlabel('Iteration'); 
ylabel('Norm');
xlim([1 TIMES]); 
% ylim([0 700]);