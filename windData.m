 ()%This script gives the averaged wind speed and direction

clear all
close all

wd = readtable('wd.csv');
wd = table2array(wd);

x = wd(2:61,1).*wd(2:61,2:49).*sin(wd(1,2:49));
y = wd(2:61,1).*wd(2:61,2:49).*cos(wd(1,2:49));

xsum = sum(x,'All');
ysum = sum(y,'All');

speed = sqrt(xsum^2+ysum^2);
direction = 270-rad2deg(tan(xsum/ysum));

