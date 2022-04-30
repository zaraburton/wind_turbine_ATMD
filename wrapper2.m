%wrapper module 2 - ga
%warning: this takes time to run!
clear all
close all

%% Initialisation

numT=100;
hubHeight=167.47;
[turbine_centres,~] = initTurbPos(numT, hubHeight);
x = turbine_centres(:,1:2);
%% Optimisation

%geographical bounds for the wind farm
LB=zeros(numT,2);
UB=zeros(numT,2);

LB(:,1) = 111139*ones(numT,1)*2.1;
LB(:,2) = 111139*ones(numT,1)*53.7;
UB(:,1) = 111139*ones(numT,1)*2.8;
UB(:,2) = 111139*ones(numT,1)*54.0;

X0 = x; % Start point (row vector)
options.InitialPopulationMatrix = X0;

options = optimoptions('ga','Display','iter','PlotFcn',{'gaplotbestf','gaplotstopping'});
rng default
[xopt,fopt,exitflag,output] = ga(@objective1,2,[],[],[],[],LB,UB,[],options);
%% Visualisation

fprintf('The number of generations was : %d\n', output.generations);
fprintf('The number of function evaluations was : %d\n', output.funccount);
fprintf('The best function value found was : %g\n', fopt);
% %figure 1: default position
% figure(1)
% plot(x0(:,1)/111139,x0(:,2)/111139,'bd');
% title('Default position');
% xlabel('Longtitude'), ylabel('Latitude');
% 
% %figure 2: optimised position
% figure(2)
% plot(xopt(:,1)/111139,xopt(:,2)/111139,'rd');
% title('Optimised position');
% xlabel('Longtitude'), ylabel('Latitude');
% 
% %figure 3: position together
% figure(3)
% hold
% plot(x0(:,1)/111139,x0(:,2)/111139,'bd');
% plot(xopt(:,1)/111139,xopt(:,2)/111139,'rd');
% title('Both');
% xlabel('Longtitude'), ylabel('Latitude');
% legend('default position','optimised position');
% 
% %figure 4: LCOE
% % figure(4)
% % plot(LCOE);