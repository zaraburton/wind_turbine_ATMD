% input shit

% importing bathymetry data, setting random turbine coordinates, and
% calculating water depth at each point
[A,R] = readgeoraster('hsb.tif','OutputType','double');
latlim = R.LatitudeLimits;
longlim = R.LongitudeLimits;

info = geotiffinfo('hsb.tif');
height = info.Height; % Integer indicating the height of the image in pixels
width = info.Width; % Integer indicating the width of the image in pixels
x = 1:width;
y = 1:height;

max_lat = 54; 
min_lat = 53.7; 
max_long = 2.8; 
min_long = 2.1;

TCA = zeros([300,4]);%main turbine cost array 

for t=1:300 %for turbine 1 - turbine 300
    
    % set y/longtitude coord 
    TCA(t,2)= min_long + (max_long-min_long).*rand();
    
    % set x/latitide coord
    TCA(t,1)= min_lat + (max_lat-min_lat).*rand();
    
end

TCA;

[rows,cols] = meshgrid(1:height,1:width);
[ADlat,ADlon] = pix2latlon(info.RefMatrix, rows, cols);

%%
%seaDepthData = [ADlat, ADlon, A]
%TCA = TURBINE CENTER ARRAY

num_t = 300; %number of turbines
tca_one = [53.9717375811227,2.67030658047523];

power = 3.5*num_t;  % 3.5MW for 1 turbine

% Design variables (which get optimised)
mp_limit_var = -30;
j_limit_var = -80;
supportLimits = [mp_limit_var, j_limit_var];


%[lev_cost_en] = LCOE(power,num_t,TCA,ADlat,ADlon,A,supportLimits)

%function [LCOE] = LCOE(power,num_t,TCA,ADlat,ADlon,A,supportLimits)
%LCOE in MWH/EURO
%   Detailed explanation goes here
    
 
% ------- SUPPORT COSTS -------%

    % interpolate mesh grid of bathymetry data to get water depths at each
    % turbine location
    TCA(:,3) = interp2(ADlat, ADlon, A.', TCA(:,1), TCA(:,2));
    
    %split TCA based on depth values, to get seperate arrays of depths for
    %different turbine types
    mp_tca = TCA(TCA(:,3)>=supportLimits(1),:);  % monopile turbines

    j_tca = TCA(TCA(:,3)>=supportLimits(2),:); % jacket turbine array
    
    
    %cost of support types - from minimalistic cost model 
gp = 6; %installed generator power in MW (6MW used on site)
c_t = 1.25*(-0.15+0.92*gp) %cost of wind turbine

%support structure cost equations (for reference, not used in code)
d = 25; %water depth in m
c_mp = (gp*(d*d +100*d +1500))/7500; %monopile
c_j = (gp*(0.5*(d*d)-35*d+2500))/7500; %jacket support structure

mpd = abs(mp_tca(:,3)); %monopile depth
mp_tca(:,4) = ((gp*(mpd.^2 +100*mpd +1500))/7500)*1000000; % cost of monopile support in euros

%total monopile turbine support costs
tot_mp = sum(mp_tca(:,4),"all");

jd = abs(j_tca(:,3)); %jacket depth
j_tca(:,4) = ((gp*(0.5*(jd.^2)-35*jd+2500))/7500)*1000000; %jacket support structure in euros

% total jacket turbine support cost
tot_j = sum(j_tca(:,4),"all");

%  Total support structure cost (in euros)
tot_support_cost = tot_mp + tot_j;


%----- ELECTRICAL COSTS -------%
% cable lengths
c66_len = num_t*1000; %in m
c120_len = 45000;
%cost per m of cable (pounds/m)*1.21 ==> euro/m
c66_cm = 300*1.21;
c120_cm = 500*1.21;

%cost of each cable material
c_c66 = c66_cm*c66_len;
c_c120 = c120_cm*c120_len;

%cable instialltion 
ci_ppm = 300*1.21; %pounds per m*euro
c_ci = ci_ppm*(c66_len+c120_len); %cost of cable instilation  (ASSUMING £1 = £1.21)


% substation costs inc instillation (pounds)*euros
c_offs_subs = 6500000*1.21;
c_ons_subs = 4000000*1.21;

% number of substations
numOffS = 4;
numOnS = 1;

totalElectricalCosts = c_ons_subs*numOnS + c_offs_subs*numOffS + c_ci + c_c66 + c_c120;

%------- Other turbine materials & instilation cost ------%
% turbine part costs (in pounds)
RN = 7000000*1.21; % rotor & nacelle
instl = 1800000*1.21; % instilation of turbine, support & foundation 
matInstCost = (RN + instl)*num_t; % totoal other part & instl cost

%------- Other costs ------%
pm_c = 37500000*1.21; % project management costs
proj_cost_nc = tot_support_cost + matInstCost + totalElectricalCosts + pm_c; % prject cost w/o contingency
CAPEX = proj_cost_nc*1.1; % CAPEX = set up costs for whole project + 10% contigency  (£)
% percentage of cost to support (not included contgency)
%su_found_percent = ((sup_found*num_t)/proj_cost_nc)*100;

% OPEX
% assumed to be 3% of capex per yer    (£/MW/yr)
OPEX = (CAPEX*0.03)/(gp*num_t);

% OPEX cash flow each yr
yrs = 20;
inflation = 0.02;
cash = zeros([1,yrs]); 
cash(1) = CAPEX;
cash(2) = num_t*gp*OPEX*(1+inflation);
for yr = 3:yrs
    %cash(1,yr) = energy_strike_yr1*((inflation)^(yr-1))*production %cash in each year
    cash(yr) = num_t*cash(yr-1)*(1+inflation); % cash out each yr (excluding CAPEX)
end
cash;
nvpCost = pvvar(cash, 0.1);

%% need AEY (annual energy yield) = power (watt) * hrs in yr

AEY = 8760*power; % hours in a year * power (MW)
yrlyEnergy = AEY*ones([1,yrs]);
nvpEnergy = pvvar(yrlyEnergy, 0.1);


LCOE = nvpCost/nvpEnergy
%end

 