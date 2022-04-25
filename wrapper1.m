%wrapper module

clear all
close all

%% Plot design space

%geographical bounds for the wind farm
LB=111139*[53.7 2.1];
UB=111139*[54 2.8];

%% Optimisation

%starting point
x0=111139*[53.9 2.7];

options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed');
[xopt,fopt,exitflag,out,kkt,g,h]=fmincon(@(objective1)0,x0,[],[],[],[],LB,UB,@constraints1,options);