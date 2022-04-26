%wrapper module

clear all
close all

%% Plot design space

numT=100;
hubHeight=167.47;
[turbine_centres,~] = initTurbPos(numT, hubHeight);

%% Optimisation

%geographical bounds for the wind farm
LB=111139*[53.7 2.1];
UB=111139*[54 2.8];

%starting point
x0=turbine_centres;

options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed');
[xopt,fopt,exitflag,out,kkt,g,h]=fmincon(@objective1,x0,[],[],[],[],LB,UB,@constraints1,options);

%% Result visualisation

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

%figure 4: LCOE
% figure(4)
% plot(LCOE);
