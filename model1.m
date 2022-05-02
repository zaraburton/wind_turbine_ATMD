function [costTurbPos,lev_cost_en,power]=model1(x0)


    % calculating number of turbines from x0 input
    numT = length(x0(:,1));
    
    
    % Calculating turbine position input arrays for floris and cost functions
    [florisTurbPos,costTurbPos] = TurbPos2(x0);
    
     % Support Design variables (which may get optimised)
    mp_limit_var = -100;
    j_limit_var = -160;
    supportLimits = [mp_limit_var, j_limit_var];
    
     % Floris Inputs
    wind_speed = 15.3283; %freestream wind speed at the farm at hub height (m/s)
    density = 1.225; %air density at the hub height
    wind_direction = 248.7403; %wind direction in degrees (clockwise+)
    yaw_angles = zeros(1,numT); %Nx1 vector of yaw angle "offset" of each turbine
    diameters((1:numT)) = 200; %diameter of turbines
    location = florisTurbPos; %Mx3 matrix containing coordinates of where to evaluate M values of
    ... wind speed
%     pc = readtable('6MW_powercurve.csv'); % power curve
%     pc = table2array(pc);
    pc=csvread('11MW_powercurve.csv',1,0);
    
    % bathymetry data cost inputs
    bath=getGlobalB;
    a=getGlobalA;
    
    %floris model gives the output of power produced by the wind turbines
    [power,speed] = floris(wind_speed, density, wind_direction, ...
        florisTurbPos, yaw_angles, diameters, pc, location);
    
    % total power out of floris func
    totalPowerMW = sum(power)/1000000; %IN megaWATTS
    
   
    % LCOE calc (in £/MWhr)
    [lev_cost_en] = LCOE(totalPowerMW,numT,costTurbPos,bath(:,1:251),bath(:,252:502),a,supportLimits);

    %LCOE history
    
end