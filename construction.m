%wind farm construction
%This script construct a basic windfarm in a 1*1 area

clear all
close all

n=input('How many turbines in the area?');
r=rand(n,3);

% max_lat=54; min_lat=53.7;
% max_lon=2.8; min_lon=2.1;

figure
patch([0 1 1 0],[0 0 1 1],[0.9 0.9 0.9]);
hold
for i=1:n
    plot3(r(i,1),r(i,2),r(i,3),'x','Markersize',10);
end
