%main
%This script calculate the power produced and local wind speed

% clear all
close all

wind_speed = 10; %freestream wind speed at the farm at hub height
density = 1.225; %air density at the hub height
wind_direction = 270; %wind direction in degrees (clockwise+)
turbine_centres = r; %Nx3 matrix of each turbine
yaw_angles = zeros(300,1); %Nx1 vector of yaw angle "offset" of each turbine
diameters(1:300,1) = 125; %diameter of turbines
% power_curve = ; %2-column matrix containing list of points on the P.C.
location = [0 0 0]; 
%Mx3 matrix containing coordinates of where to evaluate M values of
... wind speed

pc = readtable('V80_powercurve.csv');
pc = table2array(pc);
% xq=0:1:26;
% x=table2array(pc(:,1));
% y=table2array(pc(:,2));
% Vq = interp1(x,y,xq,'linear');

[output(:,1),output(:,2)] = floris(wind_speed, density, wind_direction, ...
    turbine_centres, yaw_angles, diameters, pc, location);