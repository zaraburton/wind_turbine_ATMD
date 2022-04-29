%wrapper module 2 - ga
%warning: this takes time to run!
clear all
close all

%% Initialisation

numT=5;
hubHeight=167.47;
[turbine_centres,~] = initTurbPos(numT, hubHeight);

%% Optimisation

%geographical bounds for the wind farm
LB=zeros(numT,2);
UB=zeros(numT,2);

LB(:,1) = 111139*ones(numT,1)*2.1;
LB(:,2) = 111139*ones(numT,1)*53.7;
UB(:,1) = 111139*ones(numT,1)*2.8;
UB(:,2) = 111139*ones(numT,1)*54.0;

options = optimoptions('ga','Display','iter');
[xopt,fopt]=ga(@objective1,2);

%% Visualisation

%figure 1: default position
figure(1)
plot(x0(:,1)/111139,x0(:,2)/111139,'bd');
title('Default position');
xlabel('Longtitude'), ylabel('Latitude');

%figure 2: optimised position
figure(2)
plot(xopt(:,1)/111139,xopt(:,2)/111139,'rd');
title('Optimised position');
xlabel('Longtitude'), ylabel('Latitude');

%figure 3: position together
figure(3)
hold
plot(x0(:,1)/111139,x0(:,2)/111139,'bd');
plot(xopt(:,1)/111139,xopt(:,2)/111139,'rd');
title('Both');
xlabel('Longtitude'), ylabel('Latitude');
legend('default position','optimised position');

%figure 4: LCOE
% figure(4)
% plot(LCOE);