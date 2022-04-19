%main
%This script calculate the power produced and local wind speed

clear all
close all

numT=1;

% Support Design variables (which may get optimised)
mp_limit_var = -30;
j_limit_var = -80;
supportLimits = [mp_limit_var, j_limit_var];

% Floris Inputs
hubHeight=167.47;
wind_speed = 15; %freestream wind speed at the farm at hub height (m/s)
density = 1.225; %air density at the hub height
wind_direction = 270; %wind direction in degrees (clockwise+)
yaw_angles = zeros(1,numT); %Nx1 vector of yaw angle "offset" of each turbine
diameters((1:numT)) = 120; %diameter of turbines
location = [0 0 0]; %Mx3 matrix containing coordinates of where to evaluate M values of
... wind speed
pc = readtable('6MW_powercurve.csv'); % power curve
pc = table2array(pc);

% Calculating initial turbine positions
[turbine_centres, TCA] = initTurbPos(numT, hubHeight);


% bathymetry data cost inputs
[A,R] = readgeoraster('hsb.tif','OutputType','double');
latlim = R.LatitudeLimits;
longlim = R.LongitudeLimits;
info = geotiffinfo('hsb.tif');
height = info.Height; % Integer indicating the height of the image in pixels
width = info.Width; % Integer indicating the width of the image in pixels
x = 1:width;
y = 1:height;
[rows,cols] = meshgrid(1:height,1:width);
[ADlat,ADlon] = pix2latlon(info.RefMatrix, rows, cols);

%floris model gives the output of power produced by the wind turbines
[power,speed] = floris(wind_speed, density, wind_direction, ...
    turbine_centres, yaw_angles, diameters, pc, location);

% total power out of floris func
totalPowerMW = sum(power)/1000000 %IN megaWATTS



% LCOE calc
[lev_cost_en] = LCOE(totalPowerMW,numT,TCA,ADlat,ADlon,A,supportLimits)


